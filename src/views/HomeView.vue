<script setup>
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { ArrowRight, Headphones, Loader2, Settings, ShieldCheck, Zap } from 'lucide-vue-next'
import productApi from '@/api/productApi'
import bannerApi from '@/api/bannerApi'

const isLoading = ref(true)
const featuredProducts = ref([])
const homeBanners = ref([])
const activeBannerIndex = ref(0)
let bannerInterval = null
const bannerDelay = 3500
const featuredLimit = 8

const resolveProducts = (payload) => payload?.content || payload?.items || payload || []
const resolveImageUrl = (product) => product?.thumbnail?.publicUrl || product?.thumbnail?.url || product?.images?.[0] || 'https://images.unsplash.com/photo-1621343110547-0d64f219c27c?q=80&w=1200'
const activeHeroImage = () => homeBanners.value[activeBannerIndex.value]?.imageUrl || 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?q=80&w=2200'
const displayedFeaturedProducts = computed(() => featuredProducts.value.slice(0, featuredLimit))
const hasMoreFeaturedProducts = computed(() => featuredProducts.value.length > featuredLimit)

const services = [
  { title: 'Tư vấn - Thiết kế', icon: Settings, desc: 'Giải pháp tối ưu theo thực trạng công trình và định hướng thẩm mỹ của chủ đầu tư.' },
  { title: 'Lắp đặt chuyên nghiệp', icon: Zap, desc: 'Đội ngũ kỹ thuật tay nghề cao, kiểm soát tiến độ và tiêu chuẩn an toàn.' },
  { title: 'Bảo trì trọn đời', icon: ShieldCheck, desc: 'An tâm sử dụng với lịch bảo trì định kỳ và quy trình kiểm tra nghiêm ngặt.' },
  { title: 'Hỗ trợ kỹ thuật', icon: Headphones, desc: 'Luôn sẵn sàng giải đáp mọi thắc mắc và xử lý nhu cầu vận hành.' }
]

const nextBanner = () => {
  if (homeBanners.value.length <= 1) return
  activeBannerIndex.value = (activeBannerIndex.value + 1) % homeBanners.value.length
}

const startBannerTimer = () => {
  stopBannerTimer()
  if (homeBanners.value.length > 1) {
    bannerInterval = setInterval(nextBanner, bannerDelay)
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
      productApi.publicSearch({ featured: true, size: featuredLimit + 1 }),
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
  <div class="home-page">
    <section class="home-hero">
      <div
        v-for="(banner, index) in homeBanners"
        v-show="activeBannerIndex === index"
        :key="banner.id"
        class="hero-media"
      >
        <img :src="banner.imageUrl" :alt="banner.title || 'Misel elevator interior'" />
      </div>
      <div v-if="homeBanners.length === 0" class="hero-media">
        <img :src="activeHeroImage()" alt="Misel elevator interior" />
      </div>
      <div class="hero-shade"></div>

      <div class="hero-panel animate-fade-in">
        <h1>Tuyệt tác kiến trúc <span>trong tầm tay</span></h1>
        <div class="hero-actions">
          <router-link to="/products" class="btn btn-primary">Khám phá ngay</router-link>
          <router-link to="/contact" class="btn hero-outline">Nhận tư vấn</router-link>
        </div>
      </div>

      <div v-if="homeBanners.length > 1" class="hero-dots">
        <button
          v-for="(_, index) in homeBanners"
          :key="index"
          :class="{ active: activeBannerIndex === index }"
          type="button"
          :aria-label="`Chuyển banner ${index + 1}`"
          @click="setBanner(index)"
        ></button>
      </div>
    </section>

    <section class="intro-section section-padding">
      <div class="container intro-layout">
        <div class="intro-photo">
          <img src="/images/3653228387362596575.jpg" alt="Thang máy nội thất cao cấp Misel" />
        </div>

        <div class="intro-copy">
          <p class="eyebrow">Về chúng tôi</p>
          <h2>Giải pháp chuyển động <span>An toàn & Đẳng cấp</span></h2>
          <p>
            Tại Misel, chúng tôi không chỉ cung cấp một phương tiện di chuyển, mà còn mang đến trải nghiệm nghệ thuật không gian.
            Mỗi chiếc thang máy là một tác phẩm được thiết kế tỉ mỉ, kết hợp công nghệ hiện đại với sự tinh tế trong từng đường nét nội thất.
          </p>

          <div class="stats-row">
            <div>
              <strong>10+</strong>
              <span>Năm kinh nghiệm</span>
            </div>
            <div>
              <strong>500+</strong>
              <span>Dự án hoàn thành</span>
            </div>
            <div>
              <strong>24/7</strong>
              <span>Hỗ trợ kỹ thuật</span>
            </div>
          </div>

          <router-link to="/products" class="btn btn-dark">Xem chi tiết <ArrowRight :size="16" /></router-link>
        </div>
      </div>
    </section>

    <section class="services-section section-padding">
      <div class="container section-heading">
        <p class="eyebrow">Dịch vụ của chúng tôi</p>
        <h2>Cam kết chất lượng vượt <span>thời gian</span></h2>
      </div>

      <div class="container services-grid">
        <article v-for="service in services" :key="service.title" class="service-card">
          <div class="service-icon">
            <component :is="service.icon" :size="24" />
          </div>
          <h3>{{ service.title }}</h3>
          <p>{{ service.desc }}</p>
        </article>
      </div>
    </section>

    <section class="products-section section-padding">
      <div class="container section-heading">
        <p class="eyebrow">Sản phẩm nổi bật</p>
        <h2>Thang máy dẫn đầu xu hướng</h2>
      </div>

      <div class="container">
        <div v-if="isLoading" class="loading-box">
          <Loader2 class="spinner" :size="44" />
        </div>
        <div v-else class="product-grid">
          <article v-for="product in displayedFeaturedProducts" :key="product.id" class="product-card">
            <router-link :to="'/products/' + product.id" class="product-image" aria-label="Xem chi tiết sản phẩm">
              <img :src="resolveImageUrl(product)" :alt="product.name || 'Sản phẩm thang máy Misel'" />
            </router-link>
            <div class="product-info">
              <p>{{ product.category?.name || 'Misel elevator' }}</p>
              <h3>{{ product.name || 'Sản phẩm thang máy cao cấp' }}</h3>
              <span>{{ product.summary || 'Dòng thang máy tinh gọn, vận hành êm ái và phù hợp nhiều không gian.' }}</span>
              <router-link :to="'/products/' + product.id">
                Xem chi tiết <ArrowRight :size="14" />
              </router-link>
            </div>
          </article>
        </div>
        <div v-if="!isLoading && hasMoreFeaturedProducts" class="products-more">
          <router-link to="/products" class="btn btn-dark">
            Xem thêm <ArrowRight :size="16" />
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.home-page {
  background: #fff;
}

.home-hero {
  position: relative;
  min-height: clamp(500px, 66vh, 680px);
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding-top: clamp(210px, 23vh, 255px);
  overflow: hidden;
  color: #fff;
}

.hero-media,
.hero-shade {
  position: absolute;
  inset: 0;
}

.hero-media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.hero-shade {
  background:
    linear-gradient(90deg, rgba(2, 21, 43, 0.78), rgba(2, 21, 43, 0.24), rgba(2, 21, 43, 0.78)),
    linear-gradient(180deg, rgba(0, 0, 0, 0.08), rgba(0, 45, 94, 0.56));
  z-index: 1;
}

.hero-panel {
  position: relative;
  z-index: 2;
  width: min(520px, calc(100% - 2rem));
  padding: clamp(0.95rem, 1.45vw, 1.25rem) clamp(1.25rem, 2vw, 1.75rem);
  text-align: center;
  background: rgba(4, 22, 44, 0.62);
  border: 1px solid rgba(255, 255, 255, 0.14);
  box-shadow: 0 26px 80px rgba(1, 13, 28, 0.36);
  backdrop-filter: blur(6px);
  animation: heroPanelFloat 3.2s ease-in-out infinite;
}

.hero-panel h1 {
  color: #fff;
  font-size: clamp(1.55rem, 2.35vw, 2.35rem);
  font-weight: 700;
  line-height: 1.08;
  margin-bottom: 0.85rem;
}

.hero-panel h1 span {
  display: block;
  color: var(--primary);
  font-style: normal;
}

.hero-actions {
  display: flex;
  justify-content: center;
  gap: 0.65rem;
}

.hero-actions .btn {
  min-width: 106px;
  padding: 0.52rem 0.9rem;
  border-radius: 0;
  text-transform: uppercase;
  font-size: 0.58rem;
  letter-spacing: 0.04em;
}

.hero-outline {
  color: #fff;
  border: 1px solid rgba(255, 255, 255, 0.8);
  background: rgba(0, 0, 0, 0.16);
}

.hero-outline:hover {
  border-color: var(--primary);
  color: var(--primary);
}

.hero-dots {
  position: absolute;
  left: 50%;
  bottom: 24px;
  z-index: 3;
  display: flex;
  gap: 10px;
  transform: translateX(-50%);
}

.hero-dots button {
  width: 9px;
  height: 9px;
  border: 0;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.45);
  cursor: pointer;
}

.hero-dots button.active {
  width: 28px;
  background: var(--primary);
}

@keyframes heroPanelFloat {
  0%, 100% {
    transform: translateY(0) scale(1);
    box-shadow: 0 24px 72px rgba(1, 13, 28, 0.34);
    border-color: rgba(255, 255, 255, 0.14);
  }
  50% {
    transform: translateY(-18px) scale(1.025);
    box-shadow: 0 38px 105px rgba(1, 13, 28, 0.52);
    border-color: rgba(193, 160, 82, 0.46);
  }
}

.intro-section {
  background: #fff;
}

.intro-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: clamp(3rem, 7vw, 7rem);
  align-items: center;
}

.intro-photo {
  position: relative;
  padding: 1rem;
  background: #fff;
  box-shadow: 0 24px 70px rgba(18, 32, 54, 0.12);
}

.intro-photo::before,
.intro-photo::after {
  content: '';
  position: absolute;
  z-index: -1;
  border: 8px solid rgba(193, 160, 82, 0.18);
}

.intro-photo::before {
  inset: -24px 42px 42px -24px;
}

.intro-photo::after {
  right: -28px;
  bottom: -28px;
  width: 38%;
  height: 34%;
}

.intro-photo img {
  display: block;
  width: 100%;
  aspect-ratio: 1 / 0.86;
  object-fit: cover;
}

.eyebrow {
  margin-bottom: 1rem;
  color: var(--primary);
  font-size: 0.78rem;
  font-weight: 700;
  letter-spacing: 0.22em;
  text-transform: uppercase;
}

.intro-copy h2,
.section-heading h2 {
  font-size: clamp(2.35rem, 4vw, 4rem);
  font-weight: 700;
  line-height: 1.16;
  margin-bottom: 1.5rem;
}

.intro-copy h2 span,
.section-heading h2 span {
  display: block;
  color: var(--primary);
  font-style: normal;
}

.intro-copy > p {
  max-width: 650px;
  color: var(--text-light);
  font-size: 1rem;
}

.stats-row {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
  margin: 2.25rem 0;
  border-top: 1px solid rgba(193, 160, 82, 0.36);
  border-bottom: 1px solid rgba(193, 160, 82, 0.36);
}

.stats-row div {
  padding: 1.25rem 1rem;
  border-right: 1px solid rgba(193, 160, 82, 0.36);
}

.stats-row div:last-child {
  border-right: 0;
}

.stats-row strong {
  display: block;
  color: var(--secondary);
  font-size: clamp(2rem, 3.6vw, 3.25rem);
  line-height: 1;
}

.stats-row span {
  display: block;
  margin-top: 0.6rem;
  color: var(--text-light);
  font-size: 0.75rem;
  text-transform: uppercase;
}

.btn-dark {
  background: #061a38;
  color: #fff;
  border-radius: 0;
  text-transform: uppercase;
  font-size: 0.78rem;
  letter-spacing: 0.04em;
}

.services-section {
  color: #fff;
  background:
    radial-gradient(circle at 78% 24%, rgba(193, 160, 82, 0.14), transparent 30%),
    linear-gradient(135deg, #071d3b, #06172f);
}

.section-heading {
  text-align: center;
}

.services-section .section-heading h2 {
  color: #fff;
}

.services-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 2rem;
  margin-top: 3rem;
}

.service-card {
  min-height: 250px;
  padding: 2.25rem 1.75rem;
  text-align: center;
  color: #0d2446;
  background: #fff;
  border: 1px solid rgba(255, 255, 255, 0.16);
  transition: transform 0.28s ease, box-shadow 0.28s ease;
}

.service-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 26px 60px rgba(0, 0, 0, 0.24);
}

.service-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 54px;
  height: 54px;
  margin-bottom: 1.35rem;
  color: var(--primary);
  background: #f7f1e6;
}

.service-card h3 {
  margin-bottom: 0.85rem;
  color: #081d3b;
  font-size: 1.2rem;
}

.service-card p {
  color: #67717c;
  font-size: 0.92rem;
}

.products-section {
  background: #f6f7f9;
}

.products-section .section-heading h2 {
  color: #101827;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 1.25rem;
  margin-top: 2.75rem;
}

.product-card {
  overflow: hidden;
  background: #fff;
  transition: transform 0.28s ease, box-shadow 0.28s ease;
}

.product-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 24px 60px rgba(16, 24, 39, 0.12);
}

.product-image {
  display: block;
  overflow: hidden;
  color: inherit;
  cursor: pointer;
}

.product-image img {
  display: block;
  width: 100%;
  aspect-ratio: 1.35 / 1;
  object-fit: cover;
  transition: transform 0.7s ease;
}

.product-card:hover .product-image img {
  transform: scale(1.06);
}

.product-info {
  padding: 1.15rem 1.15rem 1.25rem;
}

.product-info p {
  margin-bottom: 0.5rem;
  color: var(--primary);
  font-size: 0.72rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.product-info h3 {
  margin-bottom: 0.6rem;
  color: #141b27;
  font-size: 1.02rem;
  line-height: 1.28;
}

.product-info span {
  display: -webkit-box;
  min-height: 3.4em;
  margin-bottom: 1.25rem;
  overflow: hidden;
  color: var(--text-light);
  font-size: 0.84rem;
  line-height: 1.55;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  line-clamp: 2;
}

.products-more {
  display: flex;
  justify-content: center;
  margin-top: 2.25rem;
}

.product-info a {
  display: inline-flex;
  align-items: center;
  gap: 0.45rem;
  color: var(--primary);
  font-size: 0.78rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.loading-box {
  display: flex;
  justify-content: center;
  padding: 4rem 0;
  color: var(--primary);
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@media (max-width: 1100px) {
  .services-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .product-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 900px) {
  .intro-layout {
    grid-template-columns: 1fr;
  }

  .intro-photo {
    max-width: 680px;
    margin: 0 auto;
  }
}

@media (max-width: 560px) {
  .product-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .home-hero {
    min-height: 560px;
    align-items: flex-start;
    padding: 230px 1rem 0;
  }

  .hero-panel {
    width: min(500px, calc(100% - 1.5rem));
    padding: 1rem;
    animation-duration: 5.4s;
  }

  .hero-actions {
    grid-template-columns: 1fr;
    flex-direction: column;
  }

  .hero-actions {
    display: flex;
  }

  .stats-row {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 0;
  }

  .stats-row div,
  .stats-row div:last-child {
    border-right: 1px solid rgba(193, 160, 82, 0.36);
    border-bottom: 0;
  }

  .stats-row div:last-child {
    border-right: 0;
  }

  .stats-row div {
    padding: 1rem 0.65rem;
  }

  .stats-row strong {
    font-size: 2rem;
  }

  .stats-row span {
    font-size: 0.62rem;
    line-height: 1.35;
  }

  .services-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1rem;
  }

  .service-card {
    min-height: 210px;
    padding: 1.35rem 0.9rem;
  }

  .service-icon {
    width: 46px;
    height: 46px;
    margin-bottom: 1rem;
  }

  .service-card h3 {
    font-size: 0.95rem;
    line-height: 1.25;
  }

  .service-card p {
    font-size: 0.76rem;
    line-height: 1.55;
  }
}

@media (max-width: 480px) {
  .home-hero {
    min-height: 560px;
  }

  .hero-panel h1 {
    font-size: 1.45rem;
  }

  .intro-photo {
    padding: 0.65rem;
  }
}
</style>
