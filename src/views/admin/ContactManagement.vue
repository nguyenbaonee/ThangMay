<script setup>
import { ref, onMounted, computed } from 'vue'
import { Search, Eye, CheckCircle, Trash2, X, AlertTriangle, Phone, Calendar, MessageSquare, User, FileDown } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import contactApi from '@/api/contactApi'

const isLoading = ref(false)
const searchQuery = ref('')
const contacts = ref([])

const isViewOpen = ref(false)
const isConfirmOpen = ref(false)
const targetDeleteId = ref(null)
const activeContact = ref(null)

const fetchData = async () => {
  isLoading.value = true
  try {
    const res = await contactApi.search({ keyword: searchQuery.value })
    contacts.value = res?.data?.content || res?.data || []
  } catch (error) {
    console.error('Error fetching contacts:', error)
    contacts.value = []
  } finally { isLoading.value = false }
}
onMounted(fetchData)

const filtered = computed(() => {
  if (!searchQuery.value) return contacts.value
  const q = searchQuery.value.toLowerCase()
  return contacts.value.filter(c => c.fullName?.toLowerCase().includes(q) || c.phone?.includes(searchQuery.value))
})

const statusLabel = (s) => ({ NEW: 'Chưa xử lý', IN_PROGRESS: 'Đang xử lý', COMPLETED: 'Đã phản hồi', CANCELLED: 'Đã huỷ' })[s] || s
const statusClass = (s) => ({ NEW: 'badge-new', IN_PROGRESS: 'badge-progress', COMPLETED: 'badge-done' })[s] || 'badge-inactive'

const openView = (c) => { activeContact.value = c; isViewOpen.value = true }
const closeView = () => { isViewOpen.value = false; activeContact.value = null }

const toggleStatus = async (c) => {
  const newStatus = c.status === 'COMPLETED' ? 'NEW' : 'COMPLETED'
  try { await contactApi.updateStatus(c.id, { status: newStatus }) } catch {}
  c.status = newStatus
  toast.success(`Đã chuyển: ${statusLabel(newStatus)}`)
}

const triggerDelete = (id) => { targetDeleteId.value = id; isConfirmOpen.value = true }
const confirmDelete = async () => {
  try {
    await contactApi.delete(targetDeleteId.value)
    contacts.value = contacts.value.filter(c => c.id !== targetDeleteId.value)
    toast.success('Đã xoá liên hệ!')
  } catch (error) {
    toast.error(error.response?.data?.message || 'Không thể xoá liên hệ!')
  } finally {
    isConfirmOpen.value = false
  }
}

const exportExcel = async () => {
  try {
    const blob = await contactApi.export()
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a'); a.href = url; a.download = 'contacts.xlsx'; a.click()
    toast.success('Đã xuất file!')
  } catch { toast.info('Chức năng export cần BE chạy.') }
}
</script>

<template>
  <div class="admin-page animate-in">
    <div class="page-header">
      <div><h2>Yêu cầu Liên hệ</h2><p class="subtitle">Quản lý phản hồi khách hàng</p></div>
      <div class="page-actions">
        <div class="search-wrapper"><Search :size="16" class="search-icon" /><input v-model="searchQuery" placeholder="Tìm tên, SĐT..." /></div>
        <button class="btn btn-outline" @click="exportExcel"><FileDown :size="16" /> Xuất Excel</button>
      </div>
    </div>

    <div class="card">
      <div v-if="isLoading" class="loading-overlay"><div class="spinner"></div></div>
      <div v-else class="table-wrap">
        <table class="data-table">
          <thead><tr>
            <th>Khách hàng</th><th>SĐT</th><th>Chủ đề</th>
            <th style="width:100px">Ngày gửi</th>
            <th class="text-center" style="width:110px">Trạng thái</th>
            <th class="text-right" style="width:120px">Thao tác</th>
          </tr></thead>
          <tbody>
            <tr v-if="filtered.length === 0"><td colspan="6"><div class="empty-state"><p>Chưa có liên hệ nào</p></div></td></tr>
            <tr v-for="c in filtered" :key="c.id">
              <td><span class="font-medium">{{ c.fullName }}</span><br/><span class="text-xs text-muted">{{ c.email }}</span></td>
              <td class="font-bold text-primary text-sm">{{ c.phone }}</td>
              <td class="text-sm">{{ c.subject }}</td>
              <td class="text-sm text-muted">{{ c.createdAt }}</td>
              <td class="text-center">
                <span :class="['badge', statusClass(c.status)]" style="cursor:pointer" @click="toggleStatus(c)">{{ statusLabel(c.status) }}</span>
              </td>
              <td>
                <div class="row-actions">
                  <button class="act-btn success" @click="toggleStatus(c)" :title="c.status === 'COMPLETED' ? 'Chưa xử lý' : 'Đã xử lý'"><CheckCircle :size="16" /></button>
                  <button class="act-btn" @click="openView(c)" title="Xem"><Eye :size="16" /></button>
                  <button class="act-btn danger" @click="triggerDelete(c.id)" title="Xoá"><Trash2 :size="16" /></button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- View Detail Modal -->
    <div v-if="isViewOpen" class="modal-overlay" @click.self="closeView">
      <div class="modal-box" style="max-width:520px">
        <div class="modal-head"><h3>Chi tiết Yêu cầu</h3><button class="act-btn" @click="closeView"><X :size="20" /></button></div>
        <div v-if="activeContact" class="modal-body" style="gap:1rem">
          <div style="display:grid;grid-template-columns:auto 1fr;gap:0.75rem 1rem;align-items:start">
            <User :size="18" style="color:#64748b;margin-top:2px" />
            <div><span class="text-xs text-muted">Khách hàng</span><br/><span class="font-bold">{{ activeContact.fullName }}</span></div>

            <Phone :size="18" style="color:var(--admin-primary);margin-top:2px" />
            <div><span class="text-xs text-muted">Số điện thoại</span><br/><span class="font-bold text-primary">{{ activeContact.phone }}</span></div>

            <MessageSquare :size="18" style="color:#64748b;margin-top:2px" />
            <div><span class="text-xs text-muted">Chủ đề</span><br/><span>{{ activeContact.subject }}</span></div>

            <Calendar :size="18" style="color:#64748b;margin-top:2px" />
            <div><span class="text-xs text-muted">Ngày gửi</span><br/><span>{{ activeContact.createdAt }}</span></div>
          </div>
          <div style="background:var(--admin-gray-50);padding:1rem;border-radius:8px;border:1px solid var(--admin-gray-200)">
            <span class="text-xs text-muted" style="display:block;margin-bottom:0.4rem">Nội dung chi tiết</span>
            <p style="margin:0;line-height:1.6;color:var(--admin-gray-700)">{{ activeContact.message || 'Không có nội dung.' }}</p>
          </div>
        </div>
        <div class="modal-foot">
          <button :class="['btn', activeContact?.status === 'COMPLETED' ? 'btn-outline' : 'btn-success']"
            @click="toggleStatus(activeContact); closeView()">
            <CheckCircle :size="16" /> {{ activeContact?.status === 'COMPLETED' ? 'Đánh dấu Chưa xử lý' : 'Xác nhận Đã xử lý' }}
          </button>
          <button class="btn btn-outline" @click="closeView">Đóng</button>
        </div>
      </div>
    </div>

    <!-- Confirm -->
    <div v-if="isConfirmOpen" class="modal-overlay" @click.self="isConfirmOpen = false">
      <div class="confirm-box">
        <div class="icon"><AlertTriangle :size="44" /></div>
        <h3>Xoá liên hệ?</h3><p>Không thể hoàn tác hành động này.</p>
        <div class="actions"><button class="btn btn-outline" @click="isConfirmOpen = false">Huỷ</button><button class="btn btn-danger" @click="confirmDelete">Đồng ý xoá</button></div>
      </div>
    </div>
  </div>
</template>
