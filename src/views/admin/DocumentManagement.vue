<script setup>
import { ref, onMounted, computed } from 'vue'
import { Plus, Edit, Trash2, X, Search, Save, AlertTriangle, Eye, Loader2 } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import documentApi from '@/api/documentApi'

const isLoading = ref(false)
const searchQuery = ref('')
const documents = ref([])
const docCategories = ref([])

const isModalOpen = ref(false)
const isConfirmOpen = ref(false)
const modalMode = ref('create')
const targetDeleteId = ref(null)
const saving = ref(false)

const initialForm = { id: null, title: '', categoryId: '', driveUrl: '', description: '', isPublic: true }
const form = ref({ ...initialForm })

const fetchData = async () => {
  isLoading.value = true
  try {
    const [catRes, docRes] = await Promise.allSettled([
      documentApi.categories(),
      documentApi.searchAdmin({ keyword: searchQuery.value })
    ])
    if (catRes.status === 'fulfilled') docCategories.value = catRes.value?.data || []
    if (docRes.status === 'fulfilled') documents.value = docRes.value?.data?.content || docRes.value?.data || []
  } catch (error) {
    console.error('Error fetching documents:', error)
    documents.value = []
    docCategories.value = []
  } finally { isLoading.value = false }
}
onMounted(fetchData)

const filtered = computed(() => {
  if (!searchQuery.value) return documents.value
  const q = searchQuery.value.toLowerCase()
  return documents.value.filter(d => d.title?.toLowerCase().includes(q))
})

const getCatName = (d) => d.category || docCategories.value.find(c => c.id === d.categoryId)?.name || '—'

const openCreate = () => { modalMode.value = 'create'; form.value = { ...initialForm }; isModalOpen.value = true }
const openEdit = (d) => { modalMode.value = 'edit'; form.value = { ...d }; isModalOpen.value = true }
const closeModal = () => { isModalOpen.value = false }

const saveDocument = async () => {
  if (!form.value.title || !form.value.driveUrl) { toast.error('Tiêu đề và Drive URL là bắt buộc!'); return }
  saving.value = true
  try {
    if (modalMode.value === 'create') { await documentApi.create(form.value); toast.success('Thêm tài liệu thành công!') }
    else { await documentApi.update(form.value.id, form.value); toast.success('Cập nhật thành công!') }
    closeModal(); fetchData()
  } catch (error) {
    console.error('Error saving document:', error)
    const msg = error.response?.data?.message || 'Có lỗi xảy ra khi lưu tài liệu!'
    toast.error(msg)
  } finally { saving.value = false }
}

const triggerDelete = (id) => { targetDeleteId.value = id; isConfirmOpen.value = true }
const confirmDelete = async () => {
  try { await documentApi.delete(targetDeleteId.value) } catch {}
  documents.value = documents.value.filter(d => d.id !== targetDeleteId.value)
  toast.success('Đã xoá!'); isConfirmOpen.value = false
}
</script>

<template>
  <div class="admin-page animate-in">
    <div class="page-header">
      <div><h2>Quản lý Tài liệu</h2><p class="subtitle">Brochure, catalogue, báo giá, tài liệu kỹ thuật</p></div>
      <div class="page-actions">
        <div class="search-wrapper"><Search :size="16" class="search-icon" /><input v-model="searchQuery" placeholder="Tìm tài liệu..." /></div>
        <button class="btn btn-primary" @click="openCreate"><Plus :size="16" /> Thêm mới</button>
      </div>
    </div>

    <div class="card">
      <div v-if="isLoading" class="loading-overlay"><div class="spinner"></div></div>
      <div v-else class="table-wrap">
        <table class="data-table">
          <thead><tr>
            <th>Tiêu đề</th><th style="width:110px">Phân loại</th>
            <th>Drive URL</th><th class="text-center" style="width:80px">Lượt tải</th>
            <th class="text-center" style="width:100px">Công khai</th>
            <th class="text-right" style="width:100px">Thao tác</th>
          </tr></thead>
          <tbody>
            <tr v-if="filtered.length === 0"><td colspan="6"><div class="empty-state"><p>Chưa có tài liệu nào</p></div></td></tr>
            <tr v-for="d in filtered" :key="d.id">
              <td><span class="font-medium">{{ d.title }}</span><br/><span class="text-xs text-muted">{{ d.description?.substring(0, 50) }}</span></td>
              <td><span class="badge badge-category">{{ getCatName(d) }}</span></td>
              <td><a :href="d.driveUrl" target="_blank" class="text-primary text-sm" style="text-decoration:underline">{{ d.driveUrl?.substring(0, 35) }}...</a></td>
              <td class="text-center text-sm text-muted font-bold">{{ d.downloadCount || 0 }}</td>
              <td class="text-center">
                <span :class="['badge', d.isPublic ? 'badge-active' : 'badge-inactive']">{{ d.isPublic ? 'Công khai' : 'Riêng tư' }}</span>
              </td>
              <td>
                <div class="row-actions">
                  <button class="act-btn" @click="openEdit(d)" title="Sửa"><Edit :size="16" /></button>
                  <button class="act-btn danger" @click="triggerDelete(d.id)" title="Xoá"><Trash2 :size="16" /></button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="isModalOpen" class="modal-overlay" @click.self="closeModal">
      <div class="modal-box">
        <div class="modal-head"><h3>{{ modalMode === 'create' ? 'Thêm Tài liệu' : 'Cập nhật Tài liệu' }}</h3><button class="act-btn" @click="closeModal"><X :size="20" /></button></div>
        <div class="modal-body">
          <div class="form-group"><label>Tiêu đề <span class="text-danger">*</span></label><input v-model="form.title" class="form-control" placeholder="Nhập tên tài liệu..." /></div>
          <div class="form-row">
            <div class="form-group"><label>Phân loại</label>
              <select v-model="form.categoryId" class="form-control">
                <option value="">— Chọn —</option>
                <option v-for="c in docCategories" :key="c.id" :value="c.id">{{ c.name }}</option>
              </select>
            </div>
            <div class="form-group" style="justify-content:flex-end"><label class="form-check"><input type="checkbox" v-model="form.isPublic" /> Công khai</label></div>
          </div>
          <div class="form-group"><label>Drive URL <span class="text-danger">*</span></label><input v-model="form.driveUrl" class="form-control" placeholder="https://drive.google.com/..." /></div>
          <div class="form-group"><label>Mô tả</label><textarea v-model="form.description" class="form-control" rows="3" placeholder="Mô tả tài liệu..."></textarea></div>
        </div>
        <div class="modal-foot">
          <button class="btn btn-outline" @click="closeModal">Huỷ</button>
          <button class="btn btn-primary" @click="saveDocument" :disabled="saving"><Save :size="16" /> Lưu</button>
        </div>
      </div>
    </div>

    <!-- Confirm -->
    <div v-if="isConfirmOpen" class="modal-overlay" @click.self="isConfirmOpen = false">
      <div class="confirm-box">
        <div class="icon"><AlertTriangle :size="44" /></div>
        <h3>Xoá tài liệu?</h3><p>Tài liệu sẽ bị xoá vĩnh viễn.</p>
        <div class="actions"><button class="btn btn-outline" @click="isConfirmOpen = false">Huỷ</button><button class="btn btn-danger" @click="confirmDelete">Đồng ý xoá</button></div>
      </div>
    </div>
  </div>
</template>
