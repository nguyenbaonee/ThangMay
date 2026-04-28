<script setup>
import { ref, onMounted, computed } from 'vue'
import { Plus, Edit, Trash2, X, Search, Save, Eye, AlertTriangle, Loader2, UploadCloud, Image as ImageIcon } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import postApi from '@/api/postApi'
import mediaApi from '@/api/mediaApi'

const isLoading = ref(false)
const searchQuery = ref('')
const blogs = ref([])
const categories = ref([
  { id: 'pc-news', name: 'Tin tức', slug: 'tin-tuc' },
  { id: 'pc-project', name: 'Dự án nổi bật', slug: 'du-an-tieu-bieu' },
  { id: 'pc-recruitment', name: 'Tuyển dụng', slug: 'tuyen-dung' }
])

const isModalOpen = ref(false)
const isConfirmOpen = ref(false)
const modalMode = ref('create')
const targetDeleteId = ref(null)
const saving = ref(false)

const initialForm = { id: null, title: '', slug: '', categoryId: '', summary: '', content: '', thumbnailId: '', thumbnailPreview: '', status: 'DRAFT', type: 'BLOG', isFeatured: false }
const form = ref({ ...initialForm })

const isUploadingThumb = ref(false)

const onThumbnailSelected = async (e) => {
  const file = e.target.files[0]
  if (!file) return
  isUploadingThumb.value = true
  try {
    const res = await mediaApi.uploadSingle(file, 'posts')
    form.value.thumbnailId = res.data.id
    form.value.thumbnailPreview = res.data.publicUrl || res.data.url
    toast.success('Upload ảnh thành công!')
  } catch (err) {
    toast.error('Lỗi upload ảnh!')
  } finally {
    isUploadingThumb.value = false
  }
}

const typeOptions = [
  { value: 'BLOG', label: 'Bài viết' },
  { value: 'NEWS', label: 'Tin tức' },
  { value: 'PROJECT', label: 'Dự án' },
  { value: 'RECRUITMENT', label: 'Tuyển dụng' }
]

const fetchData = async () => {
  isLoading.value = true
  try {
    const [postRes] = await Promise.allSettled([
      postApi.searchAdmin({ keyword: searchQuery.value })
    ])
    if (postRes.status === 'fulfilled') blogs.value = postRes.value?.data?.content || postRes.value?.data || []
  } catch (error) {
    console.error('Error fetching blogs:', error)
    blogs.value = []
  } finally { isLoading.value = false }
}
onMounted(fetchData)

const filtered = computed(() => {
  if (!searchQuery.value) return blogs.value
  const q = searchQuery.value.toLowerCase()
  return blogs.value.filter(b => b.title?.toLowerCase().includes(q))
})

const getCatName = (b) => b.category?.name || b.category?.slug || (typeof b.category === 'string' ? b.category : '') || categories.value.find(c => c.id === b.categoryId)?.name || '—'
const getTypeName = (t) => typeOptions.find(o => o.value === t)?.label || t

const openCreate = () => { modalMode.value = 'create'; form.value = { ...initialForm }; isModalOpen.value = true }
const openEdit = (b) => { 
  modalMode.value = 'edit'; 
  form.value = { ...b }; 
  form.value.thumbnailPreview = b.thumbnail?.publicUrl || b.thumbnail?.url || (typeof b.thumbnail === 'string' ? b.thumbnail : '');
  isModalOpen.value = true 
}
const closeModal = () => { isModalOpen.value = false }

const saveBlog = async () => {
  if (!form.value.title) { toast.error('Vui lòng nhập Tiêu đề!'); return }
  saving.value = true
  try {
    if (modalMode.value === 'create') { await postApi.create(form.value); toast.success('Tạo bài viết thành công!') }
    else { await postApi.update(form.value.id, form.value); toast.success('Cập nhật thành công!') }
    closeModal(); fetchData()
  } catch (error) {
    console.error('Error saving blog:', error)
    const msg = error.response?.data?.message || 'Có lỗi xảy ra khi lưu bài viết!'
    toast.error(msg)
  } finally { saving.value = false }
}

const togglePublish = async (b) => {
  try {
    if (b.status === 'PUBLISHED') { await postApi.archive(b.id); b.status = 'DRAFT'; toast.info('Đã lưu nháp') }
    else { await postApi.publish(b.id); b.status = 'PUBLISHED'; toast.success('Đã đăng bài') }
  } catch {
    b.status = b.status === 'PUBLISHED' ? 'DRAFT' : 'PUBLISHED'
    toast.info('Đã chuyển trạng thái (offline)')
  }
}
const triggerDelete = (id) => { targetDeleteId.value = id; isConfirmOpen.value = true }
const confirmDelete = async () => {
  try { await postApi.delete(targetDeleteId.value) } catch {}
  blogs.value = blogs.value.filter(b => b.id !== targetDeleteId.value)
  toast.success('Đã xoá!'); isConfirmOpen.value = false
}
</script>

<template>
  <div class="admin-page animate-in">
    <div class="page-header">
      <div><h2>Quản lý Bài viết</h2><p class="subtitle">Blog, tin tức, dự án, tuyển dụng</p></div>
      <div class="page-actions">
        <div class="search-wrapper"><Search :size="16" class="search-icon" /><input v-model="searchQuery" placeholder="Tìm bài viết..." /></div>
        <button class="btn btn-primary" @click="openCreate"><Plus :size="16" /> Viết bài</button>
      </div>
    </div>

    <div class="card">
      <div v-if="isLoading" class="loading-overlay"><div class="spinner"></div></div>
      <div v-else class="table-wrap">
        <table class="data-table">
          <thead><tr>
            <th>Tiêu đề</th><th style="width:100px">Loại</th><th>Danh mục</th>
            <th class="text-center" style="width:80px">Lượt xem</th>
            <th class="text-center" style="width:110px">Trạng thái</th>
            <th class="text-right" style="width:100px">Thao tác</th>
          </tr></thead>
          <tbody>
            <tr v-if="filtered.length === 0"><td colspan="6"><div class="empty-state"><p>Chưa có bài viết nào</p></div></td></tr>
            <tr v-for="b in filtered" :key="b.id">
              <td><span class="font-medium">{{ b.title }}</span><br/><span class="text-xs text-muted">{{ b.summary?.substring(0, 60) }}...</span></td>
              <td><span class="badge badge-category">{{ getTypeName(b.type) }}</span></td>
              <td class="text-sm">{{ getCatName(b) }}</td>
              <td class="text-center text-sm text-muted font-bold">{{ b.viewCount || 0 }}</td>
              <td class="text-center">
                <span :class="['badge', b.status === 'PUBLISHED' ? 'badge-published' : 'badge-draft']" style="cursor:pointer" @click="togglePublish(b)">
                  {{ b.status === 'PUBLISHED' ? 'Đã đăng' : 'Nháp' }}
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
      <div class="modal-box wide">
        <div class="modal-head"><h3>{{ modalMode === 'create' ? 'Viết bài mới' : 'Chỉnh sửa bài viết' }}</h3><button class="act-btn" @click="closeModal"><X :size="20" /></button></div>
        <div class="modal-body">
          <!-- Thumbnail Upload Area -->
          <div class="form-group">
            <div 
              class="upload-dropzone" 
              :class="{ 'has-image': form.thumbnailPreview }"
              @click="$refs.fileInput.click()"
            >
              <input 
                type="file" 
                ref="fileInput"
                accept="image/*" 
                @change="onThumbnailSelected" 
                :disabled="isUploadingThumb" 
                hidden
              />
              
              <div v-if="!form.thumbnailPreview && !isUploadingThumb" class="upload-placeholder">
                <div class="upload-icon-circle">
                  <ImageIcon :size="32" />
                </div>
                <p class="upload-text-main">Ảnh đại diện bài viết</p>
                <p class="upload-text-sub">Dung lượng tối đa 2MB. Định dạng: JPG, PNG.</p>
              </div>

              <div v-else-if="isUploadingThumb" class="upload-loading">
                <Loader2 :size="32" class="spinner" />
                <p>Đang tải ảnh lên...</p>
              </div>

              <div v-else class="upload-preview-container">
                <img :src="form.thumbnailPreview" alt="Preview" class="upload-preview-img" />
                <div class="upload-preview-overlay">
                  <UploadCloud :size="24" />
                  <span>Thay đổi ảnh</span>
                </div>
              </div>
            </div>
          </div>

          <div class="form-group">
            <label>Tiêu đề bài viết <span class="text-danger">*</span></label>
            <input v-model="form.title" class="form-control" placeholder="Nhập tiêu đề bài viết..." />
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Loại nội dung</label>
              <select v-model="form.type" class="form-control">
                <option v-for="t in typeOptions" :key="t.value" :value="t.value">{{ t.label }}</option>
              </select>
            </div>
            <div class="form-group">
              <label>Danh mục</label>
              <select v-model="form.categoryId" class="form-control">
                <option value="">— Chọn danh mục —</option>
                <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
              </select>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Trạng thái đăng bài</label>
              <div class="radio-group">
                <label class="radio-item">
                  <input type="radio" value="PUBLISHED" v-model="form.status" />
                  <span class="radio-mark"></span> Đăng ngay
                </label>
                <label class="radio-item">
                  <input type="radio" value="DRAFT" v-model="form.status" />
                  <span class="radio-mark"></span> Lưu nháp
                </label>
              </div>
            </div>
            <div class="form-group" style="justify-content: center;">
              <label class="form-check">
                <input type="checkbox" v-model="form.isFeatured" /> 
                <span>Đánh dấu nổi bật</span>
              </label>
            </div>
          </div>

          <div class="form-group">
            <label>Mô tả ngắn (Summary)</label>
            <textarea v-model="form.summary" class="form-control" rows="2" placeholder="Tóm tắt ngắn hiển thị ở danh sách bài viết..."></textarea>
          </div>

          <div class="form-group">
            <label>Nội dung chi tiết</label>
            <textarea v-model="form.content" class="form-control" rows="8" placeholder="Viết nội dung bài viết tại đây..."></textarea>
          </div>
        </div>
        <div class="modal-foot">
          <button class="btn btn-outline" @click="closeModal">Hủy bỏ</button>
          <button class="btn btn-primary" @click="saveBlog" :disabled="saving">
            <Loader2 v-if="saving" :size="16" class="spinner" /> <Save v-else :size="16" /> Lưu bài viết
          </button>
        </div>
      </div>
    </div>

    <!-- Confirm -->
    <div v-if="isConfirmOpen" class="modal-overlay" @click.self="isConfirmOpen = false">
      <div class="confirm-box">
        <div class="icon"><AlertTriangle :size="44" /></div>
        <h3>Xoá bài viết?</h3><p>Bài viết sẽ bị xoá vĩnh viễn.</p>
        <div class="actions"><button class="btn btn-outline" @click="isConfirmOpen = false">Huỷ</button><button class="btn btn-danger" @click="confirmDelete">Đồng ý xoá</button></div>
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
  min-height: 180px;
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
  height: 180px;
  position: relative;
}

.upload-preview-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
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
