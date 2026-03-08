<script setup>
import { Plus, Edit, Trash2 } from 'lucide-vue-next'
</script>

<template>
  <div class="product-mgmt">
    <div class="header-row">
      <h2>Quản lý sản phẩm</h2>
      <button class="btn btn-primary sm"><Plus :size="16" /> Thêm thang máy</button>
    </div>

    <div class="content-card mt-4 p-0">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Hình ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Danh mục</th>
                    <th>Giá</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><img src="/images/3653228387362596575.jpg" width="50" height="50" class="rounded" /></td>
                    <td>Thang máy gia đình</td>
                    <td>Home</td>
                    <td>Liên hệ</td>
                    <td>
                        <div class="actions">
                            <button class="icon-btn sm"><Edit :size="14" /></button>
                            <button class="icon-btn sm danger"><Trash2 :size="14" /></button>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
  </div>
</template>

<style scoped>
.header-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.actions {
    display: flex;
    gap: 0.5rem;
}
.icon-btn.danger:hover {
    color: #ef5350;
    border-color: #ef5350;
}
.admin-table { width: 100%; border-collapse: collapse; }
.admin-table th, .admin-table td { padding: 1rem; border-bottom: 1px solid #eee; text-align: left; }
</style>
