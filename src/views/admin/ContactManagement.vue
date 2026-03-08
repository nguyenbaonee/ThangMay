<script setup>
import { FileDown, Search, Eye, Check } from 'lucide-vue-next'
</script>

<template>
  <div class="contact-mgmt">
    <div class="header-row">
      <h2>Quản lý liên hệ & tư vấn</h2>
      <button class="btn btn-outline sm"><FileDown :size="16" /> Xuất Excel báo cáo</button>
    </div>

    <div class="content-card mt-4 p-0">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Khách hàng</th>
                    <th>Số điện thoại</th>
                    <th>Dịch vụ</th>
                    <th>Ngày yêu cầu</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Nguyễn Văn A</td>
                    <td>0912345678</td>
                    <td>Tư vấn lắp đặt</td>
                    <td>10/03/2024</td>
                    <td><span class="status-pill new">Chưa xử lý</span></td>
                    <td>
                        <div class="actions">
                            <button class="icon-btn sm"><Eye :size="14" /></button>
                            <button class="icon-btn sm success"><Check :size="14" /></button>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
  </div>
</template>

<style scoped>
.header-row { display: flex; justify-content: space-between; align-items: center; }
.actions { display: flex; gap: 0.5rem; }
.icon-btn.success:hover { color: #4caf50; border-color: #4caf50; }
.status-pill.new { background: #fff8e1; color: #ff8f00; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.75rem; font-weight: 700; }
.admin-table { width: 100%; border-collapse: collapse; }
.admin-table th, .admin-table td { padding: 1rem; border-bottom: 1px solid #eee; text-align: left; }
</style>
