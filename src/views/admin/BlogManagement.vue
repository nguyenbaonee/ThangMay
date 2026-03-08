<script setup>
import { Plus, Edit, Trash2 } from 'lucide-vue-next'
</script>

<template>
  <div class="blog-mgmt">
    <div class="header-row">
      <h2>Quản lý bài đăng (Blog/Dự án)</h2>
      <button class="btn btn-primary sm"><Plus :size="16" /> Viết bài mới</button>
    </div>

    <div class="content-card mt-4 p-0">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Tiêu đề bài viết</th>
                    <th>Danh mục</th>
                    <th>Ngày đăng</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Dự án Thang máy tại Landmark 81</td>
                    <td>Dự án</td>
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
