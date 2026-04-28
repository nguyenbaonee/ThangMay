import api from './axios'

export default {
  getAll: (params) => api.get('/admin/users', { params }),
  update: (id, data) => api.put(`/admin/users/${id}`, data),
  toggleActive: (id, active) => api.patch(`/admin/users/${id}/active?active=${active}`),
  delete: (id) => api.delete(`/admin/users/${id}`),
}
