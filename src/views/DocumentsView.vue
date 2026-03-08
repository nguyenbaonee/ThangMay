<script setup>
import { FileText, Download, Eye, ExternalLink, Filter } from 'lucide-vue-next'

const documents = [
  { 
    id: 1, 
    title: 'Brochure Thang Máy Gia Đình 2024', 
    type: 'Brochure', 
    size: '12.5 MB', 
    format: 'PDF',
    image: '/images/3653228387362596575.jpg'
  },
  { 
    id: 2, 
    title: 'Hướng Dẫn Sử Dụng Thang Máy An Toàn', 
    type: 'User Manual', 
    size: '4.2 MB', 
    format: 'PDF',
    image: '/images/3295663955585252783 (1).jpg'
  },
  { 
    id: 3, 
    title: 'Catalogue Linh Kiện Nhập Khẩu Thụy Điển', 
    type: 'Catalogue', 
    size: '25.8 MB', 
    format: 'PDF',
    image: '/images/3295663955585252783.jpg'
  },
  { 
    id: 4, 
    title: 'Thông Số Kỹ Thuật Hố Thang Chuẩn', 
    type: 'Technical', 
    size: '1.5 MB', 
    format: 'PDF',
    image: '/images/1218206096172762156.jpg'
  }
]
</script>

<template>
  <div class="documents">
    <section class="subpage-hero">
      <div class="hero-bg">
        <img src="/images/3726039324607881804 (1).jpg" alt="Documents Hero" />
        <div class="hero-overlay"></div>
      </div>
      <div class="container hero-content text-center">
        <h1>Tài Liệu Kỹ Thuật</h1>
        <p>Tải xuống các tài liệu, brochure và hướng dẫn sử dụng mới nhất.</p>
      </div>
    </section>

    <section class="section-padding container">
      <div class="flex-row gap-4 mb-5">
        <div class="filters-sidebar glass">
          <h3>Bộ lọc</h3>
          <div class="filter-group">
            <label>Loại tài liệu</label>
            <select>
              <option>Tất cả</option>
              <option>Brochure</option>
              <option>User Manual</option>
              <option>Technical</option>
            </select>
          </div>
          <button class="btn btn-primary w-full mt-3"><Filter :size="16" /> Lọc ngay</button>
        </div>

        <div class="documents-list">
          <div v-for="doc in documents" :key="doc.id" class="doc-card glass animate-fade-in">
            <div class="doc-preview">
                <img :src="doc.image" :alt="doc.title" />
            </div>
            <div class="doc-info">
              <div class="badge-type">{{ doc.type }}</div>
              <h3>{{ doc.title }}</h3>
              <div class="doc-meta">
                <span>{{ doc.format }}</span>
                <span>{{ doc.size }}</span>
              </div>
            </div>
            <div class="doc-actions">
              <button class="btn-icon"><Eye :size="20" /></button>
              <button class="btn-icon primary"><Download :size="20" /></button>
            </div>
          </div>
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

.flex-row {
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
    width: 100px;
    height: 100px;
    border-radius: 8px;
    overflow: hidden;
    flex-shrink: 0;
}

.doc-preview img {
    width: 100%;
    height: 100%;
    object-fit: cover;
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

@media (max-width: 992px) {
  .flex-row {
    flex-direction: column;
  }
  .filters-sidebar {
    width: 100%;
  }
}
</style>
