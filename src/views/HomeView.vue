<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import { ArrowRight, Settings, ShieldCheck, Headphones, Zap, Loader2 } from 'lucide-vue-next'
import productApi from '@/api/productApi'
import bannerApi from '@/api/bannerApi'

const isLoading = ref(true)
const featuredProducts = ref([])
const homeBanners = ref([])
const activeBannerIndex = ref(0)
let bannerInterval = null

const resolveProducts = (payload) => payload?.content || payload?.items || payload || []
const resolveImageUrl = (product) => product?.thumbnail?.publicUrl || product?.thumbnail?.url || product?.images?.[0] || '/images/placeholder.jpg'

const services = [
  { title: 'Tư vấn - Thiết kế', icon: Settings, desc: 'Giải pháp tối ưu theo thực trạng công trình.' },
  { title: 'Lắp đặt chuyên nghiệp', icon: Zap, desc: 'Đội ngũ kỹ thuật tay nghề cao, đúng tiến độ.' },
  { title: 'Bảo trì trọn đời', icon: ShieldCheck, desc: 'An tâm sử dụng với dịch vụ bảo trì 24/7.' },
  { title: 'Hỗ trợ kỹ thuật', icon: Headphones, desc: 'Luôn sẵn sàng giải đáp mọi thắc mắc của khách hàng.' }
]

const nextBanner = () => {
  if (homeBanners.value.length <= 1) return
  activeBannerIndex.value = (activeBannerIndex.value + 1) % homeBanners.value.length
}

const startBannerTimer = () => {
  stopBannerTimer()
  if (homeBanners.value.length > 1) {
    bannerInterval = setInterval(nextBanner, 5000)
  }
}

const stopBannerTimer = () => {
  if (bannerInterval) {
    clearInterval(bannerInterval)
    bannerInterval = null
  }
}

const setBanner = (index) => {
  activeBannerIndex.value = index
  startBannerTimer()
}

const fetchData = async () => {
  isLoading.value = true
  try {
    const [prodRes, bannerRes] = await Promise.all([
      productApi.publicSearch({ featured: true, size: 6 }),
      bannerApi.getPublic('CENTER')
    ])
    featuredProducts.value = resolveProducts(prodRes.data)
    homeBanners.value = bannerRes.data || []
    startBannerTimer()
  } catch (error) {
    console.error('Error fetching home data:', error)
  } finally {
    isLoading.value = false
  }
}

onMounted(fetchData)
onUnmounted(stopBannerTimer)
</script>

<template>
  <div class="home">
    <!-- Hero Section -->
    <section :class="['hero', homeBanners.length > 0 ? 'has-banner' : '']">
      <template v-if="homeBanners.length > 0">
        <div
          v-for="(banner, index) in homeBanners"
          :key="banner.id"
          v-show="activeBannerIndex === index"
          class="hero-bg animate-fade-in"
        >
          <img :src="banner.imageUrl" :alt="banner.title" loading="lazy" />
          <div class="hero-overlay"></div>
        </div>
        <!-- Simple Dots if multiple banners -->
        <div v-if="homeBanners.length > 1" class="hero-dots">
            <span v-for="(_, i) in homeBanners" :key="i" :class="['dot', activeBannerIndex === i ? 'active' : '']" @click="setBanner(i)"></span>
        </div>
      </template>
      <template v-else>
        <div class="hero-bg">
          <img src="https://images.unsplash.com/photo-1541819361361-b5413156942a?q=80&w=2000" alt="Thang máy gia đình Misel đẳng cấp Châu Âu" loading="lazy" />
          <div class="hero-overlay"></div>
        </div>
        </template>
      <div :class="['hero-copy', homeBanners.length > 0 ? 'has-banner-copy' : '']">
        <div :class="['container hero-content animate-fade-in', homeBanners.length > 0 ? 'has-banner-content' : '']">
          <h1 v-if="homeBanners.length > 0" class="hero-title">
            {{ homeBanners[activeBannerIndex]?.title || 'Kiến Tạo Không Gian Nâng Tầm Cuộc Sống' }}
          </h1>
          <h1 v-else class="hero-title">
            Kiến Tạo Không Gian <span class="text-gradient">Nâng Tầm Cuộc Sống</span>
          </h1>
          <p v-if="homeBanners.length === 0" class="hero-subtitle">
            Misel - Đơn vị hàng đầu cung cấp giải pháp thang máy cao cấp cho gia đình, biệt thự và các công trình dân dụng tại Việt Nam.
          </p>
          <div class="hero-btns">
            <router-link :to="homeBanners.length > 0 ? (homeBanners[activeBannerIndex]?.linkUrl || '/products') : '/products'" class="btn btn-primary">Khám phá ngay</router-link>
            <router-link to="/contact" class="btn btn-outline">Nhận tư vấn</router-link>
          </div>
        </div>
      </div>
    </section>

    <!-- Partners/Intro Section -->
    <section class="section-padding intro">
      <div class="container flex-row gap-4">
        <div class="intro-image">
          <img src="https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=2000" alt="Dự án lắp đặt Thang máy kính tại biệt thự cao cấp" loading="lazy" />
        </div>
        <div class="intro-text">
          <h4 class="label">VỀ CHÚNG TÔI</h4>
          <h2>Giải pháp chuyển động <br/><span class="text-gradient">An toàn & Đẳng cấp</span></h2>
          <p>Tại Misel, chúng tôi không chỉ cung cấp một phương tiện di chuyển, mà còn mang đến trải nghiệm nghệ thuật không gian. Mỗi chiếc thang máy là một tác phẩm được thiết kế tỉ mỉ, kết hợp công nghệ hiện đại nhất của Châu Âu with sự tinh tế trong từng đường nét nội thất.</p>
          <div class="stats-grid">
            <div class="stat-item">
              <span class="stat-num">10+</span>
              <span class="stat-label">Năm kinh nghiệm</span>
            </div>
            <div class="stat-item">
              <span class="stat-num">500+</span>
              <span class="stat-label">Dự án hoàn thành</span>
            </div>
            <div class="stat-item">
              <span class="stat-num">24/7</span>
              <span class="stat-label">Hỗ trợ kỹ thuật</span>
            </div>
          </div>
          <router-link to="/about" class="btn btn-primary mt-4">Xem chi tiết <ArrowRight :size="16" /></router-link>
        </div>
      </div>
    </section>

    <!-- Services Grid -->
    <section class="section-padding bg-light">
      <div class="container text-center mb-5">
        <h4 class="label">DỊCH VỤ CỦA CHÚNG TÔI</h4>
        <h2>Cam kết chất lượng <span class="text-gradient">vượt thời gian</span></h2>
      </div>
      <div class="container services-grid">
        <div v-for="service in services" :key="service.title" class="service-card">
          <div class="icon-box">
            <component :is="service.icon" :size="32" />
          </div>
          <h3>{{ service.title }}</h3>
          <p>{{ service.desc }}</p>
        </div>
      </div>
    </section>

    <!-- Featured Products -->
    <section class="section-padding products">
      <div class="container text-center mb-5">
        <h4 class="label">SẢN PHẨM NỔI BẬT</h4>
        <h2>Thang máy <span class="text-gradient">dẫn đầu xu hướng</span></h2>
      </div>
      <div class="container">
        <div v-if="isLoading" class="flex-center py-5">
          <Loader2 class="spinner text-primary" :size="48" />
        </div>
        <div v-else class="grid-3">
          <div v-for="product in featuredProducts" :key="product.id" class="product-card">
            <div class="product-img">
              <img :src="resolveImageUrl(product)" :alt="product.name || 'Sản phẩm nổi bật'" />
            </div>
            <div class="product-info">
              <h3>{{ product.name || 'Chưa có tiêu đề' }}</h3>
              <p class="truncate-2">{{ product.summary || product.desc || 'Chưa có mô tả ngắn.' }}</p>
              <router-link :to="'/products/' + product.id" class="link-more">Xem chi tiết <ArrowRight :size="14" /></router-link>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="section-padding cta">
      <div class="container cta-box glass">
        <div class="cta-content">
          <h2>Bạn đang cần tư vấn cho <br/> công trình của mình?</h2>
          <p>Hãy để chuyên gia của chúng tôi hỗ trợ bạn tìm ra giải pháp thang máy phù hợp nhất về cả thẩm mỹ và ngân sách.</p>
        </div>
        <router-link to="/contact" class="btn btn-primary lg">Liên hệ tư vấn ngay</router-link>
      </div>
    </section>
  </div>
</template>

<style scoped>
.hero {
  min-height: max(100vh, 860px);
  position: relative;
  color: white;
  overflow: hidden;
}

.hero-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: min(78vh, 760px);
  z-index: 0;
}

.hero-bg img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.hero-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(to bottom, rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.4));
}

.hero-content {
  max-width: 800px;
  position: relative;
  z-index: 1;
}

.hero-copy {
  position: absolute;
  left: 50%;
  bottom: clamp(1.5rem, 4vw, 3.5rem);
  transform: translateX(-50%);
  width: min(760px, calc(100% - 2rem));
  z-index: 1;
  padding: 1.25rem 1.5rem 1.5rem;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
  color: var(--text-main);
}

.hero.has-banner .hero-copy {
  width: min(780px, calc(100% - 3rem));
  padding: 1.5rem 1.75rem 1.75rem;
  background: linear-gradient(135deg, rgba(7, 44, 89, 0.84), rgba(7, 44, 89, 0.62));
  border: 1px solid rgba(255, 255, 255, 0.18);
  backdrop-filter: blur(12px);
  box-shadow: 0 26px 70px rgba(5, 19, 38, 0.26);
  color: white;
  animation: heroFloat 5s ease-in-out infinite;
}

.hero.has-banner .hero-content {
  max-width: 100%;
}

.hero.has-banner .hero-title {
  display: block;
  color: white;
  text-shadow: 0 6px 22px rgba(0, 0, 0, 0.25);
  margin-bottom: 0;
}

.hero-title {
  font-size: 2.4rem;
  line-height: 1.1;
  margin-bottom: 0.9rem;
  color: var(--secondary);
}

.hero-subtitle {
  font-size: 1rem;
  margin-bottom: 1rem;
  opacity: 0.92;
  color: var(--text-light);
}

.hero-btns {
  display: flex;
  gap: 0.9rem;
  justify-content: center;
}

.hero-dots {
  position: absolute;
  bottom: 2rem;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 1rem;
  z-index: 2;
}

.hero-dots .dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: rgba(255,255,255,0.3);
  cursor: pointer;
  transition: 0.3s;
}

.hero-dots .dot.active {
  background: var(--primary);
  transform: scale(1.3);
}

.has-banner-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1.5rem;
}

.hero.has-banner .hero-btns {
  flex-shrink: 0;
}

.animate-fade-in {
  animation: fadeIn 0.8s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes heroFloat {
  0%, 100% { transform: translateX(-50%) translateY(0); }
  50% { transform: translateX(-50%) translateY(-10px); }
}

/* Intro Section */
.flex-row {
  display: flex;
  align-items: center;
  gap: 4rem;
}

.intro-image {
  flex: 1;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: var(--shadow);
}

.intro-image img {
  width: 100%;
  transition: transform 0.5s;
}

.intro-image:hover img {
  transform: scale(1.05);
}

.intro-text {
  flex: 1;
}

.label {
  color: var(--primary);
  letter-spacing: 2px;
  margin-bottom: 1rem;
  font-weight: 700;
}

.intro-text h2 {
  font-size: 2.5rem;
  margin-bottom: 2rem;
}

.intro-text p {
  color: var(--text-light);
  margin-bottom: 2rem;
}

.stats-grid {
  display: flex;
  gap: 3rem;
  margin: 2rem 0;
}

.stat-num {
  font-size: 2.5rem;
  font-weight: 800;
  color: var(--secondary);
  display: block;
}

.stat-label {
  font-size: 0.9rem;
  color: var(--text-light);
  text-transform: uppercase;
}

/* Service Card */
.bg-light {
  background: #f8f9fa;
}





.icon-box {
  width: 80px;
  height: 80px;
  background: #fdfaf3;
  color: var(--primary);
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  margin: 0 auto 1.5rem;
  transition: var(--transition);
}

.service-card:hover .icon-box {
  background: var(--primary);
  color: white;
  transform: scale(1.1);
}

.service-card h3 {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--secondary);
  margin-bottom: 1rem;
}

.service-card p {
  color: var(--text-light);
  font-size: 1.05rem;
  line-height: 1.6;
}

/* Services Grid Redesign */
.services-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 2.5rem;
  max-width: 1000px;
  margin: 0 auto;
}

.service-card {
  padding: 3.5rem 2.5rem;
  text-align: center;
  border-radius: 16px;
  background: white !important;
  transition: var(--transition);
  border: 1px solid rgba(0, 0, 0, 0.05);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.service-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 40px rgba(193, 160, 82, 0.12);
  border-color: var(--primary);
}

@media (max-width: 768px) {
  .services-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  
  .service-card {
    padding: 2.5rem 1.5rem;
  }
}

/* Product Card */
.product-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 5px 20px rgba(0,0,0,0.05);
  transition: var(--transition);
  height: 100%;
  display: flex;
  flex-direction: column;
}

.product-card:hover {
  transform: scale(1.02);
  box-shadow: 0 15px 40px rgba(0,0,0,0.1);
}

.product-img {
  height: 250px;
  overflow: hidden;
}

.product-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.8s;
}

.product-card:hover .product-img img {
  transform: scale(1.1);
}

.product-info {
  padding: 2rem;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.product-info h3 {
  margin-bottom: 0.5rem;
}

.product-info p {
  color: var(--text-light);
  margin-bottom: 1.5rem;
}

.truncate-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.link-more {
  color: var(--primary);
  font-weight: 700;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: auto;
}

/* CTA Section */
.cta-box {
  background: var(--secondary) !important;
  color: white;
  padding: 60px;
  border-radius: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.cta-content h2 {
  color: white;
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.cta-content p {
  opacity: 0.8;
  font-size: 1.1rem;
}

.btn.lg {
  padding: 1.2rem 3rem;
  font-size: 1.1rem;
}

.flex-center {
  display: flex;
  justify-content: center;
  align-items: center;
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@media (max-width: 992px) {
  .hero {
    min-height: 780px;
  }

  .hero-title {
    font-size: 2.5rem;
  }

  .hero.has-banner .hero-copy {
    width: min(720px, calc(100% - 2rem));
  }

  .has-banner-content {
    flex-direction: column;
    align-items: flex-start;
  }

  .hero.has-banner .hero-btns {
    width: 100%;
    justify-content: flex-start;
  }

  .flex-row {
    flex-direction: column;
    gap: 3rem;
  }
  .cta-box {
    flex-direction: column;
    text-align: center;
    gap: 2rem;
    padding: 30px;
  }
  .cta-content h2 {
    font-size: 1.8rem;
  }
}

@media (max-width: 768px) {
  .hero {
    height: auto;
    min-height: auto;
    padding-top: 60vh;
  }

  .hero-bg img {
    object-position: center top;
  }

  .hero-bg {
    height: 60vh;
  }

  .hero-copy {
    position: relative;
    left: auto;
    bottom: auto;
    transform: none;
    width: calc(100% - 1rem);
    margin: -1.5rem auto 0;
    padding: 1rem;
    border-radius: 16px;
  }

  .hero.has-banner .hero-copy {
    animation: none;
    padding: 1rem;
  }

  .hero-content {
    padding-top: 0;
  }

  .has-banner-content {
    gap: 1rem;
  }

  .hero-title {
    font-size: 1.6rem;
    margin-bottom: 1rem;
  }

  .hero-subtitle {
    font-size: 0.92rem;
    margin-bottom: 0.9rem;
  }

  .hero-btns {
    flex-direction: column;
    gap: 0.6rem;
  }

  .hero-btns .btn {
    width: 100%;
    text-align: center;
  }

  .hero-dots {
    position: relative;
    top: auto;
    bottom: auto;
    margin-top: 0.75rem;
  }

  .intro {
    padding-top: 72px;
  }

  .intro-image img {
    border-radius: 14px;
  }

  .intro-text h2 {
    font-size: 1.8rem;
  }

  .stats-grid {
    grid-template-columns: 1fr;
    gap: 0.75rem;
  }

  .service-card {
    padding: 1.5rem;
    text-align: center;
  }

  .product-card {
    max-width: 100%;
  }

  .cta-box {
    padding: 20px;
  }

  .cta-content h2 {
    font-size: 1.5rem;
  }
}

@media (max-width: 480px) {
  .hero {
    padding-top: 54vh;
  }

  .hero-bg {
    height: 54vh;
  }

  .hero-copy {
    width: calc(100% - 0.75rem);
    margin-top: -1.25rem;
    padding: 0.85rem;
    border-radius: 14px;
  }

  .hero-title {
    font-size: 1.45rem;
  }

  .hero-subtitle {
    font-size: 0.86rem;
  }

  .hero-dots {
    top: calc(52vh - 2rem);
  }

  .intro-text h2,
  .cta-content h2 {
    font-size: 1.4rem;
  }

  .section-padding {
    padding-top: 56px;
    padding-bottom: 56px;
  }
}
</style>
