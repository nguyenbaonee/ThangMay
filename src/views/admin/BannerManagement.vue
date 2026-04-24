<script setup>
import { ref, onMounted, computed } from 'vue'
import { Plus, Edit, Trash2, X, Search, Save, Eye, EyeOff, AlertTriangle, Loader2, Image as ImageIcon, Link as LinkIcon } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import bannerApi from '@/api/bannerApi'
import mediaApi from '@/api/mediaApi'

const isLoading = ref(false)
const searchQuery = ref('')
const banners = ref([])

const isModalOpen = ref(false)
const isConfirmOpen = ref(false)
const modalMode = ref('create')
const targetDeleteId = ref(null)
const saving = ref(false)

const initialForm = {
  id: null, title: '', imageUrl: '', linkUrl: '',
  position: 'CENTER', sortOrder: 0, isActive: true
}
const form = ref({ ...initialForm })

const isUploadingImage = ref(false)

const onImageSelected = async (e) => {
  const file = e.target.files[0]
  if (!file) return
  isUploadingImage.value = true
  try {
    const res = await mediaApi.uploadSingle(file, 'banners')
    form.value.imageUrl = res.data.publicUrl || res.data.url
    toast.success('Upload ảnh thành công!')
  } catch (err) {
    toast.error('Lỗi upload ảnh!')
  } finally {
    isUploadingImage.value = false
  }
}

const fetchData = async () => {
  isLoading.value = true
  try {
    const res = await bannerApi.getAll()
    banners.value = res.data || []
  } catch (e) {
    console.error('Error fetching banners:', e)
    banners.value = []
  } finally { isLoading.value = false }
}

onMounted(fetchData)

const filteredBanners = computed(() => {
  if (!searchQuery.value) return banners.value
  const q = searchQuery.value.toLowerCase()
  return banners.value.filter(b => b.title?.toLowerCase().includes(q) || b.position?.toLowerCase().includes(q))
})

const openCreate = () => {
  modalMode.value = 'create'
  form.value = { ...initialForm }
  isModalOpen.value = true
}
const openEdit = (b) => {
  modalMode.value = 'edit'
  form.value = { ...b }
  isModalOpen.value = true
}
const closeModal = () => { isModalOpen.value = false }

const saveBanner = async () => {
  if (!form.value.imageUrl || !form.value.position) {
    toast.error('Vui lòng điền Ảnh và Vị trí!'); return
  }
  saving.value = true
  try {
    if (modalMode.value === 'create') {
      await bannerApi.create(form.value)
      toast.success('Thêm banner thành công!')
    } else {
      await bannerApi.update(form.value.id, form.value)
      toast.success('Cập nhật banner thành công!')
    }
    closeModal(); fetchData()
  } catch (e) {
    toast.error('Lỗi khi lưu banner')
  } finally { saving.value = false }
}

const triggerDelete = (id) => { targetDeleteId.value = id; isConfirmOpen.value = true }
const confirmDelete = async () => {
  try { await bannerApi.delete(targetDeleteId.value); toast.success('Đã xoá banner!') } catch { toast.error('Lỗi khi xoá') }
  isConfirmOpen.value = false; fetchData()
}
</script>

<template>
  <div class="admin-page animate-in">
    <div class="page-header">
      <div>
        <h2>Quản lý Banners</h2>
        <p class="subtitle">Hình ảnh trình chiếu & Quảng cáo</p>
      </div>
      <div class="page-actions">
        <div class="search-wrapper">
          <Search :size="16" class="search-icon" />
          <input v-model="searchQuery" placeholder="Tìm theo tiêu đề hoặc vị trí..." />
        </div>
        <button class="btn btn-primary" @click="openCreate"><Plus :size="16" /> Thêm mới</button>
      </div>
    </div>

    <div class="card">
      <div v-if="isLoading" class="loading-overlay"><div class="spinner"></div></div>
      <div v-else class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th style="width:120px">Ảnh</th>
              <th>Tiêu đề</th>
              <th>Vị trí</th>
              <th>Link điều hướng</th>
              <th class="text-center" style="width:80px">Thứ tự</th>
              <th class="text-center" style="width:100px">Trạng thái</th>
              <th class="text-right" style="width:100px">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="filteredBanners.length === 0">
              <td colspan="7"><div class="empty-state"><ImageIcon :size="40" /><p>Chưa có banner nào</p></div></td>
            </tr>
            <tr v-for="b in filteredBanners" :key="b.id">
              <td>
                <img :src="b.imageUrl" class="thumb-md" alt="" style="width:100px; height:60px; object-fit:cover; border-radius:4px" />
              </td>
              <td><span class="font-medium">{{ b.title || '(Không tiêu đề)' }}</span></td>
              <td><span class="badge badge-category">{{ b.position }}</span></td>
              <td class="text-muted text-sm truncate" style="max-width:200px">{{ b.linkUrl || '—' }}</td>
              <td class="text-center font-bold">{{ b.sortOrder }}</td>
              <td class="text-center">
                <span :class="['badge', b.isActive ? 'badge-active' : 'badge-inactive']">
                  {{ b.isActive ? 'Đang bật' : 'Đang ẩn' }}
                </span>
              </td>
              <td>
                <div class="row-actions">
                  <button class="act-btn" @click="openEdit(b)" title="Sửa"><Edit :size="16" /></button>
                  <button class="act-btn danger" @click="triggerDelete(b.id)" title="Xoá"><Trash2 :size="16" /></button>
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
          <h3>{{ modalMode === 'create' ? 'Thêm Banner mới' : 'Chỉnh sửa Banner' }}</h3>
          <button class="act-btn" @click="closeModal"><X :size="20" /></button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>Tiêu đề</label>
            <input v-model="form.title" class="form-control" placeholder="Nhập tiêu đề banner..." />
          </div>
          <div class="form-group">
            <label>Hình ảnh Banner <span class="text-danger">*</span></label>
            <input type="file" accept="image/*" @change="onImageSelected" :disabled="isUploadingImage" class="form-control" />
            <div v-if="isUploadingImage" class="text-sm text-primary" style="margin-top:4px">Đang tải ảnh lên...</div>
            <div v-if="form.imageUrl" style="margin-top:0.5rem">
                <img :src="form.imageUrl" style="max-width:100%; height:120px; object-fit:contain; border-radius:8px; border:1px solid #e2e8f0; background: #f8fafc;" alt="Preview" />
            </div>
          </div>
          <div class="form-group">
            <label>Vị trí hiển thị <span class="text-danger">*</span></label>
            <select v-model="form.position" class="form-control">
              <option value="CENTER">Trung tâm (Slider Home)</option>
              <option value="MENU">Menu Banner</option>
              <option value="TOP">Đầu trang (Top Bar)</option>
              <option value="SIDEBAR">Cạnh trang</option>
            </select>
          </div>
          <div class="form-group">
            <label>Link khi click</label>
            <input v-model="form.linkUrl" class="form-control" placeholder="/products, /contact, https://..." />
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>Thứ tự hiển thị</label>
              <input type="number" v-model="form.sortOrder" class="form-control" />
            </div>
            <div class="form-group" style="padding-top:2rem">
              <label class="form-check"><input type="checkbox" v-model="form.isActive" /> Đang hoạt động</label>
            </div>
          </div>
        </div>
        <div class="modal-foot">
          <button class="btn btn-outline" @click="closeModal">Huỷ bỏ</button>
          <button class="btn btn-primary" @click="saveBanner" :disabled="saving">
            <Loader2 v-if="saving" :size="16" class="spinner" /> <Save v-else :size="16" /> Lưu
          </button>
        </div>
      </div>
    </div>

    <!-- Confirm -->
    <div v-if="isConfirmOpen" class="modal-overlay" @click.self="isConfirmOpen = false">
      <div class="confirm-box">
        <div class="icon"><AlertTriangle :size="44" /></div>
        <h3>Xác nhận xoá?</h3>
        <p>Banner này sẽ bị xoá vĩnh viễn.</p>
        <div class="actions">
          <button class="btn btn-outline" @click="isConfirmOpen = false">Huỷ</button>
          <button class="btn btn-danger" @click="confirmDelete">Đồng ý xoá</button>
        </div>
      </div>
    </div>
  </div>
</template>
