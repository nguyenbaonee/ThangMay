<script setup>
import { ref, onMounted, computed } from 'vue'
import { Plus, Edit, Trash2, X, Search, Save, Eye, EyeOff, AlertTriangle, Loader2, UploadCloud, Image as ImageIcon } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import categoryApi from '@/api/categoryApi'
import mediaApi from '@/api/mediaApi'

const isLoading = ref(false)
const searchQuery = ref('')
const categories = ref([])

const isModalOpen = ref(false)
const isConfirmOpen = ref(false)
const modalMode = ref('create')
const targetDeleteId = ref(null)
const saving = ref(false)
const isUploadingIcon = ref(false)

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
const openEdit = (c) => { modalMode.value = 'edit'; form.value = { ...c, icon: c.iconUrl || c.icon }; isModalOpen.value = true }
const closeModal = () => { isModalOpen.value = false }

const onIconSelected = async (e) => {
  const file = e.target.files[0]
  if (!file) return
  isUploadingIcon.value = true
  try {
    const res = await mediaApi.uploadSingle(file, 'categories')
    form.value.icon = res.data.publicUrl || res.data.url
    toast.success('Upload ảnh thành công!')
  } catch (err) {
    toast.error('Lỗi upload ảnh!')
  } finally {
    isUploadingIcon.value = false
  }
}

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
          <!-- Image Upload Area -->
          <div class="form-group">
            <div 
              class="upload-dropzone" 
              :class="{ 'has-image': form.icon }"
              @click="$refs.fileInput.click()"
            >
              <input 
                type="file" 
                ref="fileInput"
                accept="image/*" 
                @change="onIconSelected" 
                :disabled="isUploadingIcon" 
                hidden
              />
              
              <div v-if="!form.icon && !isUploadingIcon" class="upload-placeholder">
                <div class="upload-icon-circle">
                  <ImageIcon :size="32" />
                </div>
                <p class="upload-text-main">Ảnh đại diện</p>
                <p class="upload-text-sub">Dung lượng tối đa 2MB. Định dạng: JPG, PNG.</p>
              </div>

              <div v-else-if="isUploadingIcon" class="upload-loading">
                <Loader2 :size="32" class="spinner" />
                <p>Đang tải ảnh lên...</p>
              </div>

              <div v-else class="upload-preview-container">
                <img :src="form.icon" alt="Preview" class="upload-preview-img" />
                <div class="upload-preview-overlay">
                  <UploadCloud :size="24" />
                  <span>Thay đổi ảnh</span>
                </div>
              </div>
            </div>
          </div>

          <div class="form-group">
            <label>Tên danh mục <span class="text-danger">*</span></label>
            <input v-model="form.name" class="form-control" placeholder="Nhập tên danh mục..." />
          </div>

          <div class="form-group">
            <label>Slug <Edit :size="14" /></label>
            <input v-model="form.slug" class="form-control slug-input" placeholder="ten-danh-muc-tu-dong" />
            <p class="form-hint">Tự động tạo từ tên danh mục để tối ưu SEO.</p>
          </div>

          <div class="form-group">
            <label>Thứ tự</label>
            <input type="number" v-model="form.sortOrder" class="form-control" />
          </div>

          <div class="form-group">
            <label>Trạng thái</label>
            <div class="radio-group">
              <label class="radio-item">
                <input type="radio" :value="true" v-model="form.isActive" />
                <span class="radio-mark"></span> Hiện
              </label>
              <label class="radio-item">
                <input type="radio" :value="false" v-model="form.isActive" />
                <span class="radio-mark"></span> Ẩn
              </label>
            </div>
          </div>

          <div class="form-group">
            <label>Mô tả</label>
            <textarea v-model="form.description" class="form-control" rows="4" placeholder="Nhập mô tả ngắn cho danh mục này..."></textarea>
          </div>
        </div>
        <div class="modal-foot">
          <button class="btn btn-outline" @click="closeModal">Huỷ</button>
          <button class="btn btn-primary" @click="saveCategory" :disabled="saving">
            <Loader2 v-if="saving" :size="16" class="spinner" /> <Save v-else :size="16" /> Lưu
          </button>
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

<style scoped>
.upload-dropzone {
  border: 2px dashed #e2e8f0;
  border-radius: 12px;
  padding: 1.5rem;
  text-align: center;
  cursor: pointer;
  transition: all 0.2s ease;
  background: #f8fafc;
  min-height: 160px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.upload-dropzone:hover {
  border-color: var(--admin-primary);
  background: #f1f5f9;
}

.upload-dropzone.has-image {
  padding: 0;
  border-style: solid;
}

.upload-icon-circle {
  width: 56px;
  height: 56px;
  background: #fff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 0.75rem;
  color: #94a3b8;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.upload-text-main {
  font-weight: 600;
  color: #1e293b;
  margin-bottom: 0.25rem;
}

.upload-text-sub {
  color: #64748b;
  font-size: 0.82rem;
}

.upload-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  color: var(--admin-primary);
}

.upload-preview-container {
  width: 100%;
  height: 160px;
  position: relative;
}

.upload-preview-img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  background: #f8fafc;
}

.upload-preview-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.4);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #fff;
  gap: 0.5rem;
  opacity: 0;
  transition: opacity 0.2s ease;
}

.upload-preview-container:hover .upload-preview-overlay {
  opacity: 1;
}

.slug-input {
  background: #f1f5f9 !important;
  font-family: monospace;
  font-size: 0.85rem;
}

.form-hint {
  font-size: 0.75rem;
  color: #64748b;
  margin-top: 0.25rem;
}

/* Radio Group Styling */
.radio-group {
  display: flex;
  gap: 1.5rem;
  margin-top: 0.25rem;
}

.radio-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
  font-size: 0.9rem;
  font-weight: 500;
  color: #334155;
}

.radio-item input {
  display: none;
}

.radio-mark {
  width: 18px;
  height: 18px;
  border: 2px solid #cbd5e1;
  border-radius: 50%;
  position: relative;
  transition: 0.2s;
}

.radio-item input:checked + .radio-mark {
  border-color: var(--admin-primary);
}

.radio-item input:checked + .radio-mark::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 10px;
  height: 10px;
  background: var(--admin-primary);
  border-radius: 50%;
}
</style>
