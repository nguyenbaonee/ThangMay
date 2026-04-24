<script setup>
import { ref, onMounted, computed } from 'vue'
import { Plus, Edit, Trash2, X, Search, Save, Eye, AlertTriangle, Loader2 } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import postApi from '@/api/postApi'
import mediaApi from '@/api/mediaApi'

const isLoading = ref(false)
const searchQuery = ref('')
const blogs = ref([])
const categories = ref([])

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
    const [catRes, postRes] = await Promise.allSettled([
      postApi.categories(),
      postApi.search({ keyword: searchQuery.value })
    ])
    if (catRes.status === 'fulfilled') categories.value = catRes.value?.data || []
    if (postRes.status === 'fulfilled') blogs.value = postRes.value?.data?.content || postRes.value?.data || []
  } catch (error) {
    console.error('Error fetching blogs:', error)
    blogs.value = []
    categories.value = []
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
          <div class="form-group"><label>Tiêu đề <span class="text-danger">*</span></label><input v-model="form.title" class="form-control" placeholder="Nhập tiêu đề..." /></div>
          <div class="form-row">
            <div class="form-group"><label>Loại nội dung</label>
              <select v-model="form.type" class="form-control">
                <option v-for="t in typeOptions" :key="t.value" :value="t.value">{{ t.label }}</option>
              </select>
            </div>
            <div class="form-group"><label>Danh mục</label>
              <select v-model="form.categoryId" class="form-control">
                <option value="">— Chọn —</option>
                <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
              </select>
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>Ảnh đại diện (Thumbnail)</label>
              <input type="file" accept="image/*" @change="onThumbnailSelected" :disabled="isUploadingThumb" class="form-control" />
              <div v-if="isUploadingThumb" class="text-sm text-primary" style="margin-top:4px">Đang tải ảnh lên...</div>
              <img v-if="form.thumbnailPreview" :src="form.thumbnailPreview" style="height: 60px; object-fit: contain; margin-top: 8px; border-radius: 4px; background: #f8fafc;" />
            </div>
            <div class="form-group" style="justify-content:flex-end"><label class="form-check"><input type="checkbox" v-model="form.isFeatured" /> Bài viết nổi bật</label></div>
          </div>
          <div class="form-group"><label>Mô tả ngắn</label><textarea v-model="form.summary" class="form-control" rows="2" placeholder="Mô tả hiển thị ở danh sách..."></textarea></div>
          <div class="form-group"><label>Nội dung chi tiết</label><textarea v-model="form.content" class="form-control" rows="6" placeholder="Nội dung bài viết..."></textarea></div>
        </div>
        <div class="modal-foot">
          <button class="btn btn-outline" @click="closeModal">Huỷ</button>
          <button class="btn btn-primary" @click="saveBlog" :disabled="saving"><Save :size="16" /> Lưu</button>
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
