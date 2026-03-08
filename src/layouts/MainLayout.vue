<script setup>
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import { Phone } from 'lucide-vue-next'
</script>

<template>
  <div class="layout">
    <Header />
    <main class="main-content">
      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </main>
    <Footer />
    
    <!-- Floating Support Buttons -->
    <div class="floating-support">
      <a href="https://zalo.me/0912345678" target="_blank" class="floating-btn zalo">
        <img src="https://upload.wikimedia.org/wikipedia/commons/9/91/Icon_Zalo.png" alt="Zalo" />
      </a>
      <a href="tel:0912345678" class="floating-btn phone">
        <Phone :size="24" />
      </a>
    </div>
  </div>
</template>

<style scoped>
.layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.main-content {
  flex: 1;
}

.floating-support {
  position: fixed;
  bottom: 30px;
  right: 30px;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  z-index: 1000;
}

.floating-btn {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
  transition: var(--transition);
}

.floating-btn:hover {
  transform: scale(1.1);
}

.zalo {
  background: #0068ff;
  padding: 8px;
}

.zalo img {
  width: 100%;
}

.phone {
  background: var(--primary);
  color: white;
}

/* Page transitions */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
