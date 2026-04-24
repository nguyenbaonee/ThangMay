import api from './axios'

export const categoryApi = {
  // Admin search
  search: (params = {}) => api.post('/product-categories/admin/search', {
    keyword: params.keyword || '',
    isActive: params.isActive ?? null,
    page: params.page ?? 0,
    size: params.size ?? 20
  }),

  // Public — active only
  listActive: () => api.get('/product-categories'),

  getById: (id) => api.get(`/product-categories/${id}`),

  create: (data) => api.post('/product-categories/admin/create', data),

  update: (id, data) => api.put(`/product-categories/admin/update/${id}`, data),

  delete: (id) => api.delete(`/product-categories/admin/delete/${id}`),

  toggleActive: (id, active) => api.patch(`/product-categories/admin/toggle-active/${id}/${active}`),
}

export default categoryApi
