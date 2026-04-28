<script setup>
import { onMounted } from 'vue'

onMounted(() => {
})
</script>

<template>
  <div id="app">
    <router-view />
  </div>
</template>

<style>
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
}

::-webkit-scrollbar-thumb {
  background: var(--primary);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
  background: var(--primary-dark);
}

.mt-4 { margin-top: 1rem; }
.mt-5 { margin-top: 2rem; }
.mb-4 { margin-bottom: 1rem; }
.mb-5 { margin-bottom: 2rem; }
.p-3 { padding: 1rem; }
.p-4 { padding: 1.5rem; }
.w-full { width: 100%; }
.text-center { text-align: center; }
.font-bold { font-weight: 700; }
.text-white { color: white !important; }
.opacity-0\.8 { opacity: 0.8 !important; }
.opacity-0\.9 { opacity: 0.9 !important; }
.shadow-lg { box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
.rounded-20 { border-radius: 20px; }
.overflow-hidden { overflow: hidden; }

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.fade-in {
  animation: fadeIn 0.8s ease forwards;
}
</style>
