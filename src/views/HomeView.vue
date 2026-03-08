<script setup>
import { ArrowRight, Settings, ShieldCheck, Headphones, Zap } from 'lucide-vue-next'

const featuredProducts = [
  { id: 1, name: 'Thang máy gia đình', image: '/images/3653228387362596575.jpg', desc: 'Thiết kế sang trọng, tối ưu không gian.' },
  { id: 2, name: 'Thang máy biệt thự', image: '/images/3726039324607881804 (1).jpg', desc: 'Đẳng cấp vượt trội cho ngôi nhà của bạn.' },
  { id: 3, name: 'Thang máy kinh doanh', image: '/images/56463040787009741.jpg', desc: 'Hiệu suất cao, bền bỉ theo thời gian.' }
]

const services = [
  { title: 'Tư vấn - Thiết kế', icon: Settings, desc: 'Giải pháp tối ưu theo thực trạng công trình.' },
  { title: 'Lắp đặt chuyên nghiệp', icon: Zap, desc: 'Đội ngũ kỹ thuật tay nghề cao, đúng tiến độ.' },
  { title: 'Bảo trì trọn đời', icon: ShieldCheck, desc: 'An tâm sử dụng với dịch vụ bảo trì 24/7.' },
  { title: 'Hỗ trợ kỹ thuật', icon: Headphones, desc: 'Luôn sẵn sàng giải đáp mọi thắc mắc của khách hàng.' }
]
</script>

<template>
  <div class="home">
    <!-- Hero Section -->
    <section class="hero">
      <div class="hero-bg">
        <img src="/images/56bde9f9ba11344f6d00.jpg" alt="Hero Background" />
        <div class="hero-overlay"></div>
      </div>
      <div class="container hero-content animate-fade-in">
        <h1 class="hero-title">Kiến Tạo Không Gian <span class="text-gradient">Nâng Tầm Cuộc Sống</span></h1>
        <p class="hero-subtitle">BaoThangMay - Đơn vị hàng đầu cung cấp giải pháp thang máy cao cấp cho gia đình, biệt thự và các công trình dân dụng tại Việt Nam.</p>
        <div class="hero-btns">
          <router-link to="/products" class="btn btn-primary">Khám phá sản phẩm</router-link>
          <router-link to="/contact" class="btn btn-outline">Nhận tư vấn ngay</router-link>
        </div>
      </div>
    </section>

    <!-- Partners/Intro Section -->
    <section class="section-padding intro">
      <div class="container flex-row gap-4">
        <div class="intro-image">
          <img src="/images/d0ca929ac1724f2c1663.jpg" alt="BaoThangMay Office" />
        </div>
        <div class="intro-text">
          <h4 class="label">VỀ CHÚNG TÔI</h4>
          <h2>Giải pháp chuyển động <br/><span class="text-gradient">An toàn & Đẳng cấp</span></h2>
          <p>Tại BaoThangMay, chúng tôi không chỉ cung cấp một phương tiện di chuyển, mà còn mang đến trải nghiệm nghệ thuật không gian. Mỗi chiếc thang máy là một tác phẩm được thiết kế tỉ mỉ, kết hợp công nghệ hiện đại nhất của Châu Âu with sự tinh tế trong từng đường nét nội thất.</p>
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
      <div class="container grid-3">
        <div v-for="service in services" :key="service.title" class="service-card glass">
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
      <div class="container grid-3">
        <div v-for="product in featuredProducts" :key="product.id" class="product-card">
          <div class="product-img">
            <img :src="product.image" :alt="product.name" />
          </div>
          <div class="product-info">
            <h3>{{ product.name }}</h3>
            <p>{{ product.desc }}</p>
            <router-link :to="'/products/' + product.id" class="link-more">Xem chi tiết <ArrowRight :size="14" /></router-link>
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
  height: 100vh;
  display: flex;
  align-items: center;
  position: relative;
  color: white;
}

.hero-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -1;
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
}

.hero-title {
  font-size: 4rem;
  line-height: 1.1;
  margin-bottom: 2rem;
  color: white;
}

.hero-subtitle {
  font-size: 1.25rem;
  margin-bottom: 3rem;
  opacity: 0.9;
}

.hero-btns {
  display: flex;
  gap: 1.5rem;
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

.service-card {
  padding: 3rem 2rem;
  text-align: center;
  border-radius: 8px;
  background: white !important;
  transition: var(--transition);
}

.service-card:hover {
  transform: translateY(-10px);
  box-shadow: var(--shadow);
}

.icon-box {
  width: 70px;
  height: 70px;
  background: rgba(193, 160, 82, 0.1);
  color: var(--primary);
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  margin: 0 auto 2rem;
}

.service-card h3 {
  margin-bottom: 1rem;
}

/* Product Card */
.product-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 5px 20px rgba(0,0,0,0.05);
  transition: var(--transition);
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
}

.product-info h3 {
  margin-bottom: 0.5rem;
}

.product-info p {
  color: var(--text-light);
  margin-bottom: 1.5rem;
}

.link-more {
  color: var(--primary);
  font-weight: 700;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
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

@media (max-width: 992px) {
  .hero-title {
    font-size: 2.5rem;
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
</style>
