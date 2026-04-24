import api from './axios'

export const postApi = {
  // Admin search
  search: (params = {}) => api.post('/posts/admin', {
    keyword: params.keyword || '',
    type: params.type || null,
    status: params.status || null,
    categoryId: params.categoryId || null,
    featured: params.featured ?? null,
    page: params.page ?? 0,
    size: params.size ?? 20
  }),

  getBySlug: (slug) => api.get(`/posts/${slug}`),

  create: (data) => api.post('/posts', data),

  update: (id, data) => api.put(`/posts/${id}`, data),

  delete: (id) => api.delete(`/posts/${id}`),

  publish: (id) => api.patch(`/posts/${id}/publish`),

  archive: (id) => api.patch(`/posts/${id}/archive`),

  // Categories
  categories: () => api.get('/posts/categories'),
}

export default postApi
