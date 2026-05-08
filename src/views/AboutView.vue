<script setup>
import { CheckCircle, History, Target, Users } from 'lucide-vue-next'

const values = [
  { title: 'Tận tâm', desc: 'Luôn lắng nghe và thấu hiểu nhu cầu của khách hàng để mang đến giải pháp tốt nhất.' },
  { title: 'Sáng tạo', desc: 'Không ngừng đổi mới công nghệ và thiết kế để dẫn đầu xu hướng thị trường.' },
  { title: 'Chất lượng', desc: 'Cam kết mỗi sản phẩm đều đạt tiêu chuẩn an toàn khắt khe nhất của quốc tế.' }
]
</script>

<template>
  <div class="about">
    <section class="subpage-hero">
      <div class="hero-bg">
        <img src="https://images.unsplash.com/photo-1541819361361-b5413156942a?q=80&w=2000" alt="About Hero" />
        <div class="hero-overlay"></div>
      </div>
      <div class="container hero-content text-center">
        <h1 class="reveal-pop">Về Chúng Tôi</h1>
        <p class="reveal-up delay-1">Hơn một thập kỷ nâng tầm không gian sống Việt.</p>
      </div>
    </section>

    <section class="about-intro section-padding container">
      <div class="intro-grid">
        <div class="intro-text">
          <h4 class="label reveal-left delay-1">CÂU CHUYỆN THƯƠNG HIỆU</h4>
          <h2 class="reveal-left delay-2">Misel – Sự kết hợp hoàn hảo giữa <br/><span class="text-gradient">Công nghệ & Nghệ thuật</span></h2>
          <p class="reveal-left delay-3">Được thành lập với khát vọng mang đến những giải pháp di chuyển an toàn, sang trọng và hiện đại cho các công trình Việt, Misel đã không ngừng nỗ lực để trở thành đối tác tin cậy của hàng nghìn khách hàng trên khắp cả nước.</p>
          <p class="reveal-left delay-4">Chúng tôi hiểu rằng, mỗi chiếc thang máy không chỉ là một thiết bị kỹ thuật, mà còn là trái tim của ngôi nhà, là nơi kết nối các thành viên và thể hiện đẳng cấp của gia chủ. Vì vậy, mỗi sản phẩm của Misel đều được cá nhân hóa tối đa theo phong cách kiến trúc và sở thích riêng biệt.</p>
          <div class="milestones">
            <div class="milestone reveal-up delay-5">
              <History :size="32" class="milestone-icon" />
              <div>
                <h4>2012</h4>
                <p>Khởi đầu với xưởng cơ khí chính xác tại TP.HCM</p>
              </div>
            </div>
            <div class="milestone reveal-up delay-6">
              <Target :size="32" class="milestone-icon" />
              <div>
                <h4>2018</h4>
                <p>Trở thành đơn vị phân phối chính hãng linh kiện Châu Âu</p>
              </div>
            </div>
            <div class="milestone reveal-up delay-7">
              <Users :size="32" class="milestone-icon" />
              <div>
                <h4>2024</h4>
                <p>Mở rộng mạng lưới bảo trì trên toàn lãnh thổ Việt Nam</p>
              </div>
            </div>
          </div>
        </div>
        <div class="intro-image reveal-right delay-3">
          <img src="/images/d0ca929ac1724f2c1663.jpg" alt="About Misel" />
        </div>
      </div>
    </section>

    <section class="values section-padding">
      <div class="container">
        <div class="text-center mb-5 reveal-up">
          <h4 class="label">GIÁ TRỊ CỐT LÕI</h4>
          <h2>Những gì chúng tôi <span class="text-gradient">luôn theo đuổi</span></h2>
        </div>
        <div class="grid-3">
          <div v-for="(val, index) in values" :key="val.title" class="value-card glass reveal-up" :style="{ animationDelay: `${0.12 + index * 0.12}s` }">
            <div class="value-icon"><CheckCircle :size="40" /></div>
            <h3>{{ val.title }}</h3>
            <p>{{ val.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <section class="section-padding container-narrow">
      <h2 class="text-center mb-5 reveal-up">Tầm nhìn & Sứ mệnh</h2>
      <div class="vision-mission">
        <div class="box mission glass reveal-left delay-1">
          <h3>Sứ mệnh</h3>
          <p>Mang đến cho khách hàng những giải pháp thang máy tiên tiến, giúp việc di chuyển trong các công trình trở nên thuận tiện, an toàn và sang trọng nhất.</p>
        </div>
        <div class="box vision glass reveal-right delay-2">
          <h3>Tầm nhìn</h3>
          <p>Trở thành biểu tượng uy tín hàng đầu Đông Nam Á trong lĩnh vực thang máy nội thất và công trình dân dụng cao cấp.</p>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.subpage-hero {
  height: clamp(180px, 22vh, 260px);
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.subpage-hero .hero-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
}

.about-intro {
  padding-top: 48px;
}

.subpage-hero .hero-content {
  position: relative;
  z-index: 1;
}

.subpage-hero .hero-bg img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.subpage-hero .hero-overlay {
  background: rgba(0, 0, 0, 0.6);
}

.subpage-hero h1 {
  font-size: 3.5rem;
  color: white;
  margin-bottom: 1rem;
}

.reveal-pop,
.reveal-up,
.reveal-left,
.reveal-right {
  opacity: 0;
  animation-duration: 0.85s;
  animation-timing-function: cubic-bezier(0.16, 1, 0.3, 1);
  animation-fill-mode: forwards;
  will-change: transform, opacity, filter;
}

.reveal-pop {
  animation-name: aboutPopIn;
}

.reveal-up {
  animation-name: aboutFlyUp;
}

.reveal-left {
  animation-name: aboutFlyLeft;
}

.reveal-right {
  animation-name: aboutFlyRight;
}

.delay-1 { animation-delay: 0.08s; }
.delay-2 { animation-delay: 0.18s; }
.delay-3 { animation-delay: 0.28s; }
.delay-4 { animation-delay: 0.38s; }
.delay-5 { animation-delay: 0.48s; }
.delay-6 { animation-delay: 0.58s; }
.delay-7 { animation-delay: 0.68s; }

@keyframes aboutPopIn {
  0% {
    opacity: 0;
    filter: blur(8px);
    transform: translateY(34px) scale(0.9);
  }
  65% {
    opacity: 1;
    filter: blur(0);
    transform: translateY(-8px) scale(1.04);
  }
  100% {
    opacity: 1;
    filter: blur(0);
    transform: translateY(0) scale(1);
  }
}

@keyframes aboutFlyUp {
  from {
    opacity: 0;
    filter: blur(6px);
    transform: translateY(56px);
  }
  to {
    opacity: 1;
    filter: blur(0);
    transform: translateY(0);
  }
}

@keyframes aboutFlyLeft {
  from {
    opacity: 0;
    filter: blur(7px);
    transform: translateX(-70px);
  }
  to {
    opacity: 1;
    filter: blur(0);
    transform: translateX(0);
  }
}

@keyframes aboutFlyRight {
  from {
    opacity: 0;
    filter: blur(7px);
    transform: translateX(70px) scale(0.96);
  }
  to {
    opacity: 1;
    filter: blur(0);
    transform: translateX(0) scale(1);
  }
}

.intro-grid {
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: 4rem;
  align-items: center;
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
}

.milestones {
  margin-top: 3rem;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.milestone {
  display: flex;
  gap: 1.5rem;
  align-items: flex-start;
}

.milestone-icon {
  color: var(--primary);
}

.milestone h4 {
  color: var(--secondary);
  font-size: 1.25rem;
  margin-bottom: 0.25rem;
}

.milestone p {
  font-size: 0.95rem;
}

.intro-image img {
  width: 100%;
  border-radius: 12px;
  box-shadow: var(--shadow);
}

.intro-image {
  transform-origin: center;
}

.values {
  background: #fdfdfd;
}

.value-card {
  padding: 3rem 2rem;
  text-align: center;
  border-radius: 12px;
  background: white !important;
  box-shadow: 0 5px 20px rgba(0,0,0,0.03);
  transition: var(--transition);
}

.value-card:hover {
  transform: translateY(-10px);
  box-shadow: var(--shadow);
}

.value-icon {
  color: var(--primary);
  margin-bottom: 1.5rem;
}

.vision-mission {
  display: flex;
  gap: 2rem;
}

.box {
  flex: 1;
  padding: 3rem;
  border-radius: 16px;
  background: white !important;
  border: 1px solid rgba(193, 160, 82, 0.2);
}

.box h3 {
  color: var(--primary);
  margin-bottom: 1.5rem;
  font-size: 1.8rem;
}

@media (max-width: 992px) {
  .intro-grid {
    grid-template-columns: 1fr;
  }
  .vision-mission {
    flex-direction: column;
  }
}

@media (max-width: 768px) {
  .subpage-hero {
    height: 180px;
  }

  .about-intro {
    padding-top: 40px;
  }

  .subpage-hero h1 {
    font-size: 2rem;
  }

  .subpage-hero p {
    font-size: 0.92rem;
  }

  .intro-text h2 {
    font-size: 1.8rem;
  }

  .milestones {
    margin-top: 2rem;
    gap: 1.25rem;
  }

  .milestone {
    gap: 1rem;
  }

  .grid-3 {
    grid-template-columns: 1fr;
  }

  .value-card {
    padding: 1.5rem;
  }

  .box {
    padding: 1.5rem;
  }
}

@media (prefers-reduced-motion: reduce) {
  .reveal-pop,
  .reveal-up,
  .reveal-left,
  .reveal-right {
    opacity: 1;
    animation: none;
    filter: none;
    transform: none;
  }
}
</style>
