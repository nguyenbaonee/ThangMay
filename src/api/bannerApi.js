import api from './axios'

export const bannerApi = {
  getAll: () => api.get('/banners/admin'),
  getPublic: (position) => api.get('/banners', { params: { position } }),
  create: (data) => api.post('/banners', data),
  update: (id, data) => api.put(`/banners/${id}`, data),
  delete: (id) => api.delete(`/banners/${id}`),
}

export default bannerApi
