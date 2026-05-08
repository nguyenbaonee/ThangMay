<script setup>
import { onMounted, onUnmounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import {
  Building2,
  CircleHelp,
  Facebook,
  FileText,
  Home,
  Instagram,
  Mail,
  Menu,
  Newspaper,
  Phone,
  Wrench,
  X,
} from 'lucide-vue-next'
import bannerApi from '@/api/bannerApi'
import companyContactApi from '@/api/companyContactApi'

const route = useRoute()
const isScrolled = ref(false)
const isMenuOpen = ref(false)
const contacts = ref([])
const topBanner = ref(null)

const navLinks = [
  { name: 'Trang chủ', path: '/', icon: Home },
  { name: 'Thang máy', path: '/products', icon: Building2 },
  { name: 'Dịch vụ', path: '/services', icon: Wrench },
  { name: 'Bài viết', path: '/projects', icon: Newspaper },
  { name: 'Tài liệu', path: '/documents', icon: FileText },
  { name: 'Liên hệ', path: '/contact', icon: Phone },
  { name: 'Giới thiệu', path: '/about', icon: CircleHelp },
]

const getVal = (key) => contacts.value.find((item) => item.configKey === key)?.configValue || ''

const isNavActive = (link) => {
  if (link.path === '/') return route.path === '/'
  return route.path === link.path || route.path.startsWith(`${link.path}/`)
}

const closeMenu = () => {
  isMenuOpen.value = false
}

const toggleMenu = () => {
  isMenuOpen.value = !isMenuOpen.value
}

const handleScroll = () => {
  isScrolled.value = window.scrollY > 50
}

const handleResize = () => {
  if (window.innerWidth > 992) closeMenu()
}

const fetchData = async () => {
  try {
    const [contactRes, bannerRes] = await Promise.all([
      companyContactApi.getPublic(),
      bannerApi.getPublic('TOP'),
    ])
    contacts.value = contactRes.data || []
    topBanner.value = bannerRes.data?.[0] || null
  } catch (error) {
    console.error('Error fetching header info:', error)
  }
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
  window.addEventListener('resize', handleResize)
  fetchData()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  window.removeEventListener('resize', handleResize)
  document.body.classList.remove('mobile-menu-open')
})

watch(isMenuOpen, (open) => {
  document.body.classList.toggle('mobile-menu-open', open)
})

watch(() => route.fullPath, closeMenu)
</script>

<template>
  <header :class="['header', isScrolled ? 'header-scrolled' : '']">
    <div v-if="topBanner && !isScrolled" class="banner-top-promo">
      <a :href="topBanner.linkUrl || '#'">
        <img :src="topBanner.imageUrl" :alt="topBanner.title" />
      </a>
    </div>

    <div v-show="!isScrolled" class="top-bar">
      <div class="container top-bar-content">
        <div class="info-group">
          <a :href="'tel:' + getVal('hotline').replace(/\s+/g, '')" class="info-item">
            <Phone :size="14" />
            <span>{{ getVal('hotline') }}</span>
          </a>
          <a :href="'mailto:' + getVal('email')" class="info-item">
            <Mail :size="14" />
            <span>{{ getVal('email') }}</span>
          </a>
        </div>

        <div class="social-links">
          <a :href="getVal('facebook_url') || '#'" target="_blank" rel="noreferrer" aria-label="Facebook">
            <Facebook :size="14" />
          </a>
          <a :href="getVal('instagram_url') || '#'" target="_blank" rel="noreferrer" aria-label="Instagram">
            <Instagram :size="14" />
          </a>
        </div>
      </div>
    </div>

    <nav class="main-nav">
      <div class="container nav-content">
        <router-link to="/" class="logo" @click="closeMenu">
          <span class="logo-text">Misel</span>
          <span class="logo-subtext">Elevating Living</span>
        </router-link>

        <ul class="nav-links desktop-menu">
          <li v-for="link in navLinks" :key="link.path">
            <router-link :to="link.path" :class="{ active: isNavActive(link) }">
              {{ link.name }}
            </router-link>
          </li>
        </ul>

        <router-link to="/contact" class="btn btn-primary desktop-btn">
          Yêu cầu tư vấn
        </router-link>

        <button
          class="mobile-toggle"
          type="button"
          :aria-expanded="isMenuOpen"
          aria-label="Mở menu"
          @click="toggleMenu"
        >
          <X v-if="isMenuOpen" :size="24" />
          <span v-else class="hamburger-lines" aria-hidden="true">
            <span></span>
            <span></span>
            <span></span>
          </span>
        </button>
      </div>
    </nav>
  </header>

  <div
    v-if="isMenuOpen"
    class="mobile-menu-backdrop"
    style="position: fixed; inset: 0; z-index: 9000; background: rgba(10, 14, 20, 0.5);"
    @click="closeMenu"
  ></div>

  <aside
    v-if="isMenuOpen"
    class="mobile-menu-drawer"
    aria-label="Menu mobile"
    style="position: fixed; top: 0; right: 0; bottom: 0; z-index: 9001; width: 300px; max-width: 72vw; height: 100dvh; background: #fffdf8; box-shadow: -18px 0 42px rgba(10, 14, 20, 0.22); display: flex; flex-direction: column; overflow: hidden;"
  >
    <div class="mobile-menu-head">
      <router-link to="/" class="mobile-brand" @click="closeMenu">
        <span class="mobile-brand-text">Misel</span>
        <span class="mobile-brand-subtext">Elevating Living</span>
      </router-link>

      <button class="mobile-close" type="button" aria-label="Đóng menu" @click="closeMenu">
        <X :size="24" />
      </button>
    </div>

    <div class="mobile-menu-body">
      <ul class="mobile-nav-links">
        <li v-for="link in navLinks" :key="link.path">
          <router-link :to="link.path" :class="{ active: isNavActive(link) }" @click="closeMenu">
            <component :is="link.icon" :size="20" class="mobile-link-icon" />
            <span>{{ link.name }}</span>
          </router-link>
        </li>
      </ul>
    </div>

    <div class="mobile-menu-actions">
      <router-link to="/contact" class="mobile-cta" @click="closeMenu">
        Yêu cầu tư vấn
      </router-link>
      <a :href="'tel:' + getVal('hotline').replace(/\s+/g, '')" class="mobile-hotline">
        Hotline: {{ getVal('hotline') }}
      </a>
    </div>
  </aside>
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
  background: #fff;
  box-shadow: var(--shadow);
}

.banner-top-promo {
  width: 100%;
  height: 56px;
  overflow: hidden;
  background: #000;
}

.banner-top-promo img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.top-bar {
  padding: 0.5rem 0;
  background: var(--secondary);
  color: #fff;
  font-size: 0.8rem;
}

.top-bar-content,
.nav-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.info-group,
.info-item,
.social-links {
  display: flex;
  align-items: center;
}

.info-group {
  gap: 1.5rem;
}

.info-item {
  gap: 0.5rem;
  opacity: 0.85;
}

.info-item:hover,
.social-links a:hover {
  opacity: 1;
}

.social-links {
  gap: 1rem;
}

.social-links a {
  opacity: 0.85;
}

.social-links a:hover {
  color: var(--primary);
}

.main-nav {
  padding: 1rem 0;
  background: #fff;
  box-shadow: var(--shadow);
  transition: var(--transition);
}

.header-scrolled .main-nav {
  padding: 0.8rem 0;
}

.logo,
.mobile-brand {
  display: flex;
  flex-direction: column;
}

.logo-text,
.mobile-brand-text {
  color: var(--secondary);
  font-size: 1.8rem;
  font-weight: 800;
  letter-spacing: 2px;
  line-height: 1;
}

.logo-subtext,
.mobile-brand-subtext {
  margin-top: 0.15rem;
  color: var(--primary);
  font-size: 0.6rem;
  font-weight: 600;
  letter-spacing: 3px;
  line-height: 1;
  text-transform: uppercase;
}

.nav-links {
  display: flex;
  gap: 2rem;
}

.nav-links a {
  position: relative;
  color: var(--text-main);
  font-weight: 500;
  padding-bottom: 0.25rem;
  transition: color 0.2s ease;
}

.nav-links a.active,
.nav-links a:hover {
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

.desktop-menu,
.desktop-btn {
  display: flex;
}

.mobile-toggle {
  display: none;
  align-items: center;
  justify-content: center;
  width: 42px;
  height: 42px;
  border: 1px solid rgba(0, 45, 94, 0.14);
  border-radius: 8px;
  background: #fff;
  color: var(--secondary);
  cursor: pointer;
}

.hamburger-lines {
  width: 20px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.hamburger-lines span {
  display: block;
  width: 100%;
  height: 2px;
  border-radius: 999px;
  background: currentColor;
}

.mobile-menu-head {
  min-height: 104px;
  padding: 1.25rem 1.25rem 1rem;
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1rem;
  border-bottom: 1px solid rgba(0, 45, 94, 0.08);
  background: #fff;
}

.mobile-close {
  width: 50px;
  height: 50px;
  border: 1px solid rgba(0, 45, 94, 0.14);
  border-radius: 8px;
  background: #fff;
  color: var(--secondary);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.mobile-menu-body {
  flex: 1 1 auto;
  overflow-y: auto;
  padding: 1rem 1.25rem;
  -webkit-overflow-scrolling: touch;
}

.mobile-nav-links {
  display: flex;
  flex-direction: column;
  gap: 0.45rem;
}

.mobile-nav-links a {
  display: flex;
  align-items: center;
  gap: 0.9rem;
  min-height: 48px;
  padding: 0.7rem 0.85rem;
  border-radius: 8px;
  color: var(--text-main);
  font-size: 1.05rem;
  font-weight: 700;
}

.mobile-link-icon {
  flex-shrink: 0;
  color: var(--primary);
}

.mobile-nav-links a.active {
  background: rgba(193, 160, 82, 0.12);
  color: var(--primary-dark);
}

.mobile-nav-links a.active .mobile-link-icon {
  color: var(--primary-dark);
}

.mobile-menu-actions {
  flex-shrink: 0;
  padding: 1rem 1.25rem 1.25rem;
  border-top: 1px solid rgba(0, 45, 94, 0.08);
  background: #fffdf8;
}

.mobile-cta {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  min-height: 48px;
  border-radius: 8px;
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
  color: #fff;
  font-size: 1rem;
  font-weight: 700;
}

.mobile-hotline {
  display: block;
  margin-top: 0.85rem;
  color: var(--secondary);
  font-size: 0.95rem;
  font-weight: 750;
  text-align: center;
}

:global(body.mobile-menu-open) {
  overflow: hidden;
}

@media (max-width: 992px) {
  .desktop-menu,
  .desktop-btn,
  .top-bar {
    display: none;
  }

  .mobile-toggle {
    display: flex;
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
    letter-spacing: 2px;
  }
}

@media (max-width: 480px) {
  .container {
    padding: 0 1rem;
  }

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
  }

  .mobile-menu-head,
  .mobile-menu-body,
  .mobile-menu-actions {
    padding-left: 1rem;
    padding-right: 1rem;
  }
}
</style>
