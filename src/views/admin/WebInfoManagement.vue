<script setup>
import { ref, onMounted } from 'vue'
import { Globe, Plus, Edit, Trash2, X, Search, Save, Eye, EyeOff, AlertTriangle, Loader2, Facebook, Instagram, Mail, Phone, ExternalLink, Image as ImageIcon } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import companyContactApi from '@/api/companyContactApi'

const isLoading = ref(false)
const saving = ref(false)
const contacts = ref([])

const fetchData = async () => {
    isLoading.value = true
    try {
        const res = await companyContactApi.getAll()
        contacts.value = res.data || []
    } catch (error) {
        console.error('Error fetching web info:', error)
        contacts.value = []
    } finally { isLoading.value = false }
}

onMounted(fetchData)

const getVal = (key) => contacts.value.find(c => c.configKey === key)?.configValue || ''
const setVal = (key, val) => {
    const idx = contacts.value.findIndex(c => c.configKey === key)
    if (idx > -1) contacts.value[idx].configValue = val
    else contacts.value.push({ configKey: key, configValue: val, label: key, isActive: true })
}

const saveInfo = async () => {
    saving.value = true
    try {
        const results = await Promise.all(contacts.value.map(c => 
            companyContactApi.upsert({
                configKey: c.configKey,
                configValue: c.configValue,
                label: c.label,
                isActive: true
            })
        ))
        toast.success('Đã cập nhật thông tin thành công!')
        fetchData()
    } catch (error) {
        console.error('Error saving web info:', error)
        const msg = error.response?.data?.message || 'Có lỗi xảy ra khi lưu dữ liệu!'
        toast.error(msg)
    } finally { saving.value = false }
}

const iconMap = {
    hotline: Phone,
    phone: Phone,
    email: Mail,
    facebook_url: Facebook,
    fb: Facebook,
    instagram_url: Instagram,
    ig: Instagram,
    address: Info,
    zalo_url: ExternalLink
}
</script>

<template>
  <div class="admin-page animate-in">
    <div class="page-header">
      <div>
        <h2>Thông tin Website</h2>
        <p class="subtitle">Email, Hotline, Mạng xã hội & Logo</p>
      </div>
      <div class="page-actions">
        <button class="btn btn-primary" @click="saveInfo" :disabled="saving">
            <Loader2 v-if="saving" :size="16" class="spinner" /> <Save v-else :size="16" /> Lưu thay đổi
        </button>
      </div>
    </div>

    <div class="card" style="max-width:800px">
        <div v-if="isLoading" class="loading-overlay"><div class="spinner"></div></div>
        <div v-else class="modal-body p-4" style="display:flex; flex-direction:column; gap:1.5rem">
            <div class="section-title">
                <h4><Globe :size="18" /> Thông tin nhận diện & Liên hệ</h4>
            </div>

            <div class="form-group">
                <label><ImageIcon :size="14" /> URL Logo Trang web</label>
                <div style="display:flex; gap:1rem; align-items: flex-start">
                    <input :value="getVal('website_logo')" @input="e => setVal('website_logo', e.target.value)" class="form-control" style="flex:1" placeholder="https://..." />
                    <div v-if="getVal('website_logo')" class="logo-preview">
                        <img :src="getVal('website_logo')" alt="Logo Preview" style="max-height:40px; object-fit:contain" />
                    </div>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group flex-1">
                    <label><Phone :size="14" /> Số điện thoại / Hotline</label>
                    <input :value="getVal('hotline')" @input="e => setVal('hotline', e.target.value)" class="form-control" placeholder="0xxx..." />
                </div>
                <div class="form-group flex-1">
                    <label><Mail :size="14" /> Email liên hệ</label>
                    <input :value="getVal('email')" @input="e => setVal('email', e.target.value)" class="form-control" placeholder="contact@..." />
                </div>
            </div>

            <div class="form-group">
                <label>Địa chỉ trụ sở</label>
                <input :value="getVal('address')" @input="e => setVal('address', e.target.value)" class="form-control" placeholder="Số nhà, Tên đường, Quận, TP..." />
            </div>

            <div class="section-title mt-4">
                <h4><ExternalLink :size="18" /> Mạng xã hội & Liên kết</h4>
            </div>

            <div class="form-group">
                <label><Facebook :size="14" /> Facebook URL</label>
                <input :value="getVal('facebook_url')" @input="e => setVal('facebook_url', e.target.value)" class="form-control" placeholder="https://facebook.com/..." />
            </div>

            <div class="form-group">
                <label><Instagram :size="14" /> Instagram URL</label>
                <input :value="getVal('instagram_url')" @input="e => setVal('instagram_url', e.target.value)" class="form-control" placeholder="https://instagram.com/..." />
            </div>

            <div class="form-group">
                <label><ExternalLink :size="14" /> Zalo Link / Số Zalo</label>
                <input :value="getVal('zalo_url')" @input="e => setVal('zalo_url', e.target.value)" class="form-control" placeholder="https://zalo.me/..." />
            </div>

            <div class="form-group">
                <label>Google Maps Embed URL</label>
                <textarea :value="getVal('map_embed_url')" @input="e => setVal('map_embed_url', e.target.value)" class="form-control" rows="3" placeholder="iframe code hoặc URL map..."></textarea>
            </div>
        </div>
    </div>
  </div>
</template>

<style scoped>
.section-title h4 {
    display: flex; align-items: center; gap: 0.5rem;
    color: #1e293b; font-weight: 700; font-size: 1rem;
    border-bottom: 2px solid #818cf8; padding-bottom: 0.5rem;
}
.flex-1 { flex: 1; min-width: 250px; }
.form-group label {
    display: flex; align-items: center; gap: 0.4rem;
}
</style>
