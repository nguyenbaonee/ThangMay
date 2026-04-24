import api from './axios'

export default {
  getAll: () => api.get('/admin/users'),
}
