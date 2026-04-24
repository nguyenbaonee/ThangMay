<script setup>
import { ref, onMounted } from 'vue'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import { Phone } from 'lucide-vue-next'
import companyContactApi from '@/api/companyContactApi'

const contacts = ref([])

onMounted(async () => {
  try {
    const res = await companyContactApi.getPublic()
    contacts.value = res.data || []
  } catch (error) {
    console.error('Error fetching contacts in layout:', error)
  }
})

const getVal = (key) => contacts.value.find(c => c.configKey === key)?.configValue || ''
const defaultHotlineTel = '0345986669'
const normalizeHotline = (value) => {
  const cleaned = String(value || '').replace(/\s+/g, '')
  if (!cleaned || cleaned === '0900000000' || cleaned === '090000000') return '0345986669'
  return cleaned
}
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
      <a :href="getVal('zalo_url') || 'https://zalo.me/0345986669'" target="_blank" class="floating-btn zalo" title="Chat Zalo">
        <img src="/images.png" alt="Zalo" style="width: 32px; height: 32px; object-fit: contain;" />
      </a>
      <a :href="'tel:' + normalizeHotline(getVal('hotline'))" class="floating-btn phone">
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
  background: white !important;
  padding: 0;
}

.zalo svg {
  filter: drop-shadow(0 2px 5px rgba(0, 104, 255, 0.3));
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

@media (max-width: 768px) {
  .floating-support {
    bottom: 16px;
    right: 16px;
    gap: 0.8rem;
  }

  .floating-btn {
    width: 46px;
    height: 46px;
  }
}

@media (max-width: 480px) {
  .floating-support {
    bottom: 12px;
    right: 12px;
    gap: 0.65rem;
  }

  .floating-btn {
    width: 42px;
    height: 42px;
  }
}
</style>
