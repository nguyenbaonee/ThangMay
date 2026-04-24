<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import { Menu, X, Phone, Mail, Instagram, Facebook } from 'lucide-vue-next'
import companyContactApi from '@/api/companyContactApi'
import bannerApi from '@/api/bannerApi'

const isScrolled = ref(false)
const isMenuOpen = ref(false)
const contacts = ref([])
const topBanner = ref(null)
const route = useRoute()

const handleScroll = () => {
  isScrolled.value = window.scrollY > 50
}

const fetchData = async () => {
  try {
    const [contactRes, bannerRes] = await Promise.all([
      companyContactApi.getPublic(),
      bannerApi.getPublic('TOP')
    ])
    contacts.value = contactRes.data || []
    if (bannerRes.data?.length > 0) topBanner.value = bannerRes.data[0]
  } catch (error) {
    console.error('Error fetching header info:', error)
  }
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
  fetchData()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})

const getVal = (key) => contacts.value.find(c => c.configKey === key)?.configValue || ''
const defaultHotline = '034 598 6669'
const defaultHotlineTel = '0345986669'
const normalizeHotline = (value) => {
  const cleaned = String(value || '').replace(/\s+/g, '')
  if (!cleaned || cleaned === '0900000000' || cleaned === '090000000') return defaultHotline
  return value
}
const resolveHotlineTel = (value) => String(normalizeHotline(value)).replace(/\s+/g, '')

const navLinks = [
  { name: 'Trang chủ', path: '/' },
  { name: 'Giới thiệu', path: '/about' },
  { name: 'Thang máy', path: '/products' },
  { name: 'Dịch vụ', path: '/services' },
  { name: 'Dự án', path: '/projects' },
  { name: 'Tài liệu', path: '/documents' },
  { name: 'Liên hệ', path: '/contact' }
]
const isNavActive = (link) => {
  if (link.path === '/') return route.path === '/'
  return route.path === link.path || route.path.startsWith(`${link.path}/`)
}
</script>

<template>
  <header 
    :class="['header', isScrolled ? 'header-scrolled' : '']"
  >
    <!-- TOP Banner position -->
    <div v-if="topBanner && !isScrolled" class="banner-top-promo">
        <a :href="topBanner.linkUrl || '#'">
            <img :src="topBanner.imageUrl" :alt="topBanner.title" />
        </a>
    </div>

    <!-- Top info bar -->
    <div v-show="!isScrolled" class="top-bar">
      <div class="container top-bar-content">
        <div class="info-group">
          <a :href="'tel:' + resolveHotlineTel(getVal('hotline'))" class="info-item">
            <Phone :size="14" />
            <span>{{ normalizeHotline(getVal('hotline')) }}</span>
          </a>
          <a :href="'mailto:' + getVal('email')" class="info-item">
            <Mail :size="14" />
            <span>{{ getVal('email') || 'info@thangmaymisel.com' }}</span>
          </a>
        </div>
        <div class="social-links">
          <a :href="getVal('facebook_url') || 'https://web.facebook.com/thangmaymisel/?_rdc=1&_rdr#'" target="_blank"><Facebook :size="14" /></a>
          <a :href="getVal('instagram_url') || '#'" target="_blank"><Instagram :size="14" /></a>
        </div>
      </div>
    </div>

    <!-- Main Navigation -->
    <nav class="main-nav">
      <div class="container nav-content">
        <router-link to="/" class="logo">
          <span class="logo-text">Misel</span>
          <span class="logo-subtext">Elevating Living</span>
        </router-link>

        <!-- Desktop Menu -->
        <ul class="nav-links desktop-menu">
          <li v-for="link in navLinks" :key="link.path">
            <router-link :to="link.path" :class="{ active: isNavActive(link) }">{{ link.name }}</router-link>
          </li>
        </ul>

        <router-link to="/contact" class="btn btn-primary desktop-btn">Yêu cầu tư vấn</router-link>

        <!-- Mobile Toggle -->
        <button class="mobile-toggle" @click="isMenuOpen = !isMenuOpen">
          <component :is="isMenuOpen ? X : Menu" :size="24" />
        </button>
      </div>
    </nav>

    <!-- Mobile Menu Overlay -->
    <div v-if="isMenuOpen" class="mobile-menu-overlay" @click="isMenuOpen = false">
      <div class="mobile-menu" @click.stop>
        <ul class="mobile-nav-links">
          <li v-for="link in navLinks" :key="link.path">
            <router-link :to="link.path" :class="{ active: isNavActive(link) }" @click="isMenuOpen = false">
              {{ link.name }}
            </router-link>
          </li>
          <li class="mt-4">
            <router-link to="/contact" class="btn btn-primary w-full" @click="isMenuOpen = false">
              Yêu cầu tư vấn
            </router-link>
          </li>
        </ul>
      </div>
    </div>
  </header>
</template>

<style scoped>
.header {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 1000;
  transition: var(--transition);
}

.header-scrolled {
  background: white;
  box-shadow: var(--shadow);
}

.banner-top-promo {
    width: 100%;
    height: 56px;
    overflow: hidden;
    background: #000;
}

.banner-top-promo img {
    width: 100%;
    height: 100%;
    object-fit: contain;
    display: block;
}

.top-bar {
  background: var(--secondary);
  color: white;
  padding: 0.5rem 0;
  font-size: 0.8rem;
}

.top-bar-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.info-group, .info-item {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.info-item {
  gap: 0.5rem;
  opacity: 0.8;
}

.info-item:hover {
  opacity: 1;
}

.social-links {
  display: flex;
  gap: 1rem;
}

.social-links a {
  opacity: 0.8;
}

.social-links a:hover {
  opacity: 1;
  color: var(--primary);
}

.main-nav {
  padding: 1rem 0;
  background: white;
  transition: var(--transition);
  box-shadow: var(--shadow);
}

.header-scrolled .main-nav {
  padding: 0.8rem 0;
}

.nav-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo {
  display: flex;
  flex-direction: column;
}

.logo-text {
  font-size: 1.8rem;
  font-weight: 800;
  color: var(--secondary);
  letter-spacing: 2px;
  line-height: 1;
}

.logo-subtext {
  font-size: 0.6rem;
  text-transform: uppercase;
  letter-spacing: 3px;
  color: var(--primary);
  font-weight: 600;
}

.nav-links {
  display: flex;
  gap: 2rem;
}

.nav-links a {
  position: relative;
  font-weight: 500;
  color: var(--text-main);
  padding-bottom: 0.25rem;
  transition: color 0.2s ease;
}

.nav-links a.active, .nav-links a:hover {
  color: var(--primary);
}

.nav-links a.active::after {
  content: '';
  position: absolute;
  left: 0;
  bottom: -0.25rem;
  width: 100%;
  height: 2px;
  border-radius: 999px;
  background: var(--primary);
}

.desktop-menu {
  display: flex;
}

.desktop-btn {
  display: flex;
}

.mobile-toggle {
  display: none;
  background: none;
  border: none;
  cursor: pointer;
  color: var(--secondary);
}

.header:not(.header-scrolled) .mobile-toggle {
  color: var(--secondary);
}

.mobile-menu-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100vh;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: flex-end;
}

.mobile-menu {
  width: 70%;
  max-width: 300px;
  background: white;
  height: 100%;
  padding: 2rem;
  animation: slideIn 0.3s ease;
}

@keyframes slideIn {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}

.mobile-nav-links {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  margin-top: 2rem;
}

.mobile-nav-links a {
  display: inline-flex;
  align-items: center;
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--text-main);
  width: fit-content;
  padding: 0.2rem 0.4rem;
  border-radius: 10px;
}

.mobile-nav-links a.active {
  color: var(--primary);
  background: rgba(193, 160, 82, 0.12);
}

@media (max-width: 992px) {
  .desktop-menu, .desktop-btn, .top-bar {
    display: none;
  }
  .mobile-toggle {
    display: block;
  }
  .banner-top-promo {
    height: 52px;
  }
  .main-nav {
    padding: 0.85rem 0;
  }
  .nav-content {
    gap: 1rem;
  }
  .logo-text {
    font-size: 1.55rem;
  }
  .logo-subtext {
    font-size: 0.55rem;
  }
  .header:not(.header-scrolled) .main-nav {
    background: white;
  }
  .mobile-menu {
    width: 86%;
    max-width: 320px;
    padding: 1.25rem;
  }
  .mobile-nav-links {
    gap: 1rem;
    margin-top: 1.5rem;
  }
  .mobile-nav-links a {
    font-size: 1rem;
  }
}

@media (max-width: 480px) {
  .banner-top-promo {
    height: 44px;
  }

  .main-nav {
    padding: 0.75rem 0;
  }

  .logo-text {
    font-size: 1.35rem;
  }

  .logo-subtext {
    font-size: 0.5rem;
    letter-spacing: 2px;
  }

  .mobile-menu {
    width: 92%;
    padding: 1rem;
  }
}
</style>
