<script setup>
import { computed, ref, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import {
  Menu,
  X,
  Phone,
  Mail,
  Instagram,
  Facebook,
  House,
  Building2,
  Wrench,
  Newspaper,
  FileText,
  CircleHelp,
} from 'lucide-vue-next'
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

const navLinks = [
  { name: 'Trang chủ', path: '/', icon: House },
  { name: 'Thang máy', path: '/products', icon: Building2 },
  { name: 'Dịch vụ', path: '/services', icon: Wrench },
  { name: 'Bài viết', path: '/projects', icon: Newspaper },
  { name: 'Tài liệu', path: '/documents', icon: FileText },
  { name: 'Liên hệ', path: '/contact', icon: Phone },
  { name: 'Giới thiệu', path: '/about', icon: CircleHelp }
]
const isNavActive = (link) => {
  if (link.path === '/') return route.path === '/'
  return route.path === link.path || route.path.startsWith(`${link.path}/`)
}
const mobilePrimaryLinks = computed(() => navLinks.filter((link) => link.path !== '/about'))
const mobileSecondaryLinks = computed(() => navLinks.filter((link) => link.path === '/about'))
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
          <a :href="getVal('facebook_url') || '#'" target="_blank"><Facebook :size="14" /></a>
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
        <div class="mobile-menu-head">
          <router-link to="/" class="mobile-brand" @click="isMenuOpen = false">
            <span class="mobile-brand-text">Misel</span>
            <span class="mobile-brand-subtext">Elevating Living</span>
          </router-link>
          <button class="mobile-close" @click="isMenuOpen = false" aria-label="Đóng menu">
            <X :size="28" />
          </button>
        </div>

        <div class="mobile-menu-body">
          <ul class="mobile-nav-links">
            <li v-for="link in mobilePrimaryLinks" :key="link.path">
              <router-link :to="link.path" :class="{ active: isNavActive(link) }" @click="isMenuOpen = false">
                <component :is="link.icon" :size="24" class="mobile-link-icon" />
                <span>{{ link.name }}</span>
              </router-link>
            </li>
          </ul>

          <ul v-if="mobileSecondaryLinks.length" class="mobile-nav-links secondary">
            <li v-for="link in mobileSecondaryLinks" :key="link.path">
              <router-link :to="link.path" :class="{ active: isNavActive(link) }" @click="isMenuOpen = false">
                <component :is="link.icon" :size="24" class="mobile-link-icon" />
                <span>{{ link.name }}</span>
              </router-link>
            </li>
          </ul>
        </div>

        <div class="mobile-menu-foot">
          <router-link to="/contact" class="mobile-cta" @click="isMenuOpen = false">
            Yêu cầu tư vấn
          </router-link>

          <div class="mobile-socials">
            <a :href="getVal('facebook_url') || '#'" target="_blank" rel="noreferrer">
              <Facebook :size="20" />
            </a>
            <a :href="getVal('instagram_url') || '#'" target="_blank" rel="noreferrer">
              <Instagram :size="20" />
            </a>
            <a :href="getVal('zalo_url') || '#'" target="_blank" rel="noreferrer" class="zalo-link">
              <img src="/images.png" alt="Zalo" />
            </a>
          </div>

          <a :href="'tel:' + getVal('hotline').replace(/\s+/g, '')" class="mobile-hotline">
            Hotline: {{ getVal('hotline') }}
          </a>
        </div>
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
  background: rgba(7, 16, 24, 0.4);
  display: flex;
  justify-content: flex-end;
  backdrop-filter: blur(2px);
}

.mobile-menu {
  width: min(78vw, 520px);
  background:
    radial-gradient(circle at top right, rgba(193, 160, 82, 0.1), transparent 28%),
    linear-gradient(180deg, #fffdf8 0%, #fffefb 100%);
  height: 100%;
  padding: 1.7rem 2rem 2rem;
  animation: slideIn 0.3s ease;
  display: flex;
  flex-direction: column;
  position: relative;
  overflow: hidden;
}

.mobile-menu::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image:
    radial-gradient(circle at 20% 18%, rgba(193, 160, 82, 0.08) 0 2px, transparent 2px),
    radial-gradient(circle at 78% 26%, rgba(193, 160, 82, 0.07) 0 2px, transparent 2px),
    radial-gradient(circle at 38% 56%, rgba(193, 160, 82, 0.06) 0 2px, transparent 2px),
    radial-gradient(circle at 70% 74%, rgba(193, 160, 82, 0.07) 0 2px, transparent 2px),
    radial-gradient(circle at 24% 84%, rgba(193, 160, 82, 0.06) 0 2px, transparent 2px);
  background-size: 180px 180px;
  pointer-events: none;
  opacity: 0.65;
}

.mobile-menu-head,
.mobile-menu-body,
.mobile-menu-foot {
  position: relative;
  z-index: 1;
}

.mobile-menu-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1rem;
  margin-bottom: 2rem;
}

.mobile-brand {
  display: flex;
  flex-direction: column;
}

.mobile-brand-text {
  font-size: 3rem;
  line-height: 0.95;
  font-weight: 800;
  color: var(--secondary);
  letter-spacing: 1px;
}

.mobile-brand-subtext {
  margin-top: 0.35rem;
  font-size: 0.72rem;
  letter-spacing: 0.26em;
  text-transform: uppercase;
  color: var(--primary);
  font-weight: 700;
}

.mobile-close {
  background: transparent;
  border: none;
  color: var(--primary);
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.mobile-menu-body {
  flex: 1;
}

@keyframes slideIn {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}

.mobile-nav-links {
  display: flex;
  flex-direction: column;
  gap: 0.95rem;
}

.mobile-nav-links.secondary {
  margin-top: 1.25rem;
}

.mobile-nav-links a {
  display: inline-flex;
  align-items: center;
  gap: 0.95rem;
  font-size: 1.9rem;
  font-weight: 500;
  color: var(--text-main);
  width: fit-content;
  padding: 0.28rem 0;
  border-radius: 0;
  position: relative;
}

.mobile-link-icon {
  color: var(--primary);
  flex-shrink: 0;
}

.mobile-nav-links a.active {
  color: var(--primary);
}

.mobile-nav-links a.active::after {
  content: '';
  position: absolute;
  left: 3rem;
  bottom: -0.1rem;
  width: calc(100% - 3rem);
  height: 3px;
  border-radius: 999px;
  background: var(--primary);
}

.mobile-menu-foot {
  padding-top: 1.5rem;
}

.mobile-cta {
  width: 100%;
  min-height: 62px;
  border-radius: 999px;
  background: linear-gradient(180deg, #d3ae4c 0%, #b98d2b 100%);
  color: white;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 1.15rem;
  font-weight: 700;
  box-shadow: 0 18px 28px rgba(193, 160, 82, 0.25);
}

.mobile-socials {
  margin-top: 1.6rem;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
}

.mobile-socials a {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: var(--primary);
}

.mobile-socials .zalo-link img {
  width: 28px;
  height: 28px;
  object-fit: contain;
}

.mobile-hotline {
  margin-top: 1rem;
  display: flex;
  justify-content: center;
  color: var(--secondary);
  font-size: 1.1rem;
  font-weight: 800;
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
    width: min(82vw, 540px);
    padding: 1.4rem 1.5rem 1.6rem;
  }
  .mobile-brand-text {
    font-size: 2.5rem;
  }
  .mobile-nav-links a {
    font-size: 1.65rem;
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
    width: min(84vw, 420px);
    padding: 1.15rem 1.1rem 1.35rem;
  }

  .mobile-brand-text {
    font-size: 2.15rem;
  }

  .mobile-brand-subtext {
    font-size: 0.58rem;
  }

  .mobile-nav-links a {
    font-size: 1.25rem;
    gap: 0.8rem;
  }

  .mobile-link-icon {
    width: 20px;
    height: 20px;
  }

  .mobile-nav-links a.active::after {
    left: 2.45rem;
    width: calc(100% - 2.45rem);
  }

  .mobile-cta {
    min-height: 54px;
    font-size: 1rem;
  }

  .mobile-hotline {
    font-size: 0.95rem;
  }
}
</style>
