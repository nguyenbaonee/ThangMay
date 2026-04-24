<script setup>
import { ShoppingCart, CheckCircle, ArrowLeft, Phone, Share2, Download, Loader2 } from 'lucide-vue-next'
import { ref, onMounted, computed, watch, nextTick } from 'vue'
import { useRoute } from 'vue-router'
import productApi from '@/api/productApi'

const route = useRoute()
const isLoading = ref(true)
const product = ref(null)
const activeImage = ref('')
const activeTab = ref('specs')
const tabRefs = ref({})

const resolveImageUrl = (item) => item?.publicUrl || item?.url || item || ''
const resolveCategoryName = (p) => p?.categoryObj?.name || p?.category?.name || p?.category || ''
const setTabRef = (el, key) => {
  if (el) tabRefs.value[key] = el
}

const isUuid = (value) => /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(value || '')

const resolveProductId = async (value) => {
  if (isUuid(value)) return value

  const searchRes = await productApi.publicSearch({ keyword: value, size: 50 })
  const list = searchRes.data?.content || searchRes.data?.items || searchRes.data || []
  if (!Array.isArray(list) || list.length === 0) return null

  const matched = list.find((item) =>
    item?.id === value ||
    item?.slug === value ||
    item?.name === value
  ) || list[0]

  return matched?.id || null
}

const fetchProduct = async () => {
  const productId = route.params.id
  try {
    const resolvedId = await resolveProductId(productId)
    if (!resolvedId) {
      product.value = null
      return
    }

    const res = await productApi.getById(resolvedId)
    product.value = res.data
    if (product.value.images && product.value.images.length > 0) {
      activeImage.value = resolveImageUrl(product.value.images[0])
    } else if (product.value.thumbnail) {
      activeImage.value = resolveImageUrl(product.value.thumbnail.publicUrl || product.value.thumbnail.url)
    }
  } catch (error) {
    console.error('Error fetching product detail:', error)
  } finally {
    isLoading.value = false
  }
}

onMounted(fetchProduct)

watch(activeTab, async () => {
  await nextTick()
  tabRefs.value[activeTab.value]?.scrollIntoView({
    behavior: 'smooth',
    block: 'nearest',
    inline: 'center'
  })
})

const galleryImages = computed(() => {
  const imgs = []
  if (product.value?.thumbnail) imgs.push(resolveImageUrl(product.value.thumbnail.publicUrl || product.value.thumbnail.url))
  if (product.value?.images) {
    product.value.images.forEach(img => {
      const resolved = resolveImageUrl(img)
      if (resolved && !imgs.includes(resolved)) imgs.push(resolved)
    })
  }
  return imgs
})
</script>

<template>
  <div class="product-detail">
    <div class="container py-subnav">
      <router-link to="/products" class="back-link"><ArrowLeft :size="16" /> Quay lại</router-link>
    </div>

    <div v-if="isLoading" class="flex-center py-5">
      <Loader2 class="spinner text-primary" :size="48" />
    </div>

    <div v-else-if="!product" class="container text-center py-5 empty-state">
      <h2>Không tìm thấy sản phẩm</h2>
      <p>Sản phẩm bạn đang tìm kiếm không tồn tại hoặc đã bị gỡ bỏ.</p>
    </div>

    <template v-else>
      <section class="section-padding container">
        <div class="product-main-grid">
          <!-- Gallery -->
          <div class="gallery-side">
            <div class="main-image glass animate-fade-in">
              <img v-if="activeImage" :src="activeImage" :alt="product.name" />
              <div v-else class="flex-center h-100 bg-light text-muted">No Image</div>
            </div>
            <div v-if="galleryImages.length > 1" class="thumbnails animate-fade-in">
              <div 
                v-for="img in galleryImages" 
                :key="img" 
                :class="['thumb', activeImage === img ? 'active' : '']"
                @click="activeImage = img"
              >
                <img :src="img" :alt="product.name" />
              </div>
            </div>
          </div>

          <!-- Info -->
          <div class="info-side animate-fade-in">
            <h4 class="label">{{ resolveCategoryName(product) }}</h4>
            <h1>{{ product.name || 'Chưa có tiêu đề' }}</h1>
            <p class="price-big">{{ product.price || 'Liên hệ' }}</p>
            <p class="short-desc">{{ product.summary || product.desc || 'Chưa có mô tả ngắn.' }}</p>
            
            <div class="action-btns">
              <router-link to="/contact" class="btn btn-primary lg">Yêu cầu báo giá</router-link>
              <div class="secondary-actions">
                <button class="icon-btn" title="Chia sẻ"><Share2 :size="20" /></button>
                <button class="icon-btn" title="Tải Brochure"><Download :size="20" /></button>
              </div>
            </div>

            <div class="quick-info">
              <div class="info-item">
                <CheckCircle :size="20" class="primary-icon" />
                <span>Bảo hành 24 tháng chính hãng</span>
              </div>
              <div class="info-item">
                <CheckCircle :size="20" class="primary-icon" />
                <span>Tư vấn và đo đạc miễn phí</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Details Tabs -->
      <section class="section-padding bg-light">
        <div class="container">
          <div class="tabs-header">
            <button 
              :ref="el => setTabRef(el, 'specs')"
              :class="['tab-link', activeTab === 'specs' ? 'active' : '']"
              @click="activeTab = 'specs'"
            >
              Thông số kỹ thuật
            </button>
            <button 
              :ref="el => setTabRef(el, 'features')"
              :class="['tab-link', activeTab === 'features' ? 'active' : '']"
              @click="activeTab = 'features'"
            >
              Tính năng nổi bật
            </button>
            <button 
              :ref="el => setTabRef(el, 'content')"
              :class="['tab-link', activeTab === 'content' ? 'active' : '']"
              @click="activeTab = 'content'"
            >
              Chi tiết sản phẩm
            </button>
          </div>

          <div class="tab-content glass mt-4 p-4">
            <!-- Specs -->
            <div v-if="activeTab === 'specs'" class="specs-grid animate-fade-in">
              <template v-if="product.specs && product.specs.length > 0">
                <div v-for="spec in product.specs" :key="spec.label" class="spec-row">
                  <span class="label-spec">{{ spec.label }}</span>
                  <span class="value-spec">{{ spec.value }} {{ spec.unit || '' }}</span>
                </div>
              </template>
              <div v-else class="text-center py-4 text-muted col-span-full">Chưa cập nhật thông số.</div>
            </div>

            <!-- Features -->
            <div v-if="activeTab === 'features'" class="features-list animate-fade-in">
              <ul v-if="product.features && product.features.length > 0" class="custom-list">
                <li v-for="feature in product.features" :key="feature">
                  <CheckCircle :size="18" class="li-icon" />
                  <span>{{ feature }}</span>
                </li>
              </ul>
              <div v-else class="text-center py-4 text-muted">Chưa cập nhật tính năng.</div>
            </div>

            <!-- Content -->
            <div v-if="activeTab === 'content'" class="product-desc animate-fade-in">
              <div class="rich-content" v-html="product.desc || 'Chưa có nội dung chi tiết.'"></div>
            </div>
          </div>
        </div>
      </section>
    </template>
  </div>
</template>

<style scoped>
.py-subnav {
  padding-top: 120px;
  padding-bottom: 12px;
}

.back-link {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 600;
  font-size: 0.95rem;
  color: var(--text-light);
  padding: 0.25rem 0;
  width: fit-content;
  line-height: 1.2;
}

.back-link:hover {
  color: var(--primary);
}

.empty-state {
  padding-top: 1.5rem;
}

.product-main-grid {
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: 5rem;
  align-items: flex-start;
}

.gallery-side {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.main-image {
  height: 500px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow);
}

.main-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.thumbnails {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}

.thumb {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  border: 2px solid transparent;
  transition: var(--transition);
}

.thumb.active {
  border-color: var(--primary);
}

.thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.info-side .label {
  color: var(--primary);
  font-weight: 700;
  margin-bottom: 1rem;
}

.info-side h1 {
  font-size: 3rem;
  margin-bottom: 1.5rem;
  line-height: 1.2;
}

.price-big {
  font-size: 2rem;
  color: var(--primary);
  font-weight: 800;
  margin-bottom: 2rem;
}

.short-desc {
  color: var(--text-light);
  line-height: 1.8;
  margin-bottom: 3rem;
}

.action-btns {
  display: flex;
  gap: 2rem;
  align-items: center;
  margin-bottom: 3rem;
}

.secondary-actions {
  display: flex;
  gap: 1rem;
}

.icon-btn {
  width: 45px;
  height: 45px;
  border-radius: 50%;
  border: 1px solid #ddd;
  background: white;
  color: var(--text-light);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: var(--transition);
}

.icon-btn:hover {
  border-color: var(--primary);
  color: var(--primary);
  background: #fdfdfd;
}

.quick-info {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 0.8rem;
  font-weight: 500;
}

.primary-icon {
  color: var(--primary);
}

/* Tabs */
.tabs-header {
  display: flex;
  gap: 1rem;
  border-bottom: 1px solid #eee;
  overflow-x: auto;
  overflow-y: hidden;
  scrollbar-width: none;
  -ms-overflow-style: none;
  scroll-snap-type: x proximity;
}

.tabs-header::-webkit-scrollbar {
  display: none;
}

.tab-link {
  background: none;
  border: none;
  padding: 1rem 0;
  font-weight: 700;
  font-size: 1.1rem;
  color: var(--text-light);
  cursor: pointer;
  position: relative;
  white-space: nowrap;
  flex: 0 0 auto;
  scroll-snap-align: start;
}

.tab-link.active {
  color: var(--primary);
}

.tab-link.active::after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 100%;
  height: 3px;
  background: var(--primary);
}

.specs-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.spec-row {
  display: flex;
  justify-content: space-between;
  padding: 1.2rem;
  background: #f8f9fa;
  border-radius: 8px;
}

.label-spec {
  color: var(--text-light);
  font-weight: 600;
}

.value-spec {
  font-weight: 700;
  color: var(--secondary);
}

.custom-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.custom-list li {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.li-icon {
  color: var(--primary);
  flex-shrink: 0;
}

.rich-content {
  line-height: 1.8;
  color: var(--text-dark);
}

.flex-center {
  display: flex;
  justify-content: center;
  align-items: center;
}

.h-100 { height: 100%; }

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.col-span-full {
  grid-column: 1 / -1;
}

@media (max-width: 992px) {
  .product-main-grid {
    grid-template-columns: 1fr;
    gap: 3rem;
  }
  .main-image {
      height: 350px;
  }
}

@media (max-width: 768px) {
  .py-subnav {
    padding-top: 92px;
    padding-bottom: 8px;
  }

  .back-link {
    font-size: 0.9rem;
    gap: 0.4rem;
  }

  .specs-grid {
    grid-template-columns: 1fr;
  }

  .tabs-header {
    gap: 0.75rem;
    padding-bottom: 0.25rem;
  }

  .tab-link {
    font-size: 1rem;
    padding: 0.9rem 0;
  }

  .action-btns {
    flex-direction: column;
    align-items: stretch;
    gap: 1rem;
    margin-bottom: 2rem;
  }

  .secondary-actions {
    justify-content: center;
  }

  .main-image {
    height: 280px;
  }

  .info-side h1 {
    font-size: 2.1rem;
  }

  .price-big {
    font-size: 1.6rem;
    margin-bottom: 1.25rem;
  }

  .short-desc {
    margin-bottom: 2rem;
  }

  .spec-row {
    padding: 1rem;
    gap: 0.75rem;
  }

  .tab-content {
    padding: 1rem !important;
  }
}

@media (max-width: 480px) {
  .py-subnav {
    padding-top: 84px;
  }

  .main-image {
    height: 220px;
  }

  .thumb {
    width: 64px;
    height: 64px;
  }

  .info-side h1 {
    font-size: 1.8rem;
  }

  .tabs-header {
    gap: 0.5rem;
  }

  .tab-link {
    font-size: 0.95rem;
  }
}
</style>
