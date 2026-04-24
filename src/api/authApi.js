import api from './axios'

export const authApi = {
  login: (data) => api.post('/auth/login', data),
  logout: (refreshToken) => api.post(`/auth/logout?refreshToken=${refreshToken}`),
  refresh: (refreshToken) => api.post(`/auth/refresh?refreshToken=${refreshToken}`)
}

export default authApi
