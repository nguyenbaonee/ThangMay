import api from './axios'

export const documentApi = {
  // Admin search
  search: (params = {}) => api.post('/documents/admin/search', {
    keyword: params.keyword || '',
    categoryId: params.categoryId || null,
    isPublic: params.isPublic ?? null,
    page: params.page ?? 0,
    size: params.size ?? 20
  }),

  getById: (id) => api.get(`/documents/${id}`),

  create: (data) => api.post('/documents', data),

  update: (id, data) => api.put(`/documents/${id}`, data),

  delete: (id) => api.delete(`/documents/${id}`),

  // Categories
  categories: () => api.get('/documents/categories'),
}

export default documentApi
