<script setup>
import { Calendar, Download, Eye, FileText, Loader2 } from 'lucide-vue-next'
import { computed, onMounted, ref, watch } from 'vue'
import documentApi from '@/api/documentApi'

const isLoading = ref(true)
const documents = ref([])
const categories = ref([{ id: 'all', name: 'Tất cả' }])
const activeCategoryId = ref('all')

const activeCategoryName = computed(
  () => categories.value.find((item) => item.id === activeCategoryId.value)?.name || 'Tất cả'
)

const formatFileSize = (value) => {
  if (!value) return null
  const sizeMb = value / 1024
  return `${sizeMb.toFixed(1)} MB`
}

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
    const res = await documentApi.getPublic({
      categoryId: activeCategoryId.value === 'all' ? null : activeCategoryId.value,
      isPublic: true,
      size: 24
    })
    documents.value = res.data?.content || res.data?.items || res.data || []
  } catch (error) {
    console.error('Error fetching documents:', error)
    documents.value = []
  } finally {
    isLoading.value = false
  }
}

const recordDownload = async (doc) => {
  try {
    await documentApi.recordDownload?.(doc.id)
  } catch {
    // Ignore analytics failure on public UI
  }
}

onMounted(() => {
  fetchCategories()
  fetchDocuments()
})

watch(activeCategoryId, fetchDocuments)
</script>

<template>
  <div class="documents-page">
    <section class="subpage-hero">
      <div class="hero-bg"></div>
    </section>

    <section class="section-padding intro-section">
      <div class="container">
        <div class="intro-copy">
          <h1>Tài liệu kỹ thuật và brochure từ Misel</h1>
          <p>
            Truy cập nhanh các brochure, tài liệu kỹ thuật và hướng dẫn cần thiết
            để hỗ trợ quá trình lựa chọn, triển khai và vận hành thang máy.
          </p>
        </div>
      </div>
    </section>

    <section class="container documents-body">
      <div class="filter-shell">
        <div class="filter-field">
          <label for="doc-category">Loại tài liệu</label>
          <select id="doc-category" v-model="activeCategoryId">
            <option v-for="cat in categories" :key="cat.id" :value="cat.id">
              {{ cat.name }}
            </option>
          </select>
        </div>
      </div>

      <div v-if="isLoading" class="loading-state">
        <Loader2 class="spinner text-primary" :size="44" />
      </div>

      <template v-else>
        <div class="section-head">
          <h3>{{ activeCategoryName === 'Tất cả' ? 'Tài liệu mới nhất' : activeCategoryName }}</h3>
          <p>{{ documents.length }} tài liệu đang hiển thị</p>
        </div>

        <div v-if="documents.length === 0" class="empty-state">
          <h3>Chưa có tài liệu phù hợp</h3>
          <p>Danh mục này hiện chưa có tài liệu công khai để hiển thị.</p>
        </div>

        <div v-else class="documents-grid">
          <article
            v-for="doc in documents"
            :key="doc.id"
            class="doc-card"
          >
            <div class="doc-preview">
              <FileText :size="42" stroke-width="1.5" />
            </div>

            <div class="doc-content">
              <div class="doc-meta">
                <span v-if="doc.category" class="doc-tag">{{ doc.category?.name || doc.category?.slug || doc.category }}</span>
                <span v-if="doc.createdAt" class="doc-meta-item"><Calendar :size="14" /> {{ new Date(doc.createdAt).toLocaleDateString('vi-VN') }}</span>
              </div>

              <h4>{{ doc.title }}</h4>

              <div class="doc-stats">
                <span v-if="doc.fileType">{{ doc.fileType }}</span>
                <span v-if="doc.fileSizeKb">{{ formatFileSize(doc.fileSizeKb) }}</span>
                <span v-if="doc.downloadCount !== undefined">{{ doc.downloadCount || 0 }} lượt tải</span>
              </div>

              <div class="doc-actions">
                <a :href="doc.driveUrl" target="_blank" rel="noreferrer" class="doc-link">
                  <Eye :size="16" />
                  Xem tài liệu
                </a>
                <a
                  :href="doc.driveUrl"
                  target="_blank"
                  rel="noreferrer"
                  class="doc-button"
                  @click="recordDownload(doc)"
                >
                  <Download :size="16" />
                  Tải xuống
                </a>
              </div>
            </div>
          </article>
        </div>

        <section class="cta-panel">
          <div class="cta-copy">
            <h3>Bạn cần tài liệu chuyên sâu hơn?</h3>
            <p>Gửi yêu cầu để đội ngũ kỹ thuật của Misel hỗ trợ đúng loại tài liệu bạn đang cần.</p>
          </div>
          <router-link to="/contact" class="cta-button">Gửi yêu cầu tài liệu</router-link>
        </section>
      </template>
    </section>
  </div>
</template>

<style scoped>
.subpage-hero {
  display: none !important;
  height: 0 !important;
  min-height: 0 !important;
  overflow: hidden;
  margin: 0;
  padding: 0;
}

.documents-page {
  background:
    radial-gradient(circle at top right, rgba(193, 160, 82, 0.08), transparent 28%),
    linear-gradient(180deg, #f8f6f0 0%, #ffffff 16%);
}

.intro-section {
  padding-top: 182px;
  padding-bottom: 28px;
}

.intro-copy {
  max-width: 780px;
  margin: 0 auto;
  text-align: center;
}

.intro-copy h1 {
  font-family: 'Montserrat', sans-serif;
  font-size: 3rem;
  font-weight: 600;
  line-height: 1.18;
  margin-bottom: 1rem;
  color: #1e1b18;
}

.intro-copy p {
  max-width: 680px;
  margin: 0 auto;
  font-size: 1.02rem;
  line-height: 1.75;
  color: #5d5b59;
}

.documents-body {
  padding-bottom: 80px;
}

.filter-shell {
  max-width: 520px;
  margin: 0 auto 2rem;
  padding: 1.2rem;
  background: #fff;
  border-radius: 18px;
  border: 1px solid rgba(15, 23, 42, 0.05);
  box-shadow: 0 18px 34px rgba(16, 24, 40, 0.07);
}

.filter-field label {
  display: block;
  margin-bottom: 0.55rem;
  font-weight: 600;
  color: #2c2825;
}

.filter-field select {
  width: 100%;
  min-height: 52px;
  padding: 0.95rem 1rem;
  border-radius: 14px;
  border: 1px solid rgba(193, 160, 82, 0.38);
  outline: none;
  font-size: 0.98rem;
  color: #2f2b28;
  background: #fff;
}

.section-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  gap: 1rem;
  margin-bottom: 1.2rem;
}

.section-head h3 {
  font-size: 2rem;
  color: #1e1b18;
}

.section-head p {
  color: #6b6966;
}

.loading-state,
.empty-state {
  min-height: 320px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
}

.documents-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 1.25rem;
}

.doc-card {
  background: #fff;
  border-radius: 16px;
  border: 1px solid rgba(15, 23, 42, 0.05);
  box-shadow: 0 16px 32px rgba(16, 24, 40, 0.08);
  padding: 1.2rem;
  display: flex;
  flex-direction: column;
  min-height: 100%;
}

.doc-preview {
  width: 74px;
  height: 74px;
  border-radius: 18px;
  background: linear-gradient(180deg, #f7e7ad 0%, #ead08a 100%);
  color: #896618;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 1rem;
}

.doc-content {
  display: flex;
  flex-direction: column;
  flex: 1;
}

.doc-meta {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.55rem 0.8rem;
  margin-bottom: 0.7rem;
  color: #6a6865;
  font-size: 0.86rem;
}

.doc-meta-item {
  display: inline-flex;
  align-items: center;
  gap: 0.3rem;
}

.doc-tag {
  display: inline-flex;
  align-items: center;
  padding: 0.32rem 0.62rem;
  border-radius: 8px;
  background: #f5e6a7;
  color: #88630d;
  font-size: 0.8rem;
  font-weight: 600;
}

.doc-content h4 {
  font-size: 1.12rem;
  line-height: 1.45;
  color: #191715;
  margin-bottom: 0.8rem;
}

.doc-stats {
  display: flex;
  flex-wrap: wrap;
  gap: 0.55rem 0.9rem;
  color: #6a6865;
  font-size: 0.9rem;
  margin-bottom: 1rem;
}

.doc-actions {
  margin-top: auto;
  display: flex;
  gap: 0.8rem;
  flex-wrap: wrap;
}

.doc-link,
.doc-button,
.cta-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.45rem;
  border-radius: 999px;
  padding: 0.78rem 1.1rem;
  font-weight: 600;
}

.doc-link {
  color: #aa8124;
  background: rgba(193, 160, 82, 0.08);
}

.doc-button,
.cta-button {
  background: linear-gradient(180deg, #d3ae4c 0%, #b98d2b 100%);
  color: white;
  box-shadow: 0 12px 24px rgba(193, 160, 82, 0.24);
}

.cta-panel {
  margin-top: 3rem;
  padding: 1.7rem 2rem;
  border-radius: 16px;
  background: linear-gradient(135deg, #0b315f 0%, #0c2242 100%);
  box-shadow: 0 18px 34px rgba(3, 32, 68, 0.16);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1.25rem;
}

.cta-copy h3 {
  color: white;
  font-size: 2rem;
  margin-bottom: 0.35rem;
}

.cta-copy p {
  color: rgba(255, 255, 255, 0.82);
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@media (max-width: 1100px) {
  .documents-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 768px) {
  .intro-section {
    padding-top: 148px;
  }

  .intro-copy h1 {
    font-size: 2.2rem;
  }

  .section-head {
    flex-direction: column;
    align-items: flex-start;
  }

  .documents-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .cta-panel {
    flex-direction: column;
    align-items: flex-start;
    padding: 1.35rem;
  }
}

@media (max-width: 480px) {
  .filter-shell {
    padding: 1rem;
    border-radius: 14px;
  }

  .documents-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 0.9rem;
  }

  .doc-card {
    padding: 0.9rem;
  }

  .doc-preview {
    width: 58px;
    height: 58px;
    border-radius: 14px;
    margin-bottom: 0.8rem;
  }

  .doc-content h4 {
    font-size: 0.98rem;
    line-height: 1.4;
  }

  .doc-meta,
  .doc-stats {
    font-size: 0.78rem;
    gap: 0.4rem 0.55rem;
  }

  .doc-actions {
    flex-direction: column;
    gap: 0.55rem;
  }

  .doc-link,
  .doc-button {
    width: 100%;
    padding: 0.72rem 0.7rem;
    font-size: 0.84rem;
  }

  .cta-copy h3 {
    font-size: 1.55rem;
  }
}
</style>
