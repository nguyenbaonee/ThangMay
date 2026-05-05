<script setup>
import { ref, onMounted, computed } from 'vue'
import { Plus, Edit, Trash2, X, Search, Save, Eye, EyeOff, AlertTriangle, Loader2, Image as ImageIcon, Link as LinkIcon, UploadCloud } from 'lucide-vue-next'
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

// For CENTER mode: manage 4 slots
const centerSlots = ref([
  { imageUrl: '', sortOrder: 1, isActive: true, uploading: false },
  { imageUrl: '', sortOrder: 2, isActive: true, uploading: false },
  { imageUrl: '', sortOrder: 3, isActive: true, uploading: false },
  { imageUrl: '', sortOrder: 4, isActive: true, uploading: false }
])

const createEmptySlots = () => ([
  { imageUrl: '', sortOrder: 1, isActive: true, uploading: false },
  { imageUrl: '', sortOrder: 2, isActive: true, uploading: false },
  { imageUrl: '', sortOrder: 3, isActive: true, uploading: false },
  { imageUrl: '', sortOrder: 4, isActive: true, uploading: false }
])

const resolveActive = (value, fallback = true) => {
  if (typeof value?.isActive === 'boolean') return value.isActive
  if (typeof value?.active === 'boolean') return value.active
  return fallback
}

const toggleSlotStatus = (index) => {
  const slot = centerSlots.value[index]
  if (!slot.imageUrl) {
    slot.isActive = !slot.isActive
    return
  }
  
  if (slot.isActive) {
    // Count other active slots that have images
    const activeWithImageCount = centerSlots.value.filter((s, i) => i !== index && s.imageUrl && s.isActive).length
    if (activeWithImageCount === 0) {
      toast.warning('Phải giữ ít nhất 1 ảnh hoạt động!')
      return
    }
  }
  slot.isActive = !slot.isActive
}

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

const onSlotImageSelected = async (e, index) => {
  const file = e.target.files[0]
  if (!file) return
  centerSlots.value[index].uploading = true
  try {
    const res = await mediaApi.uploadSingle(file, 'banners')
    centerSlots.value[index].imageUrl = res.data.publicUrl || res.data.url
    toast.success(`Upload ảnh ${index + 1} thành công!`)
  } catch (err) {
    toast.error('Lỗi upload ảnh!')
  } finally {
    centerSlots.value[index].uploading = false
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

// Group CENTER banners by groupCode → show as 1 row; TOP banners stay individual
const groupedBanners = computed(() => {
  const seen = new Set()
  const result = []
  for (const b of banners.value) {
    if (b.position === 'CENTER' && b.groupCode) {
      if (seen.has(b.groupCode)) continue // skip duplicates in same group
      seen.add(b.groupCode)
      // Collect all items in this group
      const groupItems = banners.value
        .filter(x => x.groupCode === b.groupCode)
        .sort((a, c) => (a.sortOrder ?? 0) - (c.sortOrder ?? 0))
      result.push({
        ...b,
        _groupItems: groupItems,
        // Status: active nếu có ít nhất 1 item active
        isActive: groupItems.some(x => x.isActive)
      })
    } else {
      result.push(b)
    }
  }
  return result
})

const filteredBanners = computed(() => {
  if (!searchQuery.value) return groupedBanners.value
  const q = searchQuery.value.toLowerCase()
  return groupedBanners.value.filter(b => b.title?.toLowerCase().includes(q) || b.position?.toLowerCase().includes(q))
})

const openCreate = () => {
  modalMode.value = 'create'
  form.value = { ...initialForm }
  centerSlots.value = createEmptySlots()
  isModalOpen.value = true
}
const openEdit = (b) => {
  modalMode.value = 'edit'
  if (b.position === 'CENTER') {
    const relatedBanners = b.groupCode
      ? banners.value.filter(item => item.groupCode === b.groupCode)
      : [b]
    const nextSlots = createEmptySlots()

    relatedBanners
      .sort((a, c) => (a.sortOrder ?? 0) - (c.sortOrder ?? 0))
      .slice(0, 4)
      .forEach((item, index) => {
        nextSlots[index] = {
          imageUrl: item.imageUrl || '',
          sortOrder: item.sortOrder ?? index + 1,
          isActive: resolveActive(item),
          uploading: false
        }
      })

    centerSlots.value = nextSlots
    form.value = {
      id: b.id,
      title: b.title || '',
      imageUrl: '',
      linkUrl: b.linkUrl || '',
      position: 'CENTER',
      sortOrder: b.sortOrder ?? 0,
      isActive: resolveActive(b),
      groupCode: b.groupCode || null
    }
  } else {
    form.value = { ...b, isActive: resolveActive(b) }
    centerSlots.value = createEmptySlots()
  }
  isModalOpen.value = true
}
const closeModal = () => { isModalOpen.value = false }

const saveBanner = async () => {
  if (!form.value.title?.trim()) {
    toast.error('Vui lòng nhập tên banner!')
    return
  }

  if (form.value.position === 'TOP') {
    if (!form.value.imageUrl) { toast.error('Vui lòng chọn ảnh!'); return }
  } else {
    const filledSlots = centerSlots.value.filter(s => s.imageUrl)
    if (filledSlots.length !== 4) {
      toast.error('Banner trang chủ cần đủ 4 ảnh!')
      return
    }

    const activeSlots = filledSlots.filter(s => s.isActive)
    if (activeSlots.length === 0) {
      toast.error('Cần ít nhất 1 ảnh hoạt động cho Banner chính!')
      return
    }

    const sortOrders = filledSlots.map(s => Number(s.sortOrder))
    if (sortOrders.some(order => !Number.isInteger(order) || order <= 0)) {
      toast.error('Vị trí hiển thị phải là số nguyên dương!')
      return
    }

    if (new Set(sortOrders).size !== sortOrders.length) {
      toast.error('Vị trí hiển thị của 4 ảnh không được trùng nhau!')
      return
    }
  }

  saving.value = true
  try {
    const topPayload = {
      title: form.value.title.trim(),
      imageUrl: form.value.imageUrl,
      linkUrl: form.value.linkUrl?.trim() || null,
      position: 'TOP',
      sortOrder: form.value.sortOrder ?? 0,
      isActive: form.value.isActive,
      active: form.value.isActive
    }

    const centerPayload = {
      title: form.value.title.trim(),
      linkUrl: form.value.linkUrl?.trim() || null,
      position: 'CENTER',
      isActive: form.value.isActive,
      active: form.value.isActive,
      items: centerSlots.value.map(slot => ({
        imageUrl: slot.imageUrl,
        sortOrder: Number(slot.sortOrder),
        isActive: slot.isActive,
        active: slot.isActive
      }))
    }

    if (modalMode.value === 'create') {
      if (form.value.position === 'TOP') {
        await bannerApi.create(topPayload)
      } else {
        await bannerApi.create(centerPayload)
      }
      toast.success('Thêm banner thành công!')
    } else {
      await bannerApi.update(form.value.id, form.value.position === 'TOP' ? topPayload : centerPayload)
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
              <!-- Ảnh: CENTER → strip thumbnail nhóm; TOP → ảnh đơn -->
              <td>
                <div v-if="b.position === 'CENTER' && b._groupItems?.length" class="thumb-group">
                  <img
                    v-for="(item, i) in b._groupItems.slice(0, 4)"
                    :key="i"
                    :src="item.imageUrl"
                    :title="`Ảnh ${item.sortOrder}`"
                    class="thumb-group-img"
                    :class="{ 'thumb-inactive': !item.isActive }"
                    alt=""
                  />
                </div>
                <img v-else :src="b.imageUrl" alt="" class="thumb-single" />
              </td>
              <td>
                <span class="font-medium">{{ b.title || '(Không tiêu đề)' }}</span>
                <span v-if="b.position === 'CENTER' && b._groupItems" class="text-xs text-muted d-block">
                  {{ b._groupItems.length }} ảnh
                </span>
              </td>
              <td><span class="badge badge-category">{{ b.position }}</span></td>
              <td class="text-muted text-sm truncate" style="max-width:200px">{{ b.linkUrl || '—' }}</td>
              <td class="text-center font-bold">
                <span v-if="b.position === 'CENTER'">—</span>
                <span v-else>{{ b.sortOrder }}</span>
              </td>
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
          <!-- Position Selection -->
          <div class="form-group">
            <label>Vị trí hiển thị <span class="text-danger">*</span></label>
            <div class="position-selector">
              <button 
                type="button"
                class="pos-btn" 
                :class="{ active: form.position === 'TOP' }"
                @click="form.position = 'TOP'"
                :disabled="modalMode === 'edit'"
              >
                Đầu trang (Top Bar)
              </button>
              <button 
                type="button"
                class="pos-btn" 
                :class="{ active: form.position === 'CENTER' }"
                @click="form.position = 'CENTER'"
                :disabled="modalMode === 'edit'"
              >
                Trang chủ (Hero Banner)
              </button>
            </div>
          </div>

          <!-- LAYOUT FOR TOP BANNER -->
          <div v-if="form.position === 'TOP'" class="layout-single animate-in">
            <div class="form-group">
              <label>Hình ảnh Banner <span class="text-danger">*</span></label>
              <div class="upload-dropzone" :class="{ 'has-image': form.imageUrl }" @click="$refs.fileInput.click()">
                <input type="file" ref="fileInput" accept="image/*" @change="onImageSelected" :disabled="isUploadingImage" hidden />
                <div v-if="!form.imageUrl && !isUploadingImage" class="upload-placeholder">
                  <div class="upload-icon-circle"><UploadCloud :size="32" /></div>
                  <p class="upload-text-main">Nhấn để tải lên</p>
                  <p class="upload-text-hint">Khuyên dùng: 1920x60px</p>
                </div>
                <div v-else-if="isUploadingImage" class="upload-loading"><Loader2 :size="32" class="spinner" /></div>
                <div v-else class="upload-preview-container">
                  <img :src="form.imageUrl" alt="Preview" class="upload-preview-img" />
                </div>
              </div>
            </div>
            <div class="form-group">
              <label>Tên Banner *</label>
              <input v-model="form.title" class="form-control" placeholder="Nhập tên banner..." />
            </div>
            <div class="form-row">
              <div class="form-group">
                <label>Trạng thái</label>
                <select v-model="form.isActive" class="form-control">
                  <option :value="true">Hiển thị (Kích hoạt)</option>
                  <option :value="false">Ẩn</option>
                </select>
              </div>
              <div class="form-group">
                <label>Link liên kết</label>
                <input v-model="form.linkUrl" class="form-control" placeholder="/products, /contact..." />
              </div>
            </div>
          </div>

          <!-- LAYOUT FOR CENTER BANNER (CREATE MODE) -->
          <div v-else class="layout-multi animate-in">
            <div class="form-row">
              <div class="form-group">
                <label>Tên Banner chính *</label>
                <input v-model="form.title" class="form-control" placeholder="Tên chung cho bộ banner..." />
              </div>
              <div class="form-group">
                <label>Link liên kết chung</label>
                <input v-model="form.linkUrl" class="form-control" placeholder="Dùng chung cho cả 4 ảnh..." />
              </div>
            </div>

            <label class="section-label">Danh sách 4 ảnh Slide</label>
            <div class="slots-grid">
              <div v-for="(slot, index) in centerSlots" :key="index" class="slot-card">
                <div class="slot-upload" @click="$refs['slotInput' + index][0].click()">
                  <input type="file" :ref="'slotInput' + index" accept="image/*" @change="e => onSlotImageSelected(e, index)" hidden />
                  <img v-if="slot.imageUrl" :src="slot.imageUrl" class="slot-img" />
                  <div v-else class="slot-empty">
                    <Plus v-if="!slot.uploading" :size="20" />
                    <Loader2 v-else :size="20" class="spinner" />
                  </div>
                </div>
                <div class="slot-meta">
                  <input
                    v-model.number="slot.sortOrder"
                    type="number"
                    min="1"
                    class="form-control sm"
                    placeholder="Vị trí"
                    title="Vị trí hiển thị"
                  />
                  <button 
                    type="button" 
                    class="status-toggle" 
                    :class="{ active: slot.isActive }"
                    @click="toggleSlotStatus(index)"
                  >
                    {{ slot.isActive ? 'Bật' : 'Ẩn' }}
                  </button>
                </div>
              </div>
            </div>
            <p class="text-xs text-muted mt-1">* Lưu ý: Cần ít nhất 1 ảnh hoạt động để hiển thị trang chủ.</p>
          </div>
        </div>
        <div class="modal-foot">
          <button class="btn btn-outline" @click="closeModal">Hủy bỏ</button>
          <button class="btn btn-primary" @click="saveBanner" :disabled="saving">
            <Loader2 v-if="saving" :size="16" class="spinner" /> <Save v-else :size="16" /> Lưu Banner
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

<style scoped>
/* ── Thumbnail styles ─────────────────────────────── */
.thumb-single {
  width: 100px;
  height: 60px;
  object-fit: cover;
  border-radius: 4px;
  display: block;
}

.thumb-group {
  display: flex;
  gap: 3px;
  align-items: center;
}

.thumb-group-img {
  width: 44px;
  height: 44px;
  object-fit: cover;
  border-radius: 4px;
  border: 1px solid #e2e8f0;
  transition: opacity 0.2s;
}

.thumb-group-img.thumb-inactive {
  opacity: 0.35;
  filter: grayscale(60%);
}

.d-block { display: block; }

.upload-dropzone {
  border: 2px dashed #e2e8f0;
  border-radius: 12px;
  padding: 2rem;
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
  border-color: var(--primary, #6366f1);
  background: #f1f5f9;
}

.upload-dropzone.has-image {
  padding: 0;
  border-style: solid;
}

.upload-icon-circle {
  width: 64px;
  height: 64px;
  background: #fff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1rem;
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
  font-size: 0.875rem;
}

.upload-text-hint {
  margin-top: 1rem;
  color: #94a3b8;
  font-size: 0.75rem;
}

.upload-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  color: var(--primary, #6366f1);
}

.upload-preview-container {
  width: 100%;
  height: 220px;
  position: relative;
}

.upload-preview-img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  background: #000;
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

/* Custom form control overrides to match mockup */
.form-control {
  border-radius: 8px;
  border: 1px solid #e2e8f0;
  padding: 0.625rem 0.875rem;
}

.form-control:focus {
  border-color: var(--primary, #6366f1);
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
}
.form-control.sm {
  padding: 0.4rem 0.55rem;
  min-width: 0;
  text-align: center;
}
/* Position Selector */
.position-selector {
  display: flex;
  gap: 0.5rem;
  background: #f1f5f9;
  padding: 4px;
  border-radius: 10px;
}
.pos-btn {
  flex: 1;
  padding: 0.6rem;
  border: none;
  background: transparent;
  border-radius: 8px;
  font-size: 0.88rem;
  font-weight: 600;
  color: #64748b;
  cursor: pointer;
  transition: all 0.2s;
}
.pos-btn.active {
  background: #fff;
  color: var(--primary, #6366f1);
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}
.pos-btn:disabled {
  cursor: not-allowed;
  opacity: 0.7;
}

/* Slots Grid */
.section-label {
  font-size: 0.88rem;
  font-weight: 700;
  color: #1e293b;
  margin: 0.5rem 0;
  display: block;
}
.slots-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1rem;
}
.slot-card {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.slot-upload {
  aspect-ratio: 4/3;
  background: #f8fafc;
  border: 2px dashed #e2e8f0;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  overflow: hidden;
  transition: all 0.2s;
}
.slot-upload:hover {
  border-color: var(--primary, #6366f1);
  background: #f1f5f9;
}
.slot-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.slot-empty {
  color: #94a3b8;
}
.slot-meta {
  display: flex;
  gap: 4px;
}
.status-toggle {
  padding: 0.4rem 0.6rem;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  background: #fff;
  font-size: 0.75rem;
  font-weight: 600;
  color: #64748b;
  cursor: pointer;
  flex: 1;
}
.status-toggle.active {
  background: #ecfdf5;
  color: #059669;
  border-color: #10b981;
}

@media (max-width: 640px) {
  .slots-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
