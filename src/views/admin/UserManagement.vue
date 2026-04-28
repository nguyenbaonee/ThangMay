<script setup>
import { ref, onMounted } from 'vue'
import { Plus, Trash2, Mail, User, Shield, Loader2, Search, X, CheckCircle2, TrendingUp, Filter, Pencil, UserPlus } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import userApi from '@/api/userApi'
import authApi from '@/api/authApi'

const users = ref([])
const isLoading = ref(true)
const showAddModal = ref(false)
const submittings = ref(false)

const initialUserForm = {
  username: '',
  password: '',
  confirmPassword: '',
  email: '',
  fullname: '',
  role: 'EDITOR'
}

const userForm = ref({ ...initialUserForm })
const isEdit = ref(false)
const editingId = ref(null)

const showFilters = ref(false)
const filters = ref({
    role: '',
    sort: 'desc'
})

const fetchUsers = async () => {
    isLoading.value = true
    try {
        const res = await userApi.getAll({
            role: filters.value.role || undefined,
            sort: filters.value.sort
        })
        users.value = res.data || []
    } catch (error) {
        toast.error('Không thể tải danh sách tài khoản!')
    } finally {
        isLoading.value = false
    }
}

const openAddModal = () => {
    isEdit.value = false
    editingId.value = null
    userForm.value = { ...initialUserForm }
    showAddModal.value = true
}

const openEditModal = (user) => {
    isEdit.value = true
    editingId.value = user.id
    // Map backend roles to local role if necessary
    const roleCode = (user.roles || []).some(r => typeof r === 'string' ? r.includes('ADMIN') : r.code === 'ADMIN') ? 'ADMIN' : 'EDITOR'
    
    userForm.value = {
        username: user.username,
        fullname: user.fullName,
        email: user.email,
        role: roleCode,
        password: '', // Không sửa mật khẩu ở đây mặc định
        confirmPassword: ''
    }
    showAddModal.value = true
}

const closeAddModal = () => {
    showAddModal.value = false
    if (!submittings.value) {
        userForm.value = { ...initialUserForm }
        isEdit.value = false
        editingId.value = null
    }
}

const handleSubmit = async () => {
    if (!isEdit.value) {
        // Validation cho Thêm mới
        if (userForm.value.password !== userForm.value.confirmPassword) {
            toast.error('Mật khẩu xác nhận không khớp!')
            return
        }

        if (userForm.value.password.length < 8 || !/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$/.test(userForm.value.password)) {
            toast.error('Mật khẩu cần ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số!')
            return
        }
    } else {
        // Validation cho Cập nhật (nếu có đổi pass)
        if (userForm.value.password && userForm.value.password !== userForm.value.confirmPassword) {
            toast.error('Mật khẩu xác nhận không khớp!')
            return
        }
    }

    submittings.value = true
    try {
        if (isEdit.value) {
            await userApi.update(editingId.value, userForm.value)
            toast.success('Đã cập nhật tài khoản thành công!')
        } else {
            await authApi.register(userForm.value)
            toast.success('Đã thêm tài khoản thành công!')
        }
        closeAddModal()
        fetchUsers()
    } catch (error) {
        toast.error(error.response?.data?.message || 'Có lỗi xảy ra!')
    } finally {
        submittings.value = false
    }
}

const handleDeleteUser = async (userId) => {
    try {
        await userApi.delete(userId)
        toast.success('Đã xóa tài khoản!')
        fetchUsers()
    } catch (error) {
        toast.error('Không thể xóa tài khoản!')
    }
}

const toggleUserStatus = async (user) => {
    try {
        await userApi.toggleActive(user.id, !(user.isActive !== false))
        toast.success('Đã cập nhật trạng thái!')
        fetchUsers()
    } catch (error) {
        toast.error('Không thể cập nhật trạng thái!')
    }
}

onMounted(fetchUsers)
</script>

<template>
  <div class="admin-page user-mgmt">
    <div class="page-header">
      <div>
        <h2>Quản lý Nhân viên</h2>
        <p class="subtitle">Danh sách Admin & Nhân viên hệ thống</p>
      </div>
      <button class="btn btn-gold" @click="openAddModal">
        <Plus :size="18" /> Thêm Tài khoàn nhân viên
      </button>
    </div>

    <!-- Premium Stats Card -->
    <div class="stats-card-premium mb-6">
        <div class="stats-content">
            <p class="stats-label">Tổng số tài khoản</p>
            <h1 class="stats-value">{{ users.length.toLocaleString() }}</h1>
            <div class="stats-badge">
                <span>+12% tháng này</span>
                <TrendingUp :size="14" />
            </div>
        </div>
    </div>

    <!-- Main Action Button -->
    <button class="btn-add-premium mb-6" @click="openAddModal">
        <UserPlus :size="20" /> Thêm tài khoản nhân viên mới
    </button>

    <!-- Header Section -->
    <div class="section-header mb-4">
        <h3>Danh sách tài khoản</h3>
        <button :class="['btn-filter', { active: showFilters }]" @click="showFilters = !showFilters">
            <Filter :size="18" /> Lọc
        </button>
    </div>

    <!-- Filters Bar -->
    <div v-if="showFilters" class="filters-wrapper animate-in mb-6">
        <div class="filters-container">
            <div class="filter-group">
                <label>Quyền hạn</label>
                <select v-model="filters.role" @change="fetchUsers" class="filter-control">
                    <option value="">Tất cả quyền hạn</option>
                    <option value="ADMIN">Quản trị viên</option>
                    <option value="EDITOR">Biên tập viên</option>
                </select>
            </div>
            <div class="filter-group">
                <label>Sắp xếp thời gian</label>
                <select v-model="filters.sort" @change="fetchUsers" class="filter-control">
                    <option value="desc">Mới nhất trước</option>
                    <option value="asc">Cũ nhất trước</option>
                </select>
            </div>
        </div>
    </div>

    <!-- Users List (Cards) -->
    <div class="users-list">
        <div v-if="isLoading" class="flex-center py-10">
            <Loader2 class="spinner" :size="40" />
        </div>
        <template v-else>
            <div v-for="u in users" :key="u.id" class="user-card-premium mb-3">
                <div class="user-card-main">
                    <div class="user-avatar-lg" v-if="u.avatarUrl">
                        <img :src="u.avatarUrl" alt="Avatar" />
                    </div>
                    <div class="user-avatar-lg" v-else>
                        {{ u.fullName?.substring(0,2).toUpperCase() }}
                    </div>
                    
                    <div class="user-info-box">
                        <div class="user-name-row">
                            <h4 class="user-name">{{ u.fullName }}</h4>
                            <span :class="['status-badge', u.isActive !== false ? 'active' : 'locked']" @click="toggleUserStatus(u)" style="cursor:pointer">
                                {{ u.isActive !== false ? 'HOẠT ĐỘNG' : 'KHÓA' }}
                            </span>
                        </div>
                        <p class="user-email text-muted">{{ u.email }}</p>
                        <span :class="['role-badge', (u.roles || []).some(r => typeof r === 'string' ? r.includes('ADMIN') : r.code === 'ADMIN') ? 'admin' : 'editor']">
                            {{ (u.roles || []).some(r => typeof r === 'string' ? r.includes('ADMIN') : r.code === 'ADMIN') ? 'Admin' : 'Editor' }}
                        </span>
                    </div>
                </div>
                
                <div class="user-card-actions">
                    <button class="action-icon-btn" title="Chỉnh sửa" @click="openEditModal(u)">
                        <Pencil :size="18" />
                    </button>
                    <button class="action-icon-btn delete" title="Xóa" @click="handleDeleteUser(u.id)">
                        <Trash2 :size="18" />
                    </button>
                </div>
            </div>
        </template>
    </div>

    <!-- Inline Add Form -->
    <div v-if="showAddModal" class="modal-overlay" @click.self="closeAddModal">
      <div class="modal-box user-modal animate-in">
        <div class="form-header">
            <h3>{{ isEdit ? 'Chỉnh sửa tài khoản' : 'Thêm tài khoản mới' }}</h3>
            <button class="close-btn" @click="closeAddModal"><X :size="20" /></button>
        </div>
        <form @submit.prevent="handleSubmit" class="form-content">
            <div class="form-group mb-4">
                <label>Họ và tên <span class="text-danger">*</span></label>
                <input v-model="userForm.fullname" class="form-control" placeholder="Nguyễn Văn A" required />
            </div>

            <div class="form-row mb-4">
                <div class="form-group">
                    <label>Tên đăng nhập <span class="text-danger">*</span></label>
                    <input v-model="userForm.username" class="form-control" placeholder="editor_01" required :disabled="isEdit" />
                </div>
                <div class="form-group">
                    <label>Email <span class="text-danger">*</span></label>
                    <input v-model="userForm.email" type="email" class="form-control" placeholder="email@example.com" required />
                </div>
            </div>

            <div class="form-row mb-4">
                <div class="form-group">
                    <label>Mật khẩu <span v-if="!isEdit" class="text-danger">*</span></label>
                    <input v-model="userForm.password" type="password" class="form-control" placeholder="••••••••" :required="!isEdit" />
                    <p v-if="isEdit" class="text-xs text-muted mt-1">Để trống nếu không muốn đổi mật khẩu</p>
                </div>
                <div class="form-group">
                    <label>Xác nhận mật khẩu <span v-if="!isEdit" class="text-danger">*</span></label>
                    <input v-model="userForm.confirmPassword" type="password" class="form-control" placeholder="••••••••" :required="!isEdit" />
                </div>
            </div>

            <div class="form-group mb-4">
                <label>Quyền hạn</label>
                <div class="radio-group">
                    <label class="radio-item">
                        <input type="radio" value="EDITOR" v-model="userForm.role" />
                        <span class="radio-mark"></span> Biên tập viên
                    </label>
                    <label class="radio-item disabled-option" title="Tính năng có thể nâng cấp">
                        <input type="radio" value="ADMIN" v-model="userForm.role" disabled />
                        <span class="radio-mark"></span> Quản trị viên
                    </label>
                </div>
            </div>

            <div class="form-actions">
                <button type="button" class="btn btn-outline" @click="closeAddModal">Hủy bỏ</button>
                <button type="submit" class="btn btn-gold" :disabled="submittings">
                    <Loader2 v-if="submittings" class="loading-spinner" :size="16" /> {{ isEdit ? 'Cập nhật' : 'Lưu tài khoản' }}
                </button>
            </div>
        </form>
      </div>
    </div>
  </div>
</template>

<style scoped>
.admin-page {
  background: #f8fafc;
  min-height: 100vh;
}

/* Premium Stats Card */
.stats-card-premium {
    background: linear-gradient(135deg, #1d4ed8 0%, #1e40af 100%);
    border-radius: 20px;
    padding: 1.5rem 2rem;
    color: #fff;
    box-shadow: 0 10px 20px rgba(29, 78, 216, 0.2);
}

.stats-label {
    font-size: 1.1rem;
    opacity: 0.8;
    margin-bottom: 0.5rem;
}

.stats-value {
    font-size: 2.5rem;
    font-weight: 700;
    margin-bottom: 1rem;
}

.stats-badge {
    background: rgba(255, 255, 255, 0.2);
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.4rem 0.8rem;
    border-radius: 30px;
    font-size: 0.85rem;
}

/* Action Button */
.btn-add-premium {
    width: 100%;
    background: #003380;
    color: #fff;
    border: none;
    padding: 1.2rem;
    border-radius: 12px;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.75rem;
    cursor: pointer;
    transition: 0.2s;
    box-shadow: 0 4px 12px rgba(0, 51, 128, 0.15);
}

.btn-add-premium:hover {
    background: #002660;
    transform: translateY(-2px);
}

/* Section Header */
.section-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
}
.section-header h3 {
    font-size: 1.2rem;
    font-weight: 700;
    color: #1e293b;
}
.btn-filter {
    background: transparent;
    border: none;
    color: #475569;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 0.4rem;
    cursor: pointer;
    transition: 0.2s;
    padding: 0.5rem 0.75rem;
    border-radius: 8px;
}
.btn-filter:hover {
    background: #f1f5f9;
    color: #1d4ed8;
}
.btn-filter.active {
    background: #eff6ff;
    color: #1d4ed8;
}

/* Filters Bar */
.filters-wrapper {
    background: #fff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 1rem;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
}

.filters-container {
    display: flex;
    gap: 1.5rem;
    flex-wrap: wrap;
}

.filter-group {
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
    min-width: 200px;
    flex: 1;
}

.filter-group label {
    font-size: 0.8rem;
    font-weight: 600;
    color: #64748b;
    text-transform: uppercase;
    letter-spacing: 0.025em;
}

.filter-control {
    padding: 0.5rem 0.75rem;
    border: 1.5px solid #e2e8f0;
    border-radius: 8px;
    font-size: 0.9rem;
    color: #334155;
    outline: none;
    transition: 0.2s;
    background-color: #f8fafc;
}

.filter-control:focus {
    border-color: #1d4ed8;
    background-color: #fff;
    box-shadow: 0 0 0 3px rgba(29, 78, 216, 0.1);
}

.modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(15, 23, 42, 0.45);
    backdrop-filter: blur(6px);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 1.5rem;
    z-index: 1000;
}

.modal-box.user-modal {
    width: min(760px, 100%);
    max-height: calc(100vh - 3rem);
    overflow-y: auto;
    background: #fff;
    border-radius: 24px;
    box-shadow: 0 24px 60px rgba(15, 23, 42, 0.18);
    padding: 1.5rem;
}

.form-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 1.25rem;
}

.form-header h3 {
    margin: 0;
    font-size: 1.4rem;
    font-weight: 700;
    color: #0f172a;
}

.close-btn {
    width: 40px;
    height: 40px;
    border: none;
    border-radius: 999px;
    background: #f8fafc;
    color: #475569;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: 0.2s;
}

.close-btn:hover {
    background: #e2e8f0;
    color: #0f172a;
}

.form-content {
    display: flex;
    flex-direction: column;
}

.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 0.75rem;
    margin-top: 0.5rem;
}

/* User Card */
.user-card-premium {
    background: #fff;
    border-radius: 16px;
    padding: 1.25rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
    border: 1px solid #f1f5f9;
}

.user-card-main {
    display: flex;
    align-items: center;
    gap: 1.25rem;
}

.user-avatar-lg {
    width: 64px;
    height: 64px;
    border-radius: 50%;
    background: #e2e8f0;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 1.2rem;
    color: #1d4ed8;
    overflow: hidden;
}
.user-avatar-lg img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.user-info-box {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
}

.user-name-row {
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.user-name {
    margin: 0;
    font-size: 1.15rem;
    font-weight: 700;
    color: #1e293b;
}

.status-badge {
    padding: 0.2rem 0.6rem;
    border-radius: 6px;
    font-size: 0.7rem;
    font-weight: 800;
}
.status-badge.active {
    background: #ecfdf5;
    color: #10b981;
}
.status-badge.locked {
    background: #f1f5f9;
    color: #64748b;
}

.user-email {
    font-size: 0.95rem;
    margin: 0;
}

.role-badge {
    display: inline-block;
    padding: 0.2rem 0.75rem;
    border-radius: 10px;
    font-size: 0.8rem;
    font-weight: 600;
    width: fit-content;
}
.role-badge.admin {
    background: #eff6ff;
    color: #1d4ed8;
}
.role-badge.editor {
    background: #f1f5f9;
    color: #475569;
}

/* User Card Actions */
.user-card-actions {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
}

.action-icon-btn {
    background: transparent;
    border: none;
    color: #94a3b8;
    cursor: pointer;
    transition: 0.2s;
    padding: 0.25rem;
}
.action-icon-btn:hover {
    color: #1d4ed8;
    background: #f1f5f9;
    border-radius: 4px;
}
.action-icon-btn.delete:hover {
    color: #ef4444;
}

.mb-3 { margin-bottom: 0.75rem; }
.mb-6 { margin-bottom: 1.5rem; }
.py-10 { padding-top: 2.5rem; padding-bottom: 2.5rem; }

.flex-center { display: flex; align-items: center; justify-content: center; }
.spinner { animation: spin 1s linear infinite; color: #1d4ed8; }
@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }

/* Radio Group Styling with Blue (matches new stats card) */
.radio-group {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.radio-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  cursor: pointer;
  position: relative;
  font-size: 0.95rem;
  color: #475569;
}

.radio-item input {
  position: absolute;
  opacity: 0;
  cursor: pointer;
  height: 0;
  width: 0;
}

.radio-item.disabled-option {
  cursor: not-allowed;
  opacity: 0.6;
}

.radio-mark {
  width: 18px;
  height: 18px;
  border: 2px solid #cbd5e1;
  border-radius: 50%;
  position: relative;
  transition: 0.2s;
  flex-shrink: 0;
}

.radio-item input:checked + .radio-mark {
  border-color: #1d4ed8;
}

.radio-item input:checked + .radio-mark::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 10px;
  height: 10px;
  background: #1d4ed8;
  border-radius: 50%;
}

.mb-4 { margin-bottom: 1rem; }

@media (max-width: 768px) {
    .modal-overlay {
        padding: 1rem;
        align-items: flex-start;
    }

    .modal-box.user-modal {
        margin-top: 1rem;
        padding: 1.1rem;
        border-radius: 18px;
    }

    .form-header h3 {
        font-size: 1.2rem;
    }

    .form-actions {
        flex-direction: column-reverse;
    }

    .form-actions .btn {
        width: 100%;
    }
}
</style>
