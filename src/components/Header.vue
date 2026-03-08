<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { Menu, X, Phone, Mail, Instagram, Facebook } from 'lucide-vue-next'

const isScrolled = ref(false)
const isMenuOpen = ref(false)

const handleScroll = () => {
  isScrolled.value = window.scrollY > 50
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})

const navLinks = [
  { name: 'Trang chủ', path: '/' },
  { name: 'Giới thiệu', path: '/about' },
  { name: 'Thang máy', path: '/products' },
  { name: 'Dịch vụ', path: '/services' },
  { name: 'Dự án', path: '/projects' },
  { name: 'Tài liệu', path: '/documents' },
  { name: 'Liên hệ', path: '/contact' }
]
</script>

<template>
  <header 
    :class="['header', isScrolled ? 'header-scrolled' : '']"
  >
    <!-- Top info bar -->
    <div v-show="!isScrolled" class="top-bar">
      <div class="container top-bar-content">
        <div class="info-group">
          <a href="tel:0912345678" class="info-item">
            <Phone :size="14" />
            <span>0912.345.678</span>
          </a>
          <a href="mailto:info@baothangmay.vn" class="info-item">
            <Mail :size="14" />
            <span>info@baothangmay.vn</span>
          </a>
        </div>
        <div class="social-links">
          <a href="#" target="_blank"><Facebook :size="14" /></a>
          <a href="#" target="_blank"><Instagram :size="14" /></a>
        </div>
      </div>
    </div>

    <!-- Main Navigation -->
    <nav class="main-nav">
      <div class="container nav-content">
        <router-link to="/" class="logo">
          <span class="logo-text">BaoThangMay</span>
          <span class="logo-subtext">Elevating Living</span>
        </router-link>

        <!-- Desktop Menu -->
        <ul class="nav-links desktop-menu">
          <li v-for="link in navLinks" :key="link.path">
            <router-link :to="link.path" active-class="active">{{ link.name }}</router-link>
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
            <router-link :to="link.path" active-class="active" @click="isMenuOpen = false">
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
  background: transparent;
  transition: var(--transition);
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

.header:not(.header-scrolled) .logo-text {
  color: white;
}

.logo-subtext {
  font-size: 0.6rem;
  text-transform: uppercase;
  letter-spacing: 3px;
  color: var(--primary);
  font-weight: 600;
}

.header:not(.header-scrolled) .logo-subtext {
  color: white;
}

.nav-links {
  display: flex;
  gap: 2rem;
}

.nav-links a {
  font-weight: 500;
  color: var(--text-main);
}

.header:not(.header-scrolled) .nav-links a {
  color: white;
}

.nav-links a.active, .nav-links a:hover {
  color: var(--primary);
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
}

.header:not(.header-scrolled) .mobile-toggle {
  color: white;
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
  font-size: 1.1rem;
  font-weight: 600;
}

@media (max-width: 992px) {
  .desktop-menu, .desktop-btn, .top-bar {
    display: none;
  }
  .mobile-toggle {
    display: block;
  }
  .header:not(.header-scrolled) .logo-text {
    color: var(--secondary);
  }
  .header:not(.header-scrolled) .logo-subtext {
    color: var(--primary);
  }
  .header:not(.header-scrolled) .main-nav {
    background: white;
  }
}
</style>
