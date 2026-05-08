<script setup>
import { CheckCircle, Download, Loader2, Share2, ShieldCheck, UserRoundCheck } from 'lucide-vue-next'
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
const resolveCategoryName = (p) => p?.categoryObj?.name || p?.category?.name || p?.category || 'Thang máy'
const setTabRef = (el, key) => {
  if (el) tabRefs.value[key] = el
}

const fetchProduct = async () => {
  const productId = route.params.id
  if (!productId) {
    isLoading.value = false
    return
  }

  try {
    const res = await productApi.getById(productId)
    product.value = res.data
    if (galleryImages.value.length > 0) activeImage.value = galleryImages.value[0]
  } catch (error) {
    console.error('Error fetching product detail:', error)
    product.value = null
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

const displayPrice = computed(() => {
  const value = product.value?.price
  if (!value || String(value).trim() === '0') return 'Liên hệ để biết giá'
  return value
})

const fallbackSpecs = computed(() => ([
  { label: 'Tải trọng', value: product.value?.loadCapacity ? `${product.value.loadCapacity} kg` : '750kg' },
  { label: 'Tốc độ', value: product.value?.speed ? `${product.value.speed} m/s` : '1.0 - 1.75 m/s' },
  { label: 'Số điểm dừng', value: product.value?.stops ? `${product.value.stops} điểm dừng` : '2 - 5 điểm dừng' },
  { label: 'Hệ thống điều khiển', value: product.value?.controlSystem || 'Biến tần VVVF' },
  { label: 'Nguồn điện', value: product.value?.powerSupply || '3 pha, 380V - 50Hz' },
  { label: 'Loại cửa', value: product.value?.doorType || 'Cửa tự động' }
]))

const specs = computed(() => {
  const productSpecs = product.value?.specs || []
  return productSpecs.length > 0
    ? productSpecs.map(spec => ({
        label: spec.label,
        value: `${spec.value || ''}${spec.unit ? ` ${spec.unit}` : ''}`.trim()
      }))
    : fallbackSpecs.value
})
</script>

<template>
  <div class="product-detail">
    <div v-if="isLoading" class="detail-loader">
      <Loader2 class="spinner" :size="48" />
    </div>

    <div v-else-if="!product" class="container empty-state">
      <h2>Không tìm thấy sản phẩm</h2>
      <p>Sản phẩm bạn đang tìm kiếm không tồn tại hoặc đã bị gỡ bỏ.</p>
    </div>

    <template v-else>
      <section class="detail-hero">
        <div class="container">
          <div class="detail-grid">
            <div class="gallery-panel">
              <div class="main-image">
                <img v-if="activeImage" :src="activeImage" :alt="product.name" />
                <div v-else class="image-empty">No Image</div>
              </div>
              <div v-if="galleryImages.length > 1" class="thumb-row">
                <button
                  v-for="img in galleryImages"
                  :key="img"
                  type="button"
                  :class="['thumb', activeImage === img ? 'active' : '']"
                  @click="activeImage = img"
                >
                  <img :src="img" :alt="product.name" />
                </button>
              </div>
            </div>

            <aside class="summary-panel">
              <p class="eyebrow">{{ resolveCategoryName(product) }}</p>
              <h1>{{ product.name || 'Chưa có tiêu đề' }}</h1>
              <div class="price-block">
                <span>Giá:</span>
                <strong>{{ displayPrice }}</strong>
              </div>

              <div class="action-row">
                <router-link to="/contact" class="quote-btn">Yêu cầu báo giá</router-link>
                <button class="round-btn" type="button" title="Chia sẻ"><Share2 :size="22" /></button>
                <button class="round-btn" type="button" title="Tải brochure"><Download :size="22" /></button>
              </div>

              <div class="benefit-box">
                <div class="benefit-item">
                  <span class="benefit-icon"><ShieldCheck :size="24" /></span>
                  <span>Bảo hành 24 tháng chính hãng</span>
                </div>
                <div class="benefit-item">
                  <span class="benefit-icon"><UserRoundCheck :size="24" /></span>
                  <span>Tư vấn và đo đạc miễn phí</span>
                </div>
              </div>
            </aside>
          </div>
        </div>
      </section>

      <section class="detail-tabs-section">
        <div class="container">
          <div class="tabs-card">
            <div class="tabs-header">
              <button
                :ref="el => setTabRef(el, 'specs')"
                :class="['tab-link', activeTab === 'specs' ? 'active' : '']"
                type="button"
                @click="activeTab = 'specs'"
              >
                Thông số kỹ thuật
              </button>
              <button
                :ref="el => setTabRef(el, 'features')"
                :class="['tab-link', activeTab === 'features' ? 'active' : '']"
                type="button"
                @click="activeTab = 'features'"
              >
                Tính năng nổi bật
              </button>
              <button
                :ref="el => setTabRef(el, 'content')"
                :class="['tab-link', activeTab === 'content' ? 'active' : '']"
                type="button"
                @click="activeTab = 'content'"
              >
                Chi tiết sản phẩm
              </button>
            </div>

            <div class="tab-content">
              <div v-if="activeTab === 'specs'" class="spec-table">
                <div v-for="spec in specs" :key="spec.label" class="spec-cell">
                  <span>{{ spec.label }}</span>
                  <strong>{{ spec.value || 'Đang cập nhật' }}</strong>
                </div>
              </div>

              <div v-if="activeTab === 'features'" class="features-list">
                <ul v-if="product.features && product.features.length > 0">
                  <li v-for="feature in product.features" :key="feature">
                    <CheckCircle :size="20" />
                    <span>{{ feature }}</span>
                  </li>
                </ul>
                <p v-else class="empty-tab">Chưa cập nhật tính năng.</p>
              </div>

              <div v-if="activeTab === 'content'" class="product-desc">
                <div class="rich-content" v-html="product.desc || 'Chưa có nội dung chi tiết.'"></div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </template>
  </div>
</template>

<style scoped>
.product-detail {
  background: #fff;
  color: #061b36;
  padding-top: 122px;
}

.detail-loader,
.empty-state {
  min-height: 420px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
}

.spinner {
  color: var(--primary);
  animation: spin 1s linear infinite;
}

.detail-hero {
  padding: 28px 0 54px;
}

.detail-grid {
  display: grid;
  grid-template-columns: minmax(0, 0.85fr) minmax(300px, 0.7fr);
  gap: 72px;
  align-items: start;
}

.gallery-panel {
  min-width: 0;
}

.main-image {
  width: 100%;
  aspect-ratio: 1.35 / 1;
  border-radius: 14px;
  overflow: hidden;
  background: #eef1f5;
}

.main-image img,
.thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.image-empty {
  height: 100%;
  display: grid;
  place-items: center;
  color: #7f8792;
}

.thumb-row {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 12px;
}

.thumb {
  width: 64px;
  height: 52px;
  padding: 0;
  border: 2px solid transparent;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  background: #f4f5f7;
  transition: transform 0.22s ease, border-color 0.22s ease, box-shadow 0.22s ease;
}

.thumb:hover,
.thumb.active {
  border-color: #061b36;
  box-shadow: 0 10px 24px rgba(6, 27, 54, 0.14);
  transform: translateY(-2px);
}

.summary-panel {
  max-width: 460px;
  padding: 8px 0 0;
}

.eyebrow {
  color: #c3a154;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.12em;
  margin-bottom: 10px;
  text-transform: uppercase;
}

.summary-panel h1 {
  color: #061b36;
  font-size: clamp(30px, 3.3vw, 40px);
  line-height: 1.08;
  font-weight: 900;
  margin-bottom: 16px;
  max-width: 620px;
}

.price-block {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-bottom: 16px;
}

.price-block span {
  font-size: 15px;
  color: #061b36;
  font-weight: 600;
}

.price-block strong {
  color: #b99a4a;
  font-size: clamp(26px, 2.9vw, 34px);
  font-weight: 900;
  line-height: 1.1;
}

.action-row {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 18px;
  flex-wrap: wrap;
}

.quote-btn {
  display: inline-flex;
  min-width: 174px;
  height: 44px;
  align-items: center;
  justify-content: center;
  padding: 0 22px;
  border-radius: 999px;
  background: linear-gradient(135deg, #d6b65b, #b39143);
  color: #061b36;
  font-size: 14px;
  font-weight: 800;
  box-shadow: 0 16px 34px rgba(179, 145, 67, 0.24);
  transition: transform 0.3s ease, box-shadow 0.3s ease, filter 0.3s ease;
  text-decoration: none;
}

.quote-btn:hover {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 20px 40px rgba(179, 145, 67, 0.35);
  filter: brightness(1.1);
}

.round-btn {
  width: 44px;
  height: 44px;
  border-radius: 999px;
  border: 2px solid #061b36;
  background: #fff;
  color: #061b36;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: transform 0.22s ease, background 0.22s ease, color 0.22s ease;
}

.round-btn:hover {
  transform: translateY(-2px);
  background: #061b36;
  color: #fff;
}

.benefit-box {
  width: min(100%, 430px);
  padding: 14px 18px;
  border-radius: 12px;
  background: linear-gradient(135deg, #fff9e9, #f7f0db);
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.benefit-item {
  display: flex;
  align-items: center;
  gap: 13px;
  color: #061b36;
  font-size: 14px;
  font-weight: 600;
}

.benefit-icon {
  width: 38px;
  height: 38px;
  border-radius: 999px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #d7b85f, #b99544);
  color: #061b36;
  flex: 0 0 auto;
}

.detail-tabs-section {
  padding: 42px 0 64px;
  background: #f5f6f8;
}

.tabs-card {
  background: #fff;
  border: 1px solid #d8dde6;
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 18px 50px rgba(6, 27, 54, 0.06);
}

.tabs-header {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  border-bottom: 1px solid #d8dde6;
  background: #fbfbfc;
}

.tab-link {
  min-height: 58px;
  border: 0;
  border-right: 1px solid #d8dde6;
  background: transparent;
  color: #161b22;
  font-size: 18px;
  font-weight: 500;
  cursor: pointer;
  position: relative;
}

.tab-link:last-child {
  border-right: 0;
}

.tab-link.active {
  color: #061b36;
  background: #fff;
  font-weight: 800;
}

.tab-link.active::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 6px;
  background: linear-gradient(90deg, #061b36 0 52%, #c3a154 52% 100%);
}

.tab-content {
  padding: 34px 30px 32px;
}

.spec-table {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  border: 1px solid #dde2ea;
  border-bottom: 0;
  border-right: 0;
}

.spec-cell {
  min-height: 68px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 8px;
  padding: 14px 18px;
  border-right: 1px solid #dde2ea;
  border-bottom: 1px solid #dde2ea;
  background: #fff;
}

.spec-cell:nth-child(8n + 1),
.spec-cell:nth-child(8n + 2),
.spec-cell:nth-child(8n + 3),
.spec-cell:nth-child(8n + 4) {
  background: #f2f4f8;
}

.spec-cell span {
  color: #525a66;
  font-size: 14px;
  font-weight: 600;
}

.spec-cell strong {
  color: #111827;
  font-size: 15px;
  font-weight: 700;
}

.features-list ul {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px 28px;
}

.features-list li {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  font-size: 16px;
  line-height: 1.6;
  color: #27313d;
}

.features-list svg {
  color: #b99544;
  flex: 0 0 auto;
  margin-top: 4px;
}

.rich-content {
  color: #27313d;
  font-size: 16px;
  line-height: 1.85;
}

.empty-tab {
  text-align: center;
  color: #7a8290;
  padding: 28px 0;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@media (max-width: 992px) {
  .product-detail {
    padding-top: 92px;
  }

  .detail-hero {
    padding: 22px 0 40px;
  }

  .detail-grid {
    grid-template-columns: 1fr;
    gap: 24px;
  }

  .main-image {
    aspect-ratio: 1.45 / 1;
  }

  .summary-panel h1 {
    font-size: clamp(28px, 6.5vw, 38px);
    margin-bottom: 18px;
  }

  .tabs-header {
    display: flex;
    overflow-x: auto;
    scrollbar-width: none;
  }

  .tabs-header::-webkit-scrollbar {
    display: none;
  }

  .tab-link {
    flex: 0 0 auto;
    min-width: 190px;
    font-size: 16px;
  }

  .tab-content {
    padding: 24px 16px;
  }

  .spec-table {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 640px) {
  .product-detail {
    padding-top: 78px;
  }

  .detail-hero {
    padding: 16px 0 28px;
  }

  .main-image {
    aspect-ratio: 1.2 / 1;
    border-radius: 12px;
  }

  .thumb-row {
    flex-wrap: nowrap;
    gap: 8px;
    overflow-x: auto;
    padding-bottom: 4px;
  }

  .thumb {
    width: 50px;
    min-width: 50px;
    height: 40px;
    border-radius: 7px;
  }

  .summary-panel {
    padding-top: 0;
  }

  .eyebrow {
    margin-bottom: 8px;
  }

  .summary-panel h1 {
    font-size: 27px;
  }

  .price-block span {
    font-size: 16px;
  }

  .price-block strong {
    font-size: 28px;
  }

  .action-row {
    gap: 10px;
  }

  .quote-btn {
    width: 100%;
    min-width: 0;
    height: 48px;
    font-size: 15px;
  }

  .round-btn {
    width: 46px;
    height: 46px;
  }

  .benefit-box {
    padding: 15px;
    gap: 12px;
  }

  .benefit-item {
    font-size: 15px;
    gap: 12px;
  }

  .benefit-icon {
    width: 42px;
    height: 42px;
  }

  .detail-tabs-section {
    padding: 28px 0 48px;
  }

  .tabs-card {
    border-radius: 12px;
  }

  .tab-link {
    min-width: 152px;
    min-height: 54px;
    font-size: 14px;
  }

  .spec-table {
    grid-template-columns: 1fr;
  }

  .spec-cell:nth-child(n) {
    background: #fff;
  }

  .spec-cell:nth-child(odd) {
    background: #f2f4f8;
  }

  .features-list ul {
    grid-template-columns: 1fr;
  }

  .features-list li,
  .rich-content {
    font-size: 15px;
  }
}
</style>
