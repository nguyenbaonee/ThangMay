import api from './axios'

export const mediaApi = {
  uploadSingle: (file, folder = 'general') => {
    const formData = new FormData()
    formData.append('file', file)
    
    return api.post(`/media/upload/single?folder=${folder}`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  },

  uploadMultiple: (files, folder = 'general') => {
    const formData = new FormData()
    for (let i = 0; i < files.length; i++) {
        formData.append('files', files[i])
    }
    
    return api.post(`/media/upload?folder=${folder}`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  },

  delete: (id) => api.delete(`/media/${id}`)
}

export default mediaApi
