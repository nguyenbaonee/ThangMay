<script setup>
import { ref, onMounted } from 'vue'
import { Plus, Trash2, Mail, User, Shield, Loader2, Search, X, CheckCircle2 } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import userApi from '@/api/userApi'
import authApi from '@/api/authApi'

const users = ref([])
const isLoading = ref(true)
const showAddModal = ref(false)
const submittings = ref(false)

const newUser = ref({
  username: '',
  password: '',
  confirmPassword: '',
  email: '',
  fullname: '',
  role: 'EDITOR' // Mặc định tạo Editor
})

const fetchUsers = async () => {
    isLoading.value = true
    try {
        const res = await userApi.getAll()
        users.value = res.data || []
    } catch (error) {
        toast.error('Không thể tải danh sách người dùng!')
    } finally {
        isLoading.value = false
    }
}

const handleAddUser = async () => {
    if (newUser.value.password !== newUser.value.confirmPassword) {
        toast.error('Mật khẩu xác nhận không khớp!')
        return
    }

    submittings.value = true
    try {
        await authApi.register(newUser.value)
        toast.success('Đã thêm người dùng mới thành công!')
        showAddModal.value = false
        fetchUsers()
        // Reset form
        newUser.value = { username: '', password: '', confirmPassword: '', email: '', fullname: '', role: 'EDITOR' }
    } catch (error) {
        toast.error(error.response?.data?.message || 'Có lỗi xảy ra khi thêm người dùng!')
    } finally {
        submittings.value = false
    }
}

onMounted(fetchUsers)
</script>

<template>
  <div class="user-mgmt">
    <div class="page-header">
      <div>
        <h2>Quản lý Người dùng</h2>
        <p class="subtitle">Danh sách Admin & Biên tập viên hệ thống</p>
      </div>
      <button class="btn btn-primary" @click="showAddModal = true">
        <Plus :size="18" /> Thêm Editor mới
      </button>
    </div>

    <!-- Stats summary -->
    <div class="stats-row mb-4">
        <div class="stat-card glass">
            <div class="stat-icon"><Shield :size="20" /></div>
            <div class="stat-info">
                <div class="label">Tổng số</div>
                <div class="value">{{ users.length }} <span class="unit">n.dùng</span></div>
            </div>
        </div>
    </div>

    <!-- Table -->
    <div class="card overflow-hidden">
      <div v-if="isLoading" class="flex-center py-5">
          <Loader2 class="spinner text-primary" :size="48" />
      </div>
      <table v-else class="table">
        <thead>
          <tr>
            <th>Người dùng</th>
            <th>Email</th>
            <th>Quyền hạn</th>
            <th>Trạng thái</th>
            <th class="text-right">Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="u in users" :key="u.id">
            <td>
              <div class="user-cell">
                <div class="user-avatar-sm">{{ u.fullName?.substring(0,2).toUpperCase() }}</div>
                <div>
                    <div class="font-bold">{{ u.fullName }}</div>
                    <div class="text-xs text-muted">@{{ u.username }}</div>
                </div>
              </div>
            </td>
            <td class="text-muted">{{ u.email }}</td>
            <td>
              <span :class="['badge', (u.roles || []).some(r => typeof r === 'string' ? r.includes('ADMIN') : r.code === 'ADMIN') ? 'badge-primary' : 'badge-secondary']">
                {{ (u.roles || []).some(r => typeof r === 'string' ? r.includes('ADMIN') : r.code === 'ADMIN') ? 'Quản trị viên' : 'Biên tập viên' }}
              </span>
            </td>
            <td>
              <span class="status-active"><CheckCircle2 :size="14" /> Đang hoạt động</span>
            </td>
            <td class="text-right">
              <button class="btn-icon text-danger" title="Xóa" disabled>
                <Trash2 :size="18" />
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Add Modal -->
    <div v-if="showAddModal" class="modal-overlay">
        <div class="modal-content animate-in">
            <div class="modal-header">
                <h3>Thêm người dùng mới</h3>
                <button class="btn-close" @click="showAddModal = false"><X :size="20" /></button>
            </div>
            <form @submit.prevent="handleAddUser" class="modal-body p-4">
                <div class="form-row">
                    <div class="form-group">
                        <label>Họ và tên</label>
                        <input v-model="newUser.fullname" class="form-control" placeholder="Nguyễn Văn A" required />
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Tên đăng nhập</label>
                        <input v-model="newUser.username" class="form-control" placeholder="editor_01" required />
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input v-model="newUser.email" type="email" class="form-control" placeholder="email@example.com" required />
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Mật khẩu</label>
                        <input v-model="newUser.password" type="password" class="form-control" placeholder="••••••••" required />
                    </div>
                    <div class="form-group">
                        <label>Xác nhận mật khẩu</label>
                        <input v-model="newUser.confirmPassword" type="password" class="form-control" placeholder="••••••••" required />
                    </div>
                </div>
                <div class="form-group">
                    <label>Quyền hạn</label>
                    <select v-model="newUser.role" class="form-control">
                        <option value="EDITOR">Biên tập viên (Editor)</option>
                        <option value="ADMIN">Quản trị viên (Admin)</option>
                    </select>
                </div>

                <div class="modal-footer mt-4">
                    <button type="button" class="btn btn-outline" @click="showAddModal = false">Hủy</button>
                    <button type="submit" class="btn btn-primary" :disabled="submittings">
                        <Loader2 v-if="submittings" class="spinner" :size="16" /> Lưu người dùng
                    </button>
                </div>
            </form>
        </div>
    </div>
  </div>
</template>

<style scoped>
.user-cell { display: flex; align-items: center; gap: 1rem; }
.user-avatar-sm {
    width: 36px; height: 36px; background: #e2e8f0; border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-weight: 700; font-size: 0.8rem; color: #475569;
}
.badge {
    font-size: 0.75rem; padding: 0.25rem 0.6rem; border-radius: 20px; font-weight: 600;
}
.badge-primary { background: #dbeafe; color: #1d4ed8; }
.badge-secondary { background: #f1f5f9; color: #475569; }

.status-active {
    display: flex; align-items: center; gap: 0.4rem; color: #10b981; font-weight: 600; font-size: 0.85rem;
}

.stats-row { display: flex; gap: 1.5rem; }
.stat-card {
    background: #fff; padding: 1.5rem; border-radius: 16px; border: 1px solid #e2e8f0;
    display: flex; align-items: center; gap: 1rem; flex: 1; max-width: 280px;
}
.stat-icon {
    width: 44px; height: 44px; background: rgba(99, 102, 241, 0.1); color: #6366f1;
    border-radius: 12px; display: flex; align-items: center; justify-content: center;
}
.stat-info .label { font-size: 0.8rem; color: #64748b; font-weight: 600; }
.stat-info .value { font-size: 1.4rem; font-weight: 800; color: #1e293b; }
.stat-info .unit { font-size: 0.85rem; color: #94a3b8; font-weight: 400; }

.font-bold { font-weight: 700; color: #1e293b; }
.text-xs { font-size: 0.75rem; }
.text-muted { color: #64748b; }
.text-right { text-align: right; }

.form-row { display: flex; gap: 1rem; margin-bottom: 1rem; }
.form-row .form-group { flex: 1; }

.animate-in { animation: slideUp 0.3s ease-out; }
@keyframes slideUp { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
</style>
