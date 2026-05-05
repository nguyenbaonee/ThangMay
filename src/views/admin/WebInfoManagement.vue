<script setup>
import { ref, onMounted } from 'vue'
import { Globe, Save, Loader2, Facebook, Instagram, Mail, Phone, ExternalLink, Image as ImageIcon, Info } from 'lucide-vue-next'
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

            <div class="form-row">
                <div class="form-group flex-1">
                    <label>Tên công ty (Hiển thị ở Footer)</label>
                    <input :value="getVal('company_name')" @input="e => setVal('company_name', e.target.value)" class="form-control" placeholder="CÔNG TY CỔ PHẦN..." />
                </div>
                <div class="form-group flex-1">
                    <label>Mã số thuế (MST)</label>
                    <input :value="getVal('mst')" @input="e => setVal('mst', e.target.value)" class="form-control" placeholder="0123456789..." />
                </div>
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
.admin-page {
    padding: 0.5rem 0 1rem;
}

.page-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;
    margin-bottom: 1rem;
}

.page-header h2 {
    font-size: 1.75rem;
    margin: 0;
}

.page-header .subtitle {
    margin-top: 0.35rem;
    font-size: 0.95rem;
}

.page-actions .btn {
    min-height: 44px;
    padding: 0.7rem 1.2rem;
}

.card {
    max-width: 800px;
    border-radius: 18px;
}

.modal-body {
    gap: 1.25rem !important;
}

.section-title h4 {
    display: flex; align-items: center; gap: 0.5rem;
    color: #1e293b; font-weight: 700; font-size: 0.98rem;
    border-bottom: 2px solid #818cf8; padding-bottom: 0.45rem;
}
.flex-1 { flex: 1; min-width: 220px; }
.form-group label {
    display: flex; align-items: center; gap: 0.4rem;
    margin-bottom: 0.45rem;
    font-size: 0.95rem;
}

.form-control {
    width: 100%;
    min-height: 42px;
    border: 1px solid #dbe3ef;
    border-radius: 12px;
    padding: 0.75rem 0.95rem;
    background: #fff;
}

.form-row {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
}

.form-group {
    margin-bottom: 0.25rem;
}

.logo-preview {
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 72px;
    padding: 0.35rem 0.5rem;
    border-radius: 10px;
    background: #f8fafc;
    border: 1px solid #e5e7eb;
}

.loading-overlay {
    min-height: 260px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.spinner {
    width: 28px;
    height: 28px;
    border-radius: 50%;
    border: 3px solid #cbd5e1;
    border-top-color: #6366f1;
    animation: spin 0.8s linear infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

@media (max-width: 768px) {
    .admin-page {
        padding: 0.15rem 0 0.5rem;
    }

    .page-header {
        align-items: flex-start;
        flex-direction: column;
        gap: 0.35rem;
        margin-bottom: 0.7rem;
    }

    .page-header h2 {
        font-size: 1.2rem;
        line-height: 1.2;
    }

    .page-header .subtitle {
        font-size: 0.82rem;
    }

    .card {
        border-radius: 12px;
    }

    .modal-body {
        padding: 0.85rem !important;
        gap: 0.85rem !important;
    }

    .section-title h4 {
        font-size: 0.88rem;
    }

    .form-row {
        gap: 0.7rem;
    }

    .flex-1 {
        min-width: 100%;
    }

    .form-control {
        min-height: 38px;
        border-radius: 10px;
        padding: 0.65rem 0.8rem;
        font-size: 0.92rem;
    }

    .logo-preview {
        min-width: 64px;
    }

    .page-actions .btn {
        width: 100%;
        min-height: 40px;
        padding: 0.6rem 1rem;
    }

    .section-title.mt-4 {
        margin-top: 0.75rem !important;
    }

    .logo-preview {
        display: none;
    }
}
</style>
