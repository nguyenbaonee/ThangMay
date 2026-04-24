<script setup>
import { ShoppingCart, FileText, MessageSquare, PhoneCall, LayoutGrid, Eye, Loader2 } from 'lucide-vue-next'
import { ref, onMounted } from 'vue'
import dashboardApi from '@/api/dashboardApi'

const isLoading = ref(false)
const stats = ref([
  { id: 'totalProducts', name: 'Sản phẩm', value: '0', icon: ShoppingCart, color: '#4f46e5' },
  { id: 'totalPosts', name: 'Bài viết', value: '0', icon: MessageSquare, color: '#10b981' },
  { id: 'totalDocuments', name: 'Tài liệu', value: '0', icon: FileText, color: '#3b82f6' },
  { id: 'newContacts', name: 'Liên hệ mới', value: '0', icon: PhoneCall, color: '#ef4444' },
])

onMounted(async () => {
    isLoading.value = true
    try {
        const res = await dashboardApi.getStats()
        if (res.data) {
            stats.value.forEach(s => {
                if (res.data[s.id] !== undefined) {
                    s.value = res.data[s.id].toString()
                }
            })
        }
    } catch (e) {
        console.error('Error fetching dashboard stats:', e)
    } finally {
        isLoading.value = false
    }
})
</script>


<template>
  <div class="admin-page animate-in">
    <div class="page-header">
      <div>
        <h2>Tổng quan hệ thống</h2>
        <p class="subtitle">Chào mừng bạn quay trở lại trang quản trị.</p>
      </div>
    </div>

    <div class="stats-grid">
      <div v-for="s in stats" :key="s.name" class="stat-card">
        <div class="stat-icon" :style="{ background: s.color + '15', color: s.color }">
          <component :is="s.icon" :size="24" />
        </div>
        <div class="stat-info">
          <span class="stat-label">{{ s.name }}</span>
          <span v-if="isLoading" class="stat-value"><Loader2 :size="20" class="spinner" /></span>
          <span v-else class="stat-value">{{ s.value }}</span>
        </div>
      </div>
    </div>

    <div class="dashboard-content mt-4">
      <div class="card p-4">
        <h3 class="mb-3">Hoạt động gần đây</h3>
        <p class="text-muted">Tính năng đang được cập nhật...</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  background: #fff;
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  display: flex;
  align-items: center;
  gap: 1.25rem;
  transition: transform 0.2s;
}

.stat-card:hover {
  transform: translateY(-4px);
}

.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-info {
  display: flex;
  flex-direction: column;
}

.stat-label {
  font-size: 0.85rem;
  color: #64748b;
  font-weight: 600;
}

.stat-value {
  font-size: 1.5rem;
  font-weight: 800;
  color: #1e293b;
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}
</style>
