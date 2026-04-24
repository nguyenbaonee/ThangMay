<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { Lock, User, Loader2, Eye, EyeOff } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import authApi from '@/api/authApi'

const router = useRouter()
const isLoading = ref(false)
const showPassword = ref(false)

const form = ref({
  username: '',
  password: ''
})

const handleLogin = async () => {
  if (!form.value.username || !form.value.password) {
    toast.error('Vui lòng nhập đầy đủ tài khoản và mật khẩu')
    return
  }

  isLoading.value = true
  try {
    const res = await authApi.login(form.value)
    
    // Save to localStorage
    localStorage.setItem('access_token', res.data.accessToken)
    localStorage.setItem('refresh_token', res.data.refreshToken)
    localStorage.setItem('user', JSON.stringify(res.data.user))
    
    toast.success('Đăng nhập thành công!')
    router.push('/admin')
  } catch (error) {
    console.error('Login error:', error)
    toast.error(error.message || 'Tài khoản hoặc mật khẩu không chính xác')
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div class="login-page">
    <div class="login-card animate-in">
      <div class="login-header">
        <div class="logo-box">
          <span class="logo-icon">E</span>
        </div>
        <h1>Hệ thống Quản trị</h1>
        <p>Vui lòng đăng nhập để tiếp tục</p>
      </div>

      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-group">
          <label><User :size="16" /> Tên đăng nhập</label>
          <div class="input-wrapper">
            <input 
              v-model="form.username" 
              type="text" 
              class="form-control" 
              placeholder="admin" 
              autocomplete="username"
            />
          </div>
        </div>

        <div class="form-group">
          <label><Lock :size="16" /> Mật khẩu</label>
          <div class="input-wrapper">
            <input 
              v-model="form.password" 
              :type="showPassword ? 'text' : 'password'" 
              class="form-control" 
              placeholder="••••••••"
              autocomplete="current-password"
            />
            <button type="button" class="toggle-pass" @click="showPassword = !showPassword">
              <Eye v-if="!showPassword" :size="18" />
              <EyeOff v-else :size="18" />
            </button>
          </div>
        </div>

        <button type="submit" class="btn btn-primary btn-block" :disabled="isLoading">
          <Loader2 v-if="isLoading" class="spinner" :size="18" />
          <span v-else>Đăng nhập ngay</span>
        </button>
      </form>

      <div class="login-footer">
        <router-link to="/">← Quay lại trang chủ</router-link>
      </div>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
  padding: 1.5rem;
  font-family: 'Inter', sans-serif;
}

.login-card {
  background: #fff;
  width: 100%;
  max-width: 420px;
  border-radius: 20px;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  padding: 2.5rem;
}

.login-header {
  text-align: center;
  margin-bottom: 2rem;
}

.logo-box {
  width: 60px;
  height: 60px;
  background: #4f46e5;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1.25rem;
  box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.3);
}

.logo-icon {
  color: #fff;
  font-size: 2rem;
  font-weight: 800;
}

.login-header h1 {
  font-size: 1.5rem;
  font-weight: 800;
  color: #1e293b;
  margin: 0 0 0.5rem;
}

.login-header p {
  color: #64748b;
  font-size: 0.9rem;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  font-size: 0.85rem;
  font-weight: 600;
  color: #475569;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.input-wrapper {
  position: relative;
}

.form-control {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  font-size: 1rem;
  transition: all 0.2s;
  outline: none;
}

.form-control:focus {
  border-color: #4f46e5;
  box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
}

.toggle-pass {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #94a3b8;
  cursor: pointer;
  display: flex;
  align-items: center;
  transition: color 0.2s;
}

.toggle-pass:hover {
  color: #4f46e5;
}

.btn-block {
  width: 100%;
  padding: 0.85rem;
  font-size: 1rem;
  font-weight: 700;
  margin-top: 0.5rem;
}

.login-footer {
  margin-top: 2rem;
  text-align: center;
}

.login-footer a {
  color: #64748b;
  font-size: 0.85rem;
  text-decoration: none;
  transition: color 0.2s;
}

.login-footer a:hover {
  color: #4f46e5;
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.animate-in {
  animation: slideUp 0.4s ease-out;
}

@keyframes slideUp {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
