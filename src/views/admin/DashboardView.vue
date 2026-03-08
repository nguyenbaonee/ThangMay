<script setup>
import { ShoppingCart, FileText, MessageSquare, PhoneCall, TrendingUp, Users, ArrowUpRight } from 'lucide-vue-next'

const stats = [
  { label: 'Tổng sản phẩm', value: '42', icon: ShoppingCart, color: '#e3f2fd', iconColor: '#2196f3' },
  { label: 'Tài liệu đã đăng', value: '18', icon: FileText, color: '#f3e5f5', iconColor: '#9c27b0' },
  { label: 'Yêu cầu tư vấn', value: '125', icon: PhoneCall, color: '#e8f5e9', iconColor: '#4caf50' },
  { label: 'Lượt xem tuần', value: '1.2k', icon: TrendingUp, color: '#fff3e0', iconColor: '#ff9800' }
]

const recentContacts = [
  { id: 1, name: 'Nguyễn Văn A', phone: '0912345678', service: 'Tư vấn lắp đặt', status: 'Chưa xử lý', date: '10/03/2024' },
  { id: 2, name: 'Trần Thị B', phone: '0988777666', service: 'Bảo trì định kỳ', status: 'Đã xử lý', date: '09/03/2024' },
  { id: 3, name: 'Lê Văn C', phone: '0977123456', service: 'Báo giá thang kính', status: 'Chưa xử lý', date: '08/03/2024' }
]
</script>

<template>
  <div class="dashboard">
    <div class="page-header">
      <h1>Tổng quan hệ thống</h1>
      <p>Chào mừng Admin, quay trở lại quản lý hệ thống BaoThangMay.</p>
    </div>

    <!-- Stats Grid -->
    <div class="stats-grid mt-4">
      <div v-for="stat in stats" :key="stat.label" class="stat-card">
        <div class="stat-icon" :style="{ backgroundColor: stat.color, color: stat.iconColor }">
          <component :is="stat.icon" :size="24" />
        </div>
        <div class="stat-info">
          <span class="stat-label">{{ stat.label }}</span>
          <h2 class="stat-value">{{ stat.value }}</h2>
        </div>
        <div class="stat-trend success">
          <ArrowUpRight :size="14" /> +12%
        </div>
      </div>
    </div>

    <!-- Main Content Grid -->
    <div class="dashboard-content-grid mt-5">
      <!-- Recent Contacts Table -->
      <div class="content-card table-section">
        <div class="card-header">
          <h3>Yêu cầu liên hệ mới nhất</h3>
          <router-link to="/admin/contacts" class="view-all">Xem tất cả</router-link>
        </div>
        <div class="table-wrapper">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Khách hàng</th>
                <th>Số điện thoại</th>
                <th>Dịch vụ</th>
                <th>Trạng thái</th>
                <th>Ngày gửi</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="contact in recentContacts" :key="contact.id">
                <td><strong>{{ contact.name }}</strong></td>
                <td>{{ contact.phone }}</td>
                <td><span class="badge-service">{{ contact.service }}</span></td>
                <td><span :class="['status-pill', contact.status === 'Đã xử lý' ? 'done' : 'new']">{{ contact.status }}</span></td>
                <td>{{ contact.date }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="content-card actions-section">
        <h3>Lối tắt quản lý</h3>
        <div class="quick-btns">
            <button class="action-btn">
                <ShoppingCart :size="20" /> Thêm sản phẩm
            </button>
            <button class="action-btn">
                <FileText :size="20" /> Đăng tài liệu
            </button>
            <button class="action-btn">
                <MessageSquare :size="20" /> Viết bài mới
            </button>
        </div>
        <div class="admin-notes mt-4">
            <h4>Ghi chú Admin</h4>
            <textarea placeholder="Nhập ghi chú cho quản trị viên khác..."></textarea>
            <button class="btn btn-primary sm mt-2">Lưu ghi chú</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-header h1 {
  font-size: 2rem;
  color: #1a237e;
}

.page-header p {
  color: #666;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 1.5rem;
}

.stat-card {
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  display: flex;
  align-items: center;
  gap: 1.5rem;
  box-shadow: 0 4px 15px rgba(0,0,0,0.03);
  position: relative;
}

.stat-icon {
  width: 50px;
  height: 50px;
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
  font-size: 0.9rem;
  color: #888;
  font-weight: 500;
}

.stat-value {
  font-size: 1.8rem;
  font-weight: 800;
  color: #333;
}

.stat-trend {
  position: absolute;
  top: 1.5rem;
  right: 1.5rem;
  font-size: 0.75rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 2px;
}

.stat-trend.success { color: #4caf50; }

.dashboard-content-grid {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 2rem;
}

.content-card {
  background: white;
  padding: 2rem;
  border-radius: 16px;
  box-shadow: 0 5px 20px rgba(0,0,0,0.02);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.view-all {
  color: var(--primary);
  font-weight: 600;
  font-size: 0.9rem;
}

.table-wrapper {
    overflow-x: auto;
}

.admin-table {
  width: 100%;
  border-collapse: collapse;
}

.admin-table th {
  text-align: left;
  padding: 1rem;
  color: #888;
  font-size: 0.85rem;
  border-bottom: 1px solid #eee;
}

.admin-table td {
  padding: 1.2rem 1rem;
  font-size: 0.9rem;
  border-bottom: 1px solid #f9f9f9;
}

.badge-service {
    background: #f0f2f5;
    padding: 0.25rem 0.75rem;
    border-radius: 4px;
    font-size: 0.75rem;
    font-weight: 600;
}

.status-pill {
  padding: 0.3rem 0.8rem;
  border-radius: 20px;
  font-size: 0.75rem;
  font-weight: 700;
}

.status-pill.new { background: #fff8e1; color: #ff8f00; }
.status-pill.done { background: #e8f5e9; color: #43a047; }

.quick-btns {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    margin-top: 2rem;
}

.action-btn {
    width: 100%;
    padding: 1rem;
    border: 1px dashed #ddd;
    background: #fdfdfd;
    border-radius: 8px;
    display: flex;
    align-items: center;
    gap: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: 0.2s;
}

.action-btn:hover {
    border-color: var(--primary);
    color: var(--primary);
    background: white;
}

.admin-notes textarea {
    width: 100%;
    border-radius: 8px;
    padding: 1rem;
    border: 1px solid #eee;
    background: #fafafa;
}

@media (max-width: 1200px) {
  .dashboard-content-grid {
    grid-template-columns: 1fr;
  }
}
</style>
