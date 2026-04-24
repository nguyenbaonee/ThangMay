<script setup>
import { ref, onMounted, computed } from 'vue'
import { Plus, Edit, Trash2, X, Search, Save, Eye, EyeOff, AlertTriangle, PlusCircle, MinusCircle, Star, Loader2 } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import productApi from '@/api/productApi'
import categoryApi from '@/api/categoryApi'
import mediaApi from '@/api/mediaApi'

const isLoading = ref(false)
const searchQuery = ref('')
const products = ref([])
const categories = ref([])

const isModalOpen = ref(false)
const isConfirmOpen = ref(false)
const modalMode = ref('create')
const targetDeleteId = ref(null)
const saving = ref(false)

const initialForm = {
  id: null, name: '', categoryId: '', price: '', summary: '', desc: '',
  thumbnailId: '', thumbnailPreview: '', imageIds: '', features: [''], specs: [{ label: '', value: '' }],
  isActive: true, isFeatured: false
}
const form = ref({ ...initialForm, features: [''], specs: [{ label: '', value: '' }] })

const isUploadingThumb = ref(false)
const isUploadingGallery = ref(false)

const onThumbnailSelected = async (e) => {
  const file = e.target.files[0]
  if (!file) return
  isUploadingThumb.value = true
  try {
    const res = await mediaApi.uploadSingle(file, 'products')
    form.value.thumbnailId = res.data.id
    form.value.thumbnailPreview = res.data.publicUrl || res.data.url
    toast.success('Upload ảnh thành công!')
  } catch (err) {
    toast.error('Lỗi upload ảnh!')
  } finally {
    isUploadingThumb.value = false
  }
}

const onGallerySelected = async (e) => {
  const files = e.target.files
  if (!files || files.length === 0) return
  isUploadingGallery.value = true
  try {
    const res = await mediaApi.uploadMultiple(files, 'products')
    const ids = res.data.map(item => item.id).join(';')
    if (form.value.imageIds) {
      form.value.imageIds += ';' + ids
    } else {
      form.value.imageIds = ids
    }
    toast.success('Upload gallery thành công!')
  } catch (err) {
    toast.error('Lỗi upload gallery!')
  } finally {
    isUploadingGallery.value = false
  }
}

// ── Data Fetching ───
const fetchData = async () => {
  isLoading.value = true
  try {
    const [catRes, prodRes] = await Promise.allSettled([
      categoryApi.listActive(),
      productApi.search({ keyword: searchQuery.value })
    ])
    if (catRes.status === 'fulfilled') categories.value = catRes.value?.data || []
    if (prodRes.status === 'fulfilled') products.value = prodRes.value?.data?.content || prodRes.value?.data || []
  } catch (error) {
    console.error('Error fetching products:', error)
    products.value = []
  } finally { isLoading.value = false }
}

onMounted(fetchData)

const filteredProducts = computed(() => {
  if (!searchQuery.value) return products.value
  const q = searchQuery.value.toLowerCase()
  return products.value.filter(p => p.name?.toLowerCase().includes(q))
})

const getCategoryName = (p) => {
  if (p.category?.name) return p.category.name
  if (typeof p.category === 'string' && p.category) return p.category
  return categories.value.find(c => c.id === p.categoryId)?.name || '—'
}

// ── Handlers ─────
const openCreate = () => {
  modalMode.value = 'create'
  form.value = JSON.parse(JSON.stringify(initialForm))
  isModalOpen.value = true
}
const openEdit = (p) => {
  modalMode.value = 'edit'
  form.value = JSON.parse(JSON.stringify(p))
  form.value.thumbnailPreview = p.thumbnail?.publicUrl || p.thumbnail?.url || (typeof p.thumbnail === 'string' ? p.thumbnail : '')
  if (!form.value.features?.length) form.value.features = ['']
  if (!form.value.specs?.length) form.value.specs = [{ label: '', value: '' }]
  isModalOpen.value = true
}
const closeModal = () => { isModalOpen.value = false }

const saveProduct = async () => {
  if (!form.value.name || !form.value.categoryId) {
    toast.error('Vui lòng điền đầy đủ Tên và Danh mục!'); return
  }
  saving.value = true
  try {
    const payload = {
      categoryId: form.value.categoryId, name: form.value.name,
      summary: form.value.summary, desc: form.value.desc,
      price: form.value.price, thumbnailId: form.value.thumbnailId,
      imageIds: form.value.imageIds, isFeatured: form.value.isFeatured,
      isActive: form.value.isActive,
      features: form.value.features.filter(f => f.trim()),
      specs: form.value.specs.filter(s => s.label?.trim())
    }
    if (modalMode.value === 'create') {
      await productApi.create(payload)
      toast.success('Thêm sản phẩm thành công!')
    } else {
      await productApi.update(form.value.id, payload)
      toast.success('Cập nhật sản phẩm thành công!')
    }
    closeModal(); fetchData()
  } catch (error) {
    console.error('Error saving product:', error)
    const msg = error.response?.data?.message || 'Có lỗi xảy ra khi lưu sản phẩm!'
    toast.error(msg)
  } finally { saving.value = false }
}

const toggleActive = async (p) => {
  const newVal = !p.isActive
  try { await productApi.toggleActive(p.id, newVal) } catch {}
  p.isActive = newVal
  toast.info(newVal ? 'Đã bật hiển thị' : 'Đã ẩn sản phẩm')
}

const triggerDelete = (id) => { targetDeleteId.value = id; isConfirmOpen.value = true }
const confirmDelete = async () => {
  try { await productApi.delete(targetDeleteId.value) } catch {}
  products.value = products.value.filter(p => p.id !== targetDeleteId.value)
  toast.success('Đã xoá sản phẩm!')
  isConfirmOpen.value = false; targetDeleteId.value = null
}

// Features & Specs helpers
const addFeature = () => form.value.features.push('')
const removeFeature = (i) => { if (form.value.features.length > 1) form.value.features.splice(i, 1) }
const addSpec = () => form.value.specs.push({ label: '', value: '' })
const removeSpec = (i) => { if (form.value.specs.length > 1) form.value.specs.splice(i, 1) }
</script>

<template>
  <div class="admin-page animate-in">
    <!-- Header -->
    <div class="page-header">
      <div>
        <h2>Quản lý Sản phẩm</h2>
        <p class="subtitle">Danh sách thang máy & dịch vụ</p>
      </div>
      <div class="page-actions">
        <div class="search-wrapper">
          <Search :size="16" class="search-icon" />
          <input v-model="searchQuery" placeholder="Tìm tên sản phẩm..." />
        </div>
        <button class="btn btn-primary" @click="openCreate"><Plus :size="16" /> Thêm mới</button>
      </div>
    </div>

    <!-- Table -->
    <div class="card">
      <div v-if="isLoading" class="loading-overlay"><div class="spinner"></div></div>
      <div v-else class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th style="width:56px">Ảnh</th>
              <th>Tên sản phẩm</th>
              <th>Danh mục</th>
              <th>Giá</th>
              <th class="text-center" style="width:60px">★</th>
              <th class="text-center" style="width:80px">Lượt xem</th>
              <th class="text-center" style="width:100px">Trạng thái</th>
              <th class="text-right" style="width:100px">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="filteredProducts.length === 0">
              <td colspan="8"><div class="empty-state"><Eye :size="40" /><p>Chưa có sản phẩm nào</p></div></td>
            </tr>
            <tr v-for="p in filteredProducts" :key="p.id">
              <td>
                <img v-if="p.thumbnail?.publicUrl || p.thumbnail?.url || p.thumbnail" :src="p.thumbnail?.publicUrl || p.thumbnail?.url || p.thumbnail" class="thumb-sm" alt="" />
                <div v-else class="thumb-sm" style="display:flex;align-items:center;justify-content:center;color:#94a3b8;font-size:0.7rem">N/A</div>
              </td>
              <td><span class="font-medium">{{ p.name }}</span></td>
              <td><span class="badge badge-category">{{ getCategoryName(p) }}</span></td>
              <td class="text-primary font-bold text-sm">{{ p.price || 'Liên hệ' }}</td>
              <td class="text-center">
                <button :class="['star-btn', p.isFeatured ? 'featured' : '']" @click="p.isFeatured = !p.isFeatured">
                  <Star :size="16" :fill="p.isFeatured ? 'currentColor' : 'none'" />
                </button>
              </td>
              <td class="text-center text-sm text-muted font-bold">{{ p.viewCount || 0 }}</td>
              <td class="text-center">
                <span :class="['badge', p.isActive ? 'badge-active' : 'badge-inactive']" style="cursor:pointer" @click="toggleActive(p)">
                  {{ p.isActive ? 'Hiển thị' : 'Đang ẩn' }}
                </span>
              </td>
              <td>
                <div class="row-actions">
                  <button class="act-btn" @click="openEdit(p)" title="Sửa"><Edit :size="16" /></button>
                  <button class="act-btn danger" @click="triggerDelete(p.id)" title="Xoá"><Trash2 :size="16" /></button>
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
        <div class="modal-head">
          <h3>{{ modalMode === 'create' ? 'Thêm Sản phẩm mới' : 'Chỉnh sửa Sản phẩm' }}</h3>
          <button class="act-btn" @click="closeModal"><X :size="20" /></button>
        </div>
        <div class="modal-body">
          <!-- Row 1 -->
          <div class="form-row">
            <div class="form-group">
              <label>Tên sản phẩm <span class="text-danger">*</span></label>
              <input v-model="form.name" class="form-control" placeholder="Nhập tên thang máy..." />
            </div>
            <div class="form-group">
              <label>Danh mục <span class="text-danger">*</span></label>
              <select v-model="form.categoryId" class="form-control">
                <option value="" disabled>— Chọn —</option>
                <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
              </select>
            </div>
          </div>
          <!-- Row 2 -->
          <div class="form-row">
            <div class="form-group">
              <label>Giá hiển thị</label>
              <input v-model="form.price" class="form-control" placeholder="VD: Liên hệ, 280tr..." />
            </div>
            <div class="form-group" style="justify-content:flex-end">
              <label class="form-check"><input type="checkbox" v-model="form.isFeatured" /> Sản phẩm nổi bật</label>
            </div>
          </div>
          <!-- Summary -->
          <div class="form-group">
            <label>Mô tả ngắn</label>
            <textarea v-model="form.summary" class="form-control" rows="2" placeholder="Mô tả ngắn gọn..."></textarea>
          </div>
          <!-- Description -->
          <div class="form-group">
            <label>Mô tả chi tiết</label>
            <textarea v-model="form.desc" class="form-control" rows="4" placeholder="Nội dung chi tiết sản phẩm..."></textarea>
          </div>
          <!-- Thumbnail -->
          <div class="form-row">
            <div class="form-group">
              <label>Ảnh đại diện (Thumbnail)</label>
              <input type="file" accept="image/*" @change="onThumbnailSelected" :disabled="isUploadingThumb" class="form-control" />
              <div v-if="isUploadingThumb" class="text-sm text-primary" style="margin-top:4px">Đang tải ảnh lên...</div>
              <img v-if="form.thumbnailPreview" :src="form.thumbnailPreview" style="height: 60px; object-fit: contain; margin-top: 8px; border-radius: 4px; background: #f8fafc;" />
            </div>
            <div class="form-group">
              <label>Nhiều ảnh tải lên (Gallery)</label>
              <input type="file" accept="image/*" multiple @change="onGallerySelected" :disabled="isUploadingGallery" class="form-control" />
              <div v-if="isUploadingGallery" class="text-sm text-primary" style="margin-top:4px">Đang tải ảnh lên...</div>
              <div style="margin-top:4px; font-size:0.85rem; color:#64748b; word-break: break-all;" v-if="form.imageIds">Image IDs: {{ form.imageIds }}</div>
            </div>
          </div>
          <!-- Features -->
          <div class="form-group">
            <label>Tính năng nổi bật</label>
            <div style="display:flex;flex-direction:column;gap:0.4rem">
              <div v-for="(f, i) in form.features" :key="i" style="display:flex;gap:0.4rem">
                <input v-model="form.features[i]" class="form-control" :placeholder="'Tính năng ' + (i+1)" />
                <button class="act-btn danger" @click="removeFeature(i)" v-if="form.features.length > 1"><MinusCircle :size="16" /></button>
              </div>
              <button class="add-tag-btn" @click="addFeature"><PlusCircle :size="14" /> Thêm</button>
            </div>
          </div>
          <!-- Specs -->
          <div class="form-group">
            <label>Thông số kỹ thuật</label>
            <div style="display:flex;flex-direction:column;gap:0.4rem">
              <div v-for="(s, i) in form.specs" :key="i" style="display:flex;gap:0.4rem">
                <input v-model="form.specs[i].label" class="form-control" placeholder="Tên thông số" style="flex:1" />
                <input v-model="form.specs[i].value" class="form-control" placeholder="Giá trị" style="flex:1" />
                <button class="act-btn danger" @click="removeSpec(i)" v-if="form.specs.length > 1"><MinusCircle :size="16" /></button>
              </div>
              <button class="add-tag-btn" @click="addSpec"><PlusCircle :size="14" /> Thêm</button>
            </div>
          </div>
        </div>
        <div class="modal-foot">
          <button class="btn btn-outline" @click="closeModal">Huỷ bỏ</button>
          <button class="btn btn-primary" @click="saveProduct" :disabled="saving">
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
        <p>Sản phẩm sẽ bị xoá vĩnh viễn khỏi hệ thống.</p>
        <div class="actions">
          <button class="btn btn-outline" @click="isConfirmOpen = false">Huỷ</button>
          <button class="btn btn-danger" @click="confirmDelete">Đồng ý xoá</button>
        </div>
      </div>
    </div>
  </div>
</template>
