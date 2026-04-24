<script setup>
import { Settings, Zap, ShieldCheck, Headphones, Construction, RefreshCw, MessageCircle, Phone } from 'lucide-vue-next'
import { ref, onMounted } from 'vue'
import companyContactApi from '@/api/companyContactApi'

const contacts = ref([])
onMounted(async () => {
  try {
    const res = await companyContactApi.getPublic()
    contacts.value = res.data || []
  } catch (error) {
    console.error('Error fetching contacts:', error)
  }
})

const getVal = (key) => contacts.value.find(c => c.configKey === key)?.configValue || ''
const defaultHotline = '034 598 6669'
const normalizeHotline = (value) => {
  const cleaned = String(value || '').replace(/\s+/g, '')
  if (!cleaned || cleaned === '0900000000' || cleaned === '090000000') return defaultHotline
  return value
}
const resolveHotlineTel = (value) => String(normalizeHotline(value)).replace(/\s+/g, '')

const coreServices = [
  { 
    title: 'Tư vấn & Thiết kế', 
    icon: Settings, 
    image: 'https://images.unsplash.com/photo-1541819361361-b5413156942a?q=80&w=1000',
    desc: 'Chúng tôi lắng nghe nhu cầu của bạn để đưa ra giải pháp thang máy tối ưu nhất về công năng và thẩm mỹ.'
  },
  { 
    title: 'Cung cấp & Lắp đặt', 
    icon: Construction, 
    image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=1000',
    desc: 'Quy trình thi công chuyên nghiệp, đảm bảo an toàn tuyệt đối và đúng tiến độ cam kết.'
  },
  { 
    title: 'Bảo trì & Sửa chữa', 
    icon: ShieldCheck, 
    image: 'https://images.unsplash.com/photo-1541819361361-b5413156942a?q=80&w=1000',
    desc: 'Dịch vụ hậu mãi chu đáo, hỗ trợ kỹ thuật 24/7 giúp thang máy luôn vận hành ổn định.'
  },
  { 
    title: 'Nâng cấp & Cải tạo', 
    icon: RefreshCw, 
    image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=1000',
    desc: 'Làm mới không gian nội thất cabin và nâng cấp công nghệ cho các dòng thang máy cũ.'
  }
]
</script>

<template>
  <div class="services">
    <section class="subpage-hero">
      <div class="hero-bg">
        <img src="https://images.unsplash.com/photo-1541819361361-b5413156942a?q=80&w=2000" alt="Services Hero" />
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
            <a :href="'tel:' + resolveHotlineTel(getVal('hotline'))" class="btn btn-white lg"><Phone :size="20" /> {{ normalizeHotline(getVal('hotline')) }}</a>
            <a :href="getVal('zalo_url') || 'https://zalo.me/0345986669'" target="_blank" class="btn btn-outline-white lg">Chat qua Zalo</a>
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

@media (max-width: 768px) {
  .subpage-hero {
    height: 260px;
  }

  .subpage-hero h1 {
    font-size: 2rem;
  }

  .subpage-hero p {
    font-size: 0.92rem;
  }

  .service-block, .service-block.reverse {
    gap: 1.5rem;
    margin-bottom: 72px;
  }

  .block-image {
    height: 230px;
    border-radius: 14px;
  }

  .icon-circle {
    width: 56px;
    height: 56px;
    margin-bottom: 1.25rem;
  }

  .block-text h2 {
    font-size: 1.8rem;
    margin-bottom: 1rem;
  }

  .block-text p {
    font-size: 1rem;
    margin-bottom: 1.25rem;
  }

  .flex-center {
    gap: 0.75rem;
  }

  .flex-center .btn {
    width: 100%;
  }
}
</style>
