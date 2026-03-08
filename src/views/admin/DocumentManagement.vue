<script setup>
import { Plus, Edit, Trash2, FileText } from 'lucide-vue-next'
</script>

<template>
  <div class="doc-mgmt">
    <div class="header-row">
      <h2>Quản lý tài liệu</h2>
      <button class="btn btn-primary sm"><Plus :size="16" /> Đăng tài liệu mới</button>
    </div>

    <div class="content-card mt-4 p-0">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Tên tài liệu</th>
                    <th>Loại</th>
                    <th>Ngày đăng</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Brochure 2024</td>
                    <td>Brochure</td>
                    <td>10/03/2024</td>
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
.header-row { display: flex; justify-content: space-between; align-items: center; }
.actions { display: flex; gap: 0.5rem; }
.admin-table { width: 100%; border-collapse: collapse; }
.admin-table th, .admin-table td { padding: 1rem; border-bottom: 1px solid #eee; text-align: left; }
</style>
