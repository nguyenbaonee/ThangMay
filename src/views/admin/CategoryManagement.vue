<script setup>
import { ref, onMounted, computed } from 'vue'
import { Plus, Edit, Trash2, X, Search, Save, Eye, EyeOff, AlertTriangle, Loader2 } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import categoryApi from '@/api/categoryApi'

const isLoading = ref(false)
const searchQuery = ref('')
const categories = ref([])

const isModalOpen = ref(false)
const isConfirmOpen = ref(false)
const modalMode = ref('create')
const targetDeleteId = ref(null)
const saving = ref(false)

const initialForm = { id: null, name: '', slug: '', description: '', icon: '', sortOrder: 0, isActive: true }
const form = ref({ ...initialForm })

const fetchData = async () => {
  isLoading.value = true
  try {
    const res = await categoryApi.search({ keyword: searchQuery.value })
    categories.value = res?.data?.content || res?.data || []
  } catch (error) {
    console.error('Error fetching categories:', error)
    categories.value = []
  } finally { isLoading.value = false }
}
onMounted(fetchData)

const filtered = computed(() => {
  if (!searchQuery.value) return categories.value
  const q = searchQuery.value.toLowerCase()
  return categories.value.filter(c => c.name?.toLowerCase().includes(q))
})

const openCreate = () => { modalMode.value = 'create'; form.value = { ...initialForm }; isModalOpen.value = true }
const openEdit = (c) => { modalMode.value = 'edit'; form.value = { ...c }; isModalOpen.value = true }
const closeModal = () => { isModalOpen.value = false }

const saveCategory = async () => {
  if (!form.value.name) { toast.error('Vui lòng nhập Tên danh mục!'); return }
  saving.value = true
  try {
    if (modalMode.value === 'create') {
      await categoryApi.create(form.value)
      toast.success('Thêm danh mục thành công!')
    } else {
      await categoryApi.update(form.value.id, form.value)
      toast.success('Cập nhật thành công!')
    }
    closeModal(); fetchData()
  } catch (error) {
    console.error('Error saving category:', error)
    const msg = error.response?.data?.message || 'Có lỗi xảy ra khi lưu dữ liệu!'
    toast.error(msg)
  } finally { saving.value = false }
}

const toggleActive = async (c) => {
  const newVal = !c.isActive
  try { await categoryApi.toggleActive(c.id, newVal) } catch {}
  c.isActive = newVal
  toast.info(newVal ? 'Đã bật hiển thị' : 'Đã ẩn danh mục')
}
const triggerDelete = (id) => { targetDeleteId.value = id; isConfirmOpen.value = true }
const confirmDelete = async () => {
  try { await categoryApi.delete(targetDeleteId.value) } catch {}
  categories.value = categories.value.filter(c => c.id !== targetDeleteId.value)
  toast.success('Đã xoá danh mục!')
  isConfirmOpen.value = false
}
</script>

<template>
  <div class="admin-page animate-in">
    <div class="page-header">
      <div><h2>Quản lý Danh mục</h2><p class="subtitle">Tổ chức các loại thang máy theo nhóm</p></div>
      <div class="page-actions">
        <div class="search-wrapper"><Search :size="16" class="search-icon" /><input v-model="searchQuery" placeholder="Tìm danh mục..." /></div>
        <button class="btn btn-primary" @click="openCreate"><Plus :size="16" /> Thêm mới</button>
      </div>
    </div>

    <div class="card">
      <div v-if="isLoading" class="loading-overlay"><div class="spinner"></div></div>
      <div v-else class="table-wrap">
        <table class="data-table">
          <thead><tr>
            <th style="width:60px">STT</th><th>Tên danh mục</th><th>Slug</th>
            <th>Mô tả</th><th class="text-center" style="width:100px">Trạng thái</th>
            <th class="text-right" style="width:100px">Thao tác</th>
          </tr></thead>
          <tbody>
            <tr v-if="filtered.length === 0"><td colspan="6"><div class="empty-state"><p>Chưa có danh mục nào</p></div></td></tr>
            <tr v-for="c in filtered" :key="c.id">
              <td class="text-center font-bold text-primary">{{ c.sortOrder }}</td>
              <td class="font-medium">{{ c.name }}</td>
              <td class="text-sm font-mono text-muted">{{ c.slug || '—' }}</td>
              <td><span class="truncate">{{ c.description || '—' }}</span></td>
              <td class="text-center">
                <span :class="['badge', c.isActive ? 'badge-active' : 'badge-inactive']" style="cursor:pointer" @click="toggleActive(c)">
                  {{ c.isActive ? 'Hiển thị' : 'Đang ẩn' }}
                </span>
              </td>
              <td>
                <div class="row-actions">
                  <button class="act-btn" @click="openEdit(c)" title="Sửa"><Edit :size="16" /></button>
                  <button class="act-btn danger" @click="triggerDelete(c.id)" title="Xoá"><Trash2 :size="16" /></button>
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
        <div class="modal-head">
          <h3>{{ modalMode === 'create' ? 'Thêm Danh mục' : 'Cập nhật Danh mục' }}</h3>
          <button class="act-btn" @click="closeModal"><X :size="20" /></button>
        </div>
        <div class="modal-body">
          <div class="form-row">
            <div class="form-group"><label>Tên danh mục <span class="text-danger">*</span></label><input v-model="form.name" class="form-control" placeholder="Tên loại thang máy..." /></div>
            <div class="form-group"><label>Slug</label><input v-model="form.slug" class="form-control" placeholder="thang-may-gia-dinh" /></div>
          </div>
          <div class="form-row">
            <div class="form-group"><label>Thứ tự</label><input type="number" v-model="form.sortOrder" class="form-control" /></div>
            <div class="form-group"><label>Icon</label><input v-model="form.icon" class="form-control" placeholder="Icon class hoặc URL" /></div>
          </div>
          <div class="form-group"><label>Mô tả</label><textarea v-model="form.description" class="form-control" rows="3" placeholder="Nhập mô tả..."></textarea></div>
        </div>
        <div class="modal-foot">
          <button class="btn btn-outline" @click="closeModal">Huỷ</button>
          <button class="btn btn-primary" @click="saveCategory" :disabled="saving"><Save :size="16" /> Lưu</button>
        </div>
      </div>
    </div>

    <!-- Confirm -->
    <div v-if="isConfirmOpen" class="modal-overlay" @click.self="isConfirmOpen = false">
      <div class="confirm-box">
        <div class="icon"><AlertTriangle :size="44" /></div>
        <h3>Xoá danh mục?</h3>
        <p>Sản phẩm thuộc danh mục này có thể bị ảnh hưởng.</p>
        <div class="actions">
          <button class="btn btn-outline" @click="isConfirmOpen = false">Huỷ</button>
          <button class="btn btn-danger" @click="confirmDelete">Đồng ý xoá</button>
        </div>
      </div>
    </div>
  </div>
</template>
