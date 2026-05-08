import api from './axios'

export const productApi = {
  // Public search
  publicSearch: (params = {}) => api.post('/products/search', {
    keyword:    params.keyword    || '',
    categoryId: params.categoryId || null,
    featured:   params.featured   ?? null,
    isActive:   true,
    page:       params.page       ?? 0,
    size:       params.size       ?? 20,
    // Spec filters
    loadMin:  params.loadMin  ?? null,
    loadMax:  params.loadMax  ?? null,
    speedMin: params.speedMin ?? null,
    speedMax: params.speedMax ?? null,
  }),

  // Admin search
  search: (params = {}) => api.post('/products/admin', {
    keyword: params.keyword || '',
    categoryId: params.categoryId || null,
    isActive: params.isActive ?? null,
    featured: params.featured ?? null,
    page: params.page ?? 0,
    size: params.size ?? 20
  }),

  featured: () => api.get('/products/featured'),
  getBySlug: (slug) => api.get(`/products/${slug}`),
  getById: (id) => api.get(`/products/id/${id}`),

  create: (data) => api.post('/products', data),

  update: (id, data) => api.put(`/products/${id}`, data),

  delete: (id) => api.delete(`/products/${id}`),

  toggleActive: (id, active) => api.patch(`/products/${id}/toggle-active?active=${active}`),

  toggleFeatured: (id, featured) => api.patch(`/products/${id}/toggle-featured?featured=${featured}`),
}

export default productApi
