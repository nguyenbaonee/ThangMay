<script setup>
import { Settings, Zap, ShieldCheck, Headphones, Construction, RefreshCw, MessageCircle } from 'lucide-vue-next'

const coreServices = [
  { 
    title: 'Tư vấn & Thiết kế', 
    icon: Settings, 
    image: '/images/3726039324607881804 (6).jpg',
    desc: 'Lắng nghe nhu cầu và khảo sát thực tế để mang đến bản thiết kế 3D tối ưu công năng và thẩm mỹ, phù hợp với kiến trúc tổng thể.'
  },
  { 
    title: 'Lắp đặt chuyên nghiệp', 
    icon: Construction, 
    image: '/images/3726039324607881804.jpg',
    desc: 'Quy trình lắp đặt chuẩn ISO, được thực hiện bởi đội ngũ kỹ sư lành nghề, đảm bảo an toàn tuyệt đối và đúng tiến độ cam kết.'
  },
  { 
    title: 'Bảo trì & Bảo dưỡng', 
    icon: ShieldCheck, 
    image: '/images/3653228387362596575 (1).jpg',
    desc: 'Dịch vụ bảo trì định kỳ 1-2 tháng/lần, giúp thang máy luôn vận hành êm ái, kéo dài tuổi thọ linh kiện và phát hiện sớm các rủi ro.'
  },
  { 
    title: 'Sửa chữa & Nâng cấp', 
    icon: RefreshCw, 
    image: '/images/3653228387362596575 (2).jpg',
    desc: 'Khắc phục sự cố nhanh chóng 24/7. Tư vấn nâng cấp nội thất, thay thế linh kiện lỗi thời bằng công nghệ mới nhất cho thang cũ.'
  }
]
</script>

<template>
  <div class="services">
    <section class="subpage-hero">
      <div class="hero-bg">
        <img src="/images/56463040787009741 (1).jpg" alt="Services Hero" />
        <div class="hero-overlay"></div>
      </div>
      <div class="container hero-content text-center">
        <h1>Dịch Vụ Của Chúng Tôi</h1>
        <p>Giải pháp toàn diện xuyên suốt vòng đời của thang máy.</p>
      </div>
    </section>

    <section class="section-padding">
      <div class="container">
        <div v-for="(service, index) in coreServices" :key="service.title" :class="['service-block', index % 2 === 1 ? 'reverse' : '']">
          <div class="block-image animate-fade-in">
            <img :src="service.image" :alt="service.title" />
          </div>
          <div class="block-text animate-fade-in">
            <div class="icon-circle"><component :is="service.icon" :size="30" /></div>
            <h2>{{ service.title }}</h2>
            <p>{{ service.desc }}</p>
            <router-link to="/contact" class="btn btn-primary mt-3">Đăng ký tư vấn <MessageCircle :size="16" /></router-link>
          </div>
        </div>
      </div>
    </section>

    <!-- Support CTA -->
    <section class="bg-primary section-padding text-center">
      <div class="container text-white">
        <h2 class="mb-4">Hỗ trợ kỹ thuật khẩn cấp 24/7</h2>
        <p class="mb-5 opacity-0.9">Bạn gặp sự cố với thang máy? Đừng ngần ngại gọi ngay cho đội ngũ cứu hộ của chúng tôi.</p>
        <div class="flex-center gap-2">
            <a href="tel:0912345678" class="btn btn-white lg"><Phone :size="20" /> 0912.345.678</a>
            <a href="https://zalo.me/0912345678" target="_blank" class="btn btn-outline-white lg">Chat qua Zalo</a>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.subpage-hero {
  height: 400px;
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
  z-index: -1;
}

.subpage-hero .hero-bg img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.subpage-hero h1 {
  font-size: 3.5rem;
  color: white;
  margin-bottom: 1rem;
}

.service-block {
  display: flex;
  align-items: center;
  gap: 5rem;
  margin-bottom: 100px;
}

.service-block.reverse {
  flex-direction: row-reverse;
}

.block-image {
  flex: 1;
  height: 450px;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: var(--shadow);
}

.block-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.8s;
}

.service-block:hover .block-image img {
  transform: scale(1.05);
}

.block-text {
  flex: 1;
}

.icon-circle {
  width: 70px;
  height: 70px;
  background: var(--primary);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 2rem;
}

.block-text h2 {
  font-size: 2.5rem;
  margin-bottom: 1.5rem;
}

.block-text p {
  font-size: 1.1rem;
  color: var(--text-light);
  line-height: 1.8;
  margin-bottom: 2rem;
}

.bg-primary {
  background: var(--primary);
}

.text-white {
  color: white;
}

.btn-white {
  background: white;
  color: var(--primary);
}

.btn-outline-white {
  border: 2px solid white;
  color: white;
}

.flex-center {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
}

@media (max-width: 992px) {
  .service-block, .service-block.reverse {
    flex-direction: column;
    gap: 3rem;
  }
  .block-image {
    width: 100%;
    height: 300px;
  }
}
</style>
