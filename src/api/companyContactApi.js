import api from './axios'

export const companyContactApi = {
  getAll: () => api.get('/company-contacts/admin'),
  getPublic: () => api.get('/company-contacts'),
  upsert: (data) => api.post('/company-contacts', data),
  delete: (id) => api.delete(`/company-contacts/${id}`),
}

export default companyContactApi
