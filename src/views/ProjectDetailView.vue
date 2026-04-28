<script setup>
import { ArrowLeft, Calendar, Eye, Loader2, User } from 'lucide-vue-next'
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import postApi from '@/api/postApi'

const route = useRoute()
const isLoading = ref(true)
const article = ref(null)

const resolveImageUrl = (item) => item?.publicUrl || item?.url || item || ''
const resolveCategoryName = (post) => post?.category?.name || post?.category?.slug || 'Bài viết'
const formatDate = (value) => {
  if (!value) return 'Đang cập nhật'
  return new Date(value).toLocaleDateString('vi-VN', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  })
}

const coverImage = computed(() => {
  if (article.value?.thumbnail) return resolveImageUrl(article.value.thumbnail)
  if (article.value?.images?.length) return resolveImageUrl(article.value.images[0])
  return 'https://images.unsplash.com/photo-1497366754035-f200968a6e72?q=80&w=1600'
})

const galleryImages = computed(() => {
  const images = []
  if (article.value?.thumbnail) images.push(resolveImageUrl(article.value.thumbnail))
  if (article.value?.images?.length) {
    article.value.images.forEach((img) => {
      const resolved = resolveImageUrl(img)
      if (resolved && !images.includes(resolved)) images.push(resolved)
    })
  }
  return images
})

const fetchArticle = async () => {
  try {
    const res = await postApi.getBySlug(route.params.slug)
    article.value = res.data
  } catch (error) {
    console.error('Error fetching blog detail:', error)
    article.value = null
  } finally {
    isLoading.value = false
  }
}

onMounted(fetchArticle)
</script>

<template>
  <div class="article-detail">
    <div class="container py-subnav">
      <router-link to="/projects" class="back-link"><ArrowLeft :size="16" /> Quay lại bài viết</router-link>
    </div>

    <div v-if="isLoading" class="flex-center py-5">
      <Loader2 class="spinner text-primary" :size="48" />
    </div>

    <div v-else-if="!article" class="container text-center py-5">
      <h2>Không tìm thấy bài viết</h2>
      <p>Bài viết bạn đang xem không tồn tại hoặc chưa được xuất bản.</p>
    </div>

    <template v-else>
      <section class="container article-hero">
        <div class="hero-copy animate-fade-in">
          <span class="post-badge">{{ resolveCategoryName(article) }}</span>
          <h1>{{ article.title }}</h1>
          <p class="lead">{{ article.summary || 'Bài viết đang được cập nhật phần mô tả ngắn.' }}</p>

          <div class="meta-row">
            <span class="meta-item"><Calendar :size="16" /> {{ formatDate(article.publishedAt || article.createdAt) }}</span>
            <span class="meta-item"><User :size="16" /> {{ article.authorName || 'Misel Team' }}</span>
            <span class="meta-item"><Eye :size="16" /> {{ article.viewCount || 0 }} lượt xem</span>
          </div>
        </div>

        <div class="hero-media glass animate-fade-in">
          <img :src="coverImage" :alt="article.title" />
        </div>
      </section>

      <section class="section-padding">
        <div class="container article-layout">
          <article class="article-content glass">
            <div class="rich-content" v-html="article.content || 'Chưa có nội dung chi tiết.'"></div>
          </article>

          <aside class="article-aside">
            <div class="aside-card glass">
              <h3>Thông tin bài viết</h3>
              <ul class="aside-list">
                <li><strong>Chuyên mục:</strong> {{ resolveCategoryName(article) }}</li>
                <li><strong>Tác giả:</strong> {{ article.authorName || 'Misel Team' }}</li>
                <li><strong>Ngày đăng:</strong> {{ formatDate(article.publishedAt || article.createdAt) }}</li>
                <li><strong>Lượt xem:</strong> {{ article.viewCount || 0 }}</li>
              </ul>
            </div>

            <div class="aside-card cta-card">
              <h3>Cần tư vấn theo bài viết này?</h3>
              <p>Đội ngũ Misel có thể hỗ trợ giải pháp phù hợp với nhu cầu công trình thực tế của bạn.</p>
              <router-link to="/contact" class="btn btn-primary w-full">Liên hệ tư vấn</router-link>
            </div>
          </aside>
        </div>
      </section>

      <section v-if="galleryImages.length > 1" class="section-padding gallery-wrap">
        <div class="container">
          <div class="section-head">
            <h3>Hình ảnh liên quan</h3>
          </div>
          <div class="gallery-grid">
            <div v-for="img in galleryImages" :key="img" class="gallery-card glass">
              <img :src="img" :alt="article.title" />
            </div>
          </div>
        </div>
      </section>
    </template>
  </div>
</template>

<style scoped>
.py-subnav {
  padding-top: 132px;
  padding-bottom: 20px;
}

.back-link {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 600;
  color: var(--text-light);
}

.back-link:hover {
  color: var(--primary);
}

.article-hero {
  display: grid;
  grid-template-columns: 0.95fr 1.05fr;
  gap: 2rem;
  align-items: center;
  padding-bottom: 2rem;
}

.hero-copy h1 {
  font-size: 3rem;
  line-height: 1.12;
  margin: 1rem 0 1.25rem;
}

.lead {
  color: var(--text-light);
  font-size: 1.08rem;
  line-height: 1.85;
  margin-bottom: 1.5rem;
}

.post-badge {
  display: inline-flex;
  align-items: center;
  padding: 0.4rem 0.9rem;
  border-radius: 999px;
  background: rgba(193, 160, 82, 0.12);
  color: var(--primary-dark);
  font-size: 0.78rem;
  font-weight: 700;
  letter-spacing: 0.04em;
  text-transform: uppercase;
}

.meta-row {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem 1rem;
  color: var(--text-light);
}

.meta-item {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.92rem;
}

.hero-media {
  border-radius: 24px;
  overflow: hidden;
  background: #fff !important;
  box-shadow: var(--shadow);
}

.hero-media img,
.gallery-card img {
  width: 100%;
  display: block;
  object-fit: cover;
}

.hero-media img {
  height: 480px;
}

.article-layout {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 320px;
  gap: 2rem;
  align-items: start;
}

.article-content {
  border-radius: 24px;
  padding: 2rem;
  background: #fff !important;
  box-shadow: var(--shadow);
}

.article-aside {
  display: grid;
  gap: 1.5rem;
}

.aside-card {
  border-radius: 20px;
  padding: 1.5rem;
  background: #fff !important;
  box-shadow: 0 8px 28px rgba(0, 0, 0, 0.05);
}

.aside-card h3 {
  margin-bottom: 1rem;
}

.aside-list {
  display: grid;
  gap: 0.85rem;
  color: var(--text-light);
}

.aside-list strong {
  color: var(--secondary);
}

.cta-card {
  background: var(--secondary) !important;
  color: white;
}

.cta-card h3 {
  color: white;
}

.cta-card p {
  margin-bottom: 1.25rem;
  color: rgba(255, 255, 255, 0.82);
}

.gallery-wrap {
  padding-top: 0;
}

.section-head {
  margin-bottom: 1.25rem;
}

.gallery-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 1rem;
}

.gallery-card {
  border-radius: 18px;
  overflow: hidden;
  background: #fff !important;
}

.gallery-card img {
  height: 220px;
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
  .article-hero,
  .article-layout {
    grid-template-columns: 1fr;
  }

  .article-aside {
    order: 2;
  }
}

@media (max-width: 768px) {
  .py-subnav {
    padding-top: 118px;
  }

  .hero-copy h1 {
    font-size: 2.1rem;
  }

  .hero-media img {
    height: 260px;
  }

  .article-content {
    padding: 1.25rem;
    border-radius: 18px;
  }

  .gallery-grid {
    grid-template-columns: 1fr;
  }

  .gallery-card img {
    height: 210px;
  }
}
</style>
