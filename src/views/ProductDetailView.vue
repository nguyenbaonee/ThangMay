<script setup>
import { ShoppingCart, CheckCircle, ArrowLeft, Phone, Share2, Download } from 'lucide-vue-next'
import { ref } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const productId = route.params.id

// Demo product data
const product = {
  id: productId,
  name: 'Thang máy gia đình hiện đại',
  category: 'Home',
  price: 'Liên hệ',
  images: [
    '/images/3653228387362596575.jpg',
    '/images/3653228387362596575 (1).jpg',
    '/images/3653228387362596575 (2).jpg'
  ],
  desc: 'Thang máy gia đình BaoThangMay là giải pháp hoàn hảo cho các công trình nhà phố, biệt thự với diện tích hạn chế. Sản phẩm kết hợp công nghệ truyền động tiên tiến, vận hành êm ái và tiết kiệm điện năng.',
  specs: [
    { label: 'Tải trọng', value: '250kg - 450kg' },
    { label: 'Số người', value: '3 - 6 người' },
    { label: 'Tốc độ', value: '0.15m/s - 0.4m/s' },
    { label: 'Kích thước hố thang', value: 'Tối thiểu 1000mm x 1000mm' },
    { label: 'Chiều cao OH', value: 'Tối thiểu 2400mm' },
    { label: 'Chiều sâu hố PIT', value: 'Tối thiểu 150mm' }
  ],
  features: [
    'Hệ thống cứu hộ tự động (ARD) khi mất điện.',
    'Cảm biến an toàn mành hồng ngoại dọc cửa thang.',
    'Bảng điều khiển cảm ứng sang trọng.',
    'Sử dụng động cơ không hộp số tiết kiệm 40% điện năng.',
    'Vật liệu Inox gương vàng hoặc vân gỗ cao cấp.'
  ]
}

const activeImage = ref(product.images[0])
const activeTab = ref('specs')
</script>

<template>
  <div class="product-detail">
    <div class="container py-subnav">
      <router-link to="/products" class="back-link"><ArrowLeft :size="16" /> Quay lại danh sách</router-link>
    </div>

    <section class="section-padding container">
      <div class="product-main-grid">
        <!-- Gallery -->
        <div class="gallery-side">
          <div class="main-image glass animate-fade-in">
            <img :src="activeImage" :alt="product.name" />
          </div>
          <div class="thumbnails animate-fade-in">
            <div 
              v-for="img in product.images" 
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
          <h4 class="label">{{ product.category }}</h4>
          <h1>{{ product.name }}</h1>
          <p class="price-big">{{ product.price }}</p>
          <p class="short-desc">{{ product.desc }}</p>
          
          <div class="action-btns">
            <router-link to="/contact" class="btn btn-primary lg">Yêu cầu báo giá</router-link>
            <div class="secondary-actions">
              <button class="icon-btn"><Share2 :size="20" /></button>
              <button class="icon-btn"><Download :size="20" /></button>
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
            :class="['tab-link', activeTab === 'specs' ? 'active' : '']"
            @click="activeTab = 'specs'"
          >
            Thông số kỹ thuật
          </button>
          <button 
            :class="['tab-link', activeTab === 'features' ? 'active' : '']"
            @click="activeTab = 'features'"
          >
            Tính năng nổi bật
          </button>
        </div>

        <div class="tab-content glass mt-4 p-4">
          <!-- Specs -->
          <div v-if="activeTab === 'specs'" class="specs-grid animate-fade-in">
            <div v-for="spec in product.specs" :key="spec.label" class="spec-row">
              <span class="label-spec">{{ spec.label }}</span>
              <span class="value-spec">{{ spec.value }}</span>
            </div>
          </div>

          <!-- Features -->
          <div v-if="activeTab === 'features'" class="features-list animate-fade-in">
            <ul class="custom-list">
              <li v-for="feature in product.features" :key="feature">
                <CheckCircle :size="18" class="li-icon" />
                <span>{{ feature }}</span>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <!-- Related Products -->
    <section class="section-padding container">
      <h2 class="mb-5">Công trình liên quan</h2>
      <div class="grid-3">
        <!-- Render 3 random product cards or similar projects -->
        <div class="project-card glass hover-effect">
            <img src="/images/3726039324607881804.jpg" alt="Related" />
            <div class="p-3">
                <h4>Biệt thự Riviera Point</h4>
                <p>Thang máy kính quan sát cao cấp.</p>
            </div>
        </div>
        <div class="project-card glass hover-effect">
            <img src="/images/3726039324607881804 (3).jpg" alt="Related" />
            <div class="p-3">
                <h4>Nhà phố Shophouse Sala</h4>
                <p>Thang máy gia đình không hố Pit.</p>
            </div>
        </div>
        <div class="project-card glass hover-effect">
            <img src="/images/3726039324607881804 (4).jpg" alt="Related" />
            <div class="p-3">
                <h4>Penhouse Landmark 81</h4>
                <p>Thang máy nội thất Inox gương vàng.</p>
            </div>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.py-subnav {
  padding-top: 120px;
  padding-bottom: 20px;
}

.back-link {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 600;
  color: var(--text-light);
}

.back-link:hover {
  color: var(--primary);
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
}

.thumb {
  width: 100px;
  height: 100px;
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
  gap: 3rem;
  border-bottom: 1px solid #eee;
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

.project-card {
    border-radius: 12px;
    overflow: hidden;
    background: white !important;
}

.project-card img {
    width: 100%;
    height: 200px;
    object-fit: cover;
    transition: var(--transition);
}

.project-card:hover img {
    transform: scale(1.05);
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
</style>
