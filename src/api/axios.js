import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || '/api',
  timeout: 15000
  // Không set Content-Type mặc định ở đây.
  // Axios sẽ tự set 'application/json' cho object/string,
  // và 'multipart/form-data; boundary=...' cho FormData.
})

// Request interceptor — attach JWT token
api.interceptors.request.use(config => {
  const token = localStorage.getItem('access_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Response interceptor — unwrap ApiResponse
api.interceptors.response.use(
  res => res.data, // { code, message, data }
  err => {
    const msg = err.response?.data?.message || err.message || 'Lỗi không xác định'
    return Promise.reject(new Error(msg))
  }
)

export default api
