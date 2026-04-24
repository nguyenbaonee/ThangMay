import api from './axios'

const dashboardApi = {
  getStats: () => api.get('/admin/dashboard/stats')
}

export default dashboardApi
