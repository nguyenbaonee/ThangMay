import api from './axios'

export const documentApi = {
  // Public list
  getPublic: (params = {}) => api.get('/documents', {
    params: {
      categoryId: params.categoryId || null,
      isPublic: params.isPublic ?? true,
      page: params.page ?? 0,
      size: params.size ?? 20
    }
  }),

  // Admin search
  searchAdmin: (params = {}) => api.post('/documents/admin/search', {
    keyword: params.keyword || '',
    categoryId: params.categoryId || null,
    isPublic: params.isPublic ?? null,
    page: params.page ?? 0,
    size: params.size ?? 20
  }),

  getById: (id) => api.get(`/documents/${id}`),

  recordDownload: (id) => api.post(`/documents/${id}/download`),

  create: (data) => api.post('/documents', data),

  update: (id, data) => api.put(`/documents/${id}`, data),

  delete: (id) => api.delete(`/documents/${id}`),

  // Categories
  categories: () => api.get('/documents/categories'),
}

export default documentApi
