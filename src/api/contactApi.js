import api from './axios'

export const contactApi = {
  create: (data) => api.post('/contacts', data),

  // Admin search
  search: (params = {}) => api.post('/contacts/search', {
    keyword: params.keyword || '',
    status: params.status || null,
    from: params.from || null,
    to: params.to || null,
    page: params.page ?? 0,
    size: params.size ?? 20
  }),

  getById: (id) => api.get(`/contacts/${id}`),

  updateStatus: (id, data) => api.patch(`/contacts/${id}/status`, data),

  export: (status) => api.get('/contacts/export', {
    params: status ? { status } : {},
    responseType: 'blob'
  }),

  dashboard: () => api.get('/contacts/dashboard'),
}

export default contactApi
