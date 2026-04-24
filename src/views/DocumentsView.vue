<script setup>
import { FileText, Download, Eye, ExternalLink, Filter, Loader2 } from 'lucide-vue-next'
import { onMounted, ref, watch } from 'vue'
import documentApi from '@/api/documentApi'

const isLoading = ref(true)
const documents = ref([])
const categories = ref([{ id: 'all', name: 'Tất cả' }])
const activeCategoryId = ref('all')

const fetchCategories = async () => {
  try {
    const res = await documentApi.categories()
    if (res.data) {
      categories.value = [{ id: 'all', name: 'Tất cả' }, ...res.data]
    }
  } catch (error) {
    console.error('Error fetching doc categories:', error)
  }
}

const fetchDocuments = async () => {
  isLoading.value = true
  try {
    const params = {
      categoryId: activeCategoryId.value === 'all' ? null : activeCategoryId.value,
      isPublic: true
    }
    const res = await documentApi.search(params)
    documents.value = res.data?.content || res.data?.items || res.data || []
  } catch (error) {
    console.error('Error fetching documents:', error)
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  fetchCategories()
  fetchDocuments()
})

watch(activeCategoryId, fetchDocuments)
</script>

<template>
  <div class="documents">
    <section class="subpage-hero">
      <div class="hero-bg">
        <img src="https://images.unsplash.com/photo-1541819361361-b5413156942a?q=80&w=2000" alt="Documents Hero" />
        <div class="hero-overlay"></div>
      </div>
      <div class="container hero-content text-center">
        <h1>Tài Liệu Kỹ Thuật</h1>
        <p>Tải xuống các tài liệu, brochure và hướng dẫn sử dụng mới nhất.</p>
      </div>
    </section>

    <section class="section-padding container">
      <div class="doc-layout gap-4 mb-5">
        <div class="filters-sidebar glass">
          <h3>Bộ lọc</h3>
          <div class="filter-group">
            <label>Loại tài liệu</label>
            <select v-model="activeCategoryId">
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">
                {{ cat.name }}
              </option>
            </select>
          </div>
          <button class="btn btn-primary w-full mt-3" @click="fetchDocuments"><Filter :size="16" /> Lọc ngay</button>
        </div>

        <div class="documents-list min-h-300">
          <div v-if="isLoading" class="flex-center py-5">
            <Loader2 class="spinner text-primary" :size="48" />
          </div>
          <template v-else>
            <div v-if="documents.length === 0" class="text-center py-5 text-muted">
              Chưa có tài liệu nào trong danh mục này.
            </div>
            <div v-for="doc in documents" :key="doc.id" class="doc-card glass animate-fade-in">
              <div class="doc-preview">
                  <FileText :size="48" stroke-width="1" class="text-primary" />
              </div>
              <div class="doc-info">
                <div v-if="doc.category" class="badge-type">{{ doc.category?.name || doc.category?.slug || doc.category }}</div>
                <h3>{{ doc.title }}</h3>
                <div class="doc-meta">
                  <span v-if="doc.fileType">{{ doc.fileType }}</span>
                  <span v-if="doc.fileSizeKb">{{ (doc.fileSizeKb / 1024).toFixed(1) }} MB</span>
                  <span v-if="doc.downloadCount">{{ doc.downloadCount }} lượt tải</span>
                </div>
              </div>
              <div class="doc-actions">
                <a :href="doc.driveUrl" target="_blank" class="btn-icon" title="Xem trực tuyến"><Eye :size="20" /></a>
                <a :href="doc.driveUrl" target="_blank" class="btn-icon primary" title="Tải xuống"><Download :size="20" /></a>
              </div>
            </div>
          </template>
        </div>
      </div>
    </section>

    <!-- Request Custom Doc -->
    <section class="bg-light section-padding">
        <div class="container text-center">
            <h2 class="mb-4">Bạn cần tài liệu kỹ thuật chi tiết hơn?</h2>
            <p class="mb-5 opacity-0.8">Hãy gửi email yêu cầu trực tiếp cho đội ngũ kỹ sư của chúng tôi để được cung cấp các bản vẽ mặt cắt hố thang cụ thể.</p>
            <router-link to="/contact" class="btn btn-primary lg">Gửi yêu cầu tài liệu</router-link>
        </div>
    </section>
  </div>
</template>

<style scoped>
.subpage-hero {
  height: 400px;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.subpage-hero .hero-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -1;
}

.subpage-hero .hero-bg img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.subpage-hero h1 {
  font-size: 3.5rem;
  color: white;
  margin-bottom: 1rem;
}

.doc-layout {
    display: flex;
    align-items: flex-start;
    gap: 3rem;
}

.filters-sidebar {
    width: 300px;
    padding: 2rem;
    border-radius: 12px;
}

.filters-sidebar h3 {
    margin-bottom: 1.5rem;
}

.filter-group {
    margin-bottom: 1.5rem;
}

.filter-group label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 600;
}

.filter-group select {
    width: 100%;
    padding: 0.8rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    outline: none;
}

.documents-list {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.doc-card {
    display: flex;
    align-items: center;
    gap: 2rem;
    padding: 1.5rem;
    border-radius: 12px;
    background: white !important;
    transition: var(--transition);
}

.doc-card:hover {
    transform: translateX(10px);
    box-shadow: var(--shadow);
}

.doc-preview {
    width: 80px;
    height: 80px;
    border-radius: 8px;
    background: rgba(193, 160, 82, 0.05);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

.doc-info {
    flex: 1;
}

.badge-type {
    display: inline-block;
    background: #f0f0f0;
    padding: 0.2rem 0.8rem;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    color: var(--text-light);
    margin-bottom: 0.5rem;
}

.doc-info h3 {
    font-size: 1.25rem;
    margin-bottom: 0.5rem;
    color: var(--secondary);
}

.doc-meta {
    display: flex;
    gap: 1.5rem;
    font-size: 0.85rem;
    color: var(--text-light);
}

.doc-actions {
    display: flex;
    gap: 1rem;
}

.btn-icon {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    border: 1px solid #ddd;
    background: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: var(--transition);
    color: inherit;
    text-decoration: none;
}

.btn-icon:hover {
    border-color: var(--primary);
    color: var(--primary);
}

.btn-icon.primary {
    background: var(--primary);
    color: white;
    border: none;
}

.min-h-300 {
  min-height: 300px;
}

.flex-center {
  display: flex;
  justify-content: center;
  align-items: center;
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@media (max-width: 992px) {
  .doc-layout {
    flex-direction: column;
  }
  .filters-sidebar {
    width: 100%;
  }
}

@media (max-width: 768px) {
  .subpage-hero {
    height: 260px;
  }

  .subpage-hero h1 {
    font-size: 2rem;
  }

  .subpage-hero p {
    font-size: 0.92rem;
  }

  .filters-sidebar {
    padding: 1.25rem;
  }

  .doc-card {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .doc-preview {
    width: 64px;
    height: 64px;
  }

  .doc-meta {
    flex-wrap: wrap;
    gap: 0.75rem 1rem;
  }

  .doc-actions {
    width: 100%;
    justify-content: flex-start;
  }

  .btn-icon {
    width: 44px;
    height: 44px;
  }
}
</style>
