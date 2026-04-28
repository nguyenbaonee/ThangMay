<script setup>
import { Settings, ShieldCheck, Construction, RefreshCw, MessageCircle, Phone } from 'lucide-vue-next'
import { computed, ref, onMounted, onUnmounted } from 'vue'
import companyContactApi from '@/api/companyContactApi'

const contacts = ref([])
const activeMobileService = ref(0)
let mobileCarouselTimer = null

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

const mobileTrackStyle = computed(() => ({
  transform: `translateX(calc(50% - ${(activeMobileService.value * 88) + 44}%))`
}))

const nextMobileService = () => {
  activeMobileService.value = (activeMobileService.value + 1) % coreServices.length
}

const setMobileService = (index) => {
  activeMobileService.value = index
}

onMounted(async () => {
  try {
    const res = await companyContactApi.getPublic()
    contacts.value = res.data || []
  } catch (error) {
    console.error('Error fetching contacts:', error)
  }

  mobileCarouselTimer = window.setInterval(nextMobileService, 3200)
})

onUnmounted(() => {
  if (mobileCarouselTimer) {
    window.clearInterval(mobileCarouselTimer)
    mobileCarouselTimer = null
  }
})
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
        <div class="desktop-services">
          <div
            v-for="(service, index) in coreServices"
            :key="service.title"
            :class="['service-block', index % 2 === 1 ? 'reverse' : '']"
          >
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

        <div class="mobile-services">
          <div class="mobile-carousel-shell">
            <div class="mobile-carousel-track" :style="mobileTrackStyle">
              <article
                v-for="(service, index) in coreServices"
                :key="service.title"
                :class="['mobile-service-card', { active: activeMobileService === index }]"
                @click="setMobileService(index)"
              >
                <div class="mobile-service-icon">
                  <component :is="service.icon" :size="30" />
                </div>
                <h2>{{ service.title }}</h2>
                <p>{{ service.desc }}</p>
                <router-link to="/contact" class="btn btn-primary mobile-service-btn">
                  Đăng ký tư vấn
                  <MessageCircle :size="16" />
                </router-link>
                <div class="mobile-service-image">
                  <img :src="service.image" :alt="service.title" />
                </div>
              </article>
            </div>
          </div>

          <div class="mobile-carousel-dots">
            <button
              v-for="(service, index) in coreServices"
              :key="service.title + '-dot'"
              :class="['carousel-dot', { active: activeMobileService === index }]"
              @click="setMobileService(index)"
              :aria-label="`Xem dịch vụ ${service.title}`"
            ></button>
          </div>
        </div>
      </div>
    </section>

    <section class="bg-primary section-padding text-center emergency-support">
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
  display: none !important;
  height: 0 !important;
  min-height: 0 !important;
  overflow: hidden;
  margin: 0;
  padding: 0;
}

.services > .subpage-hero + .section-padding {
  padding-top: 196px;
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

.mobile-services {
  display: none;
}

.bg-primary {
  background: var(--primary);
}

.emergency-support {
  display: block;
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
  .service-block,
  .service-block.reverse {
    flex-direction: column;
    gap: 3rem;
  }

  .block-image {
    width: 100%;
    height: 300px;
  }
}

@media (max-width: 768px) {
  .services > .subpage-hero + .section-padding {
    padding-top: 128px;
  }

  .desktop-services {
    display: none;
  }

  .mobile-services {
    display: block;
  }

  .mobile-carousel-shell {
    overflow: hidden;
    padding: 0.75rem 0 0.5rem;
  }

  .mobile-carousel-track {
    display: flex;
    align-items: stretch;
    gap: 1rem;
    transition: transform 0.65s cubic-bezier(0.22, 1, 0.36, 1);
    will-change: transform;
  }

  .mobile-service-card {
    flex: 0 0 88%;
    background: #fff;
    border: 2px solid rgba(193, 160, 82, 0.2);
    border-radius: 24px;
    box-shadow: 0 18px 36px rgba(12, 20, 31, 0.08);
    padding: 1.35rem;
    transition: transform 0.45s ease, box-shadow 0.45s ease, border-color 0.45s ease, opacity 0.45s ease;
    transform: scale(0.93) translateY(16px);
    opacity: 0.65;
  }

  .mobile-service-card.active {
    transform: scale(1) translateY(0);
    border-color: rgba(193, 160, 82, 0.92);
    box-shadow: 0 24px 42px rgba(193, 160, 82, 0.16);
    opacity: 1;
  }

  .mobile-service-icon {
    width: 76px;
    height: 76px;
    border-radius: 50%;
    background: linear-gradient(180deg, #d3ae4c 0%, #b98d2b 100%);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 1.35rem;
  }

  .mobile-service-card h2 {
    font-size: 1.8rem;
    line-height: 1.18;
    margin-bottom: 1rem;
  }

  .mobile-service-card p {
    font-size: 1rem;
    color: var(--text-light);
    line-height: 1.7;
    margin-bottom: 1.3rem;
  }

  .mobile-service-btn {
    width: 100%;
    min-height: 54px;
    margin-bottom: 1.25rem;
  }

  .mobile-service-image {
    height: 200px;
    border-radius: 18px;
    overflow: hidden;
  }

  .mobile-service-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .mobile-carousel-dots {
    display: flex;
    justify-content: center;
    gap: 0.75rem;
    margin-top: 1.1rem;
  }

  .carousel-dot {
    width: 14px;
    height: 14px;
    border-radius: 50%;
    border: 2px solid rgba(193, 160, 82, 0.9);
    background: transparent;
    cursor: pointer;
    transition: var(--transition);
  }

  .carousel-dot.active {
    background: var(--primary);
  }

  .flex-center {
    gap: 0.75rem;
  }

  .flex-center .btn {
    width: 100%;
  }

  .emergency-support {
    display: none;
  }
}
</style>
