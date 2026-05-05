<script setup>
import { ArrowRight, Calendar, Eye, Loader2, User } from 'lucide-vue-next'
import { computed, onMounted, ref } from 'vue'
import postApi from '@/api/postApi'

const MAX_PRIMARY_POSTS = 6
const MAX_GRID_POSTS = 3

const isLoading = ref(true)
const activeFilter = ref('PROJECT')
const expandedFilters = ref({
  NEWS: false,
  PROJECT: false,
  RECRUITMENT: false
})
const articleGroups = ref({
  NEWS: { featured: [], all: [] },
  PROJECT: { featured: [], all: [] },
  RECRUITMENT: { featured: [], all: [] }
})

const filterOptions = [
  { value: 'PROJECT', label: 'Dự án', heading: 'Dự án mới nhất' },
  { value: 'NEWS', label: 'Tin tức', heading: 'Tin tức mới nhất' },
  { value: 'RECRUITMENT', label: 'Tuyển dụng', heading: 'Tuyển dụng mới nhất' }
]

const filterDescriptions = {
  PROJECT: 'Misel tổng hợp các công trình tiêu biểu, giải pháp triển khai và góc nhìn thực tế từ dự án đã hoàn thành.',
  NEWS: 'Cập nhật xu hướng, thông tin ngành và những chia sẻ mới nhất từ đội ngũ Misel.',
  RECRUITMENT: 'Thông tin tuyển dụng mới nhất dành cho ứng viên muốn đồng hành cùng Misel.'
}

const fallbackCategoryName = {
  NEWS: 'Tin tức',
  PROJECT: 'Dự án',
  RECRUITMENT: 'Tuyển dụng'
}

const resolveCategoryName = (post) =>
  post?.category?.name || post?.category?.slug || fallbackCategoryName[post?.type] || 'Bài viết'

const resolveThumbnail = (post) =>
  post?.thumbnail?.publicUrl ||
  post?.thumbnail?.url ||
  'https://images.unsplash.com/photo-1497366754035-f200968a6e72?q=80&w=1200'

const formatDate = (value) => {
  if (!value) return 'Đang cập nhật'
  return new Date(value).toLocaleDateString('vi-VN', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  })
}

const activeFilterOption = computed(
  () => filterOptions.find((item) => item.value === activeFilter.value) || filterOptions[0]
)

const selectedGroup = computed(
  () => articleGroups.value[activeFilter.value] || { featured: [], all: [] }
)

const sortedAllPosts = computed(() => {
  const all = [...(selectedGroup.value.all || [])]
  return all.sort((a, b) => {
    // Sort by featured first (true comes before false)
    if (!!a.featured !== !!b.featured) return a.featured ? -1 : 1
    // Then sort by date descending
    const dateA = new Date(a.publishedAt || a.createdAt || 0)
    const dateB = new Date(b.publishedAt || b.createdAt || 0)
    return dateB - dateA
  })
})

const primaryPosts = computed(() => {
  return sortedAllPosts.value.slice(0, MAX_PRIMARY_POSTS)
})

const heroPost = computed(() => primaryPosts.value[0] || null)
const secondaryPosts = computed(() => primaryPosts.value.slice(1, 1 + MAX_GRID_POSTS))

const remainingPosts = computed(() => {
  return sortedAllPosts.value.slice(primaryPosts.value.length)
})

const visibleExtraPosts = computed(() =>
  expandedFilters.value[activeFilter.value] ? remainingPosts.value : []
)

const hasMorePosts = computed(() => remainingPosts.value.length > 0)

const isFeaturedPost = (postId) =>
  (selectedGroup.value.featured || []).some((item) => item.id === postId)

const fetchArticles = async () => {
  try {
    const requests = filterOptions.flatMap((option) => [
      postApi.getFeatured(option.value),
      postApi.getPublished({ type: option.value, size: 50 })
    ])
    const results = await Promise.allSettled(requests)

    articleGroups.value = {
      PROJECT: {
        featured: results[0].status === 'fulfilled' ? (results[0].value.data || []) : [],
        all: results[1].status === 'fulfilled' ? (results[1].value.data?.content || results[1].value.data?.items || results[1].value.data || []) : []
      },
      NEWS: {
        featured: results[2].status === 'fulfilled' ? (results[2].value.data || []) : [],
        all: results[3].status === 'fulfilled' ? (results[3].value.data?.content || results[3].value.data?.items || results[3].value.data || []) : []
      },
      RECRUITMENT: {
        featured: results[4].status === 'fulfilled' ? (results[4].value.data || []) : [],
        all: results[5].status === 'fulfilled' ? (results[5].value.data?.content || results[5].value.data?.items || results[5].value.data || []) : []
      }
    }
  } catch (error) {
    console.error('Error fetching posts:', error)
    articleGroups.value = {
      NEWS: { featured: [], all: [] },
      PROJECT: { featured: [], all: [] },
      RECRUITMENT: { featured: [], all: [] }
    }
  } finally {
    isLoading.value = false
  }
}

const selectFilter = (filter) => {
  activeFilter.value = filter
}

const toggleShowMore = () => {
  expandedFilters.value[activeFilter.value] = !expandedFilters.value[activeFilter.value]
}

onMounted(fetchArticles)
</script>

<template>
  <div class="posts-page">
    <section class="subpage-hero">
      <div class="hero-bg"></div>
    </section>

    <section class="section-padding intro-section">
      <div class="container">
        <div class="intro-copy">
          <h1>Kiến thức và góc nhìn thực tế từ Misel</h1>
          <p>
            Misel thức và góc nhìn thợ đồng và rắc rối kỹ năng học về công trình thang máy,
            cùng những góc nhìn thực tế từ các dự án và nội dung chuyên môn mới nhất.
          </p>

          <div class="filter-tabs">
            <button
              v-for="option in filterOptions"
              :key="option.value"
              :class="['filter-tab', { active: activeFilter === option.value }]"
              @click="selectFilter(option.value)"
            >
              {{ option.label }}
            </button>
          </div>

          <p class="filter-description">{{ filterDescriptions[activeFilter] }}</p>
        </div>
      </div>
    </section>

    <section class="container posts-body">
      <div v-if="isLoading" class="loading-state">
        <Loader2 class="spinner text-primary" :size="44" />
      </div>

      <template v-else>
        <div v-if="!heroPost" class="empty-state">
          <h3>Chưa có {{ activeFilterOption.label.toLowerCase() }}</h3>
          <p>Nội dung sẽ xuất hiện tại đây sau khi được xuất bản từ trang quản trị.</p>
        </div>

        <template v-else>
          <article class="hero-card">
            <div class="hero-card-media">
              <img :src="resolveThumbnail(heroPost)" :alt="heroPost.title" />
            </div>
            <div class="hero-card-content">
              <div class="post-meta">
                <span class="post-tag">{{ resolveCategoryName(heroPost) }}</span>
                <span class="post-meta-item"><Calendar :size="14" /> {{ formatDate(heroPost.publishedAt || heroPost.createdAt) }}</span>
                <span class="post-meta-item"><User :size="14" /> {{ heroPost.authorName || 'Administrator' }}</span>
                <span class="post-meta-item"><Eye :size="14" /> {{ heroPost.viewCount || 0 }} lượt xem</span>
              </div>

              <h2>{{ heroPost.title }}</h2>
              <p>{{ heroPost.summary || 'Nội dung đang được cập nhật phần mô tả ngắn cho bài viết này.' }}</p>

              <router-link :to="heroPost.slug ? '/projects/' + heroPost.slug : '/projects'" class="hero-link">
                Đọc bài viết
              </router-link>
            </div>
          </article>

          <section class="list-section">
            <div class="section-head">
              <h3>{{ activeFilterOption.heading }}</h3>
            </div>

            <div class="post-grid">
              <article
                v-for="post in secondaryPosts"
                :key="post.id"
                class="post-card"
              >
                <div class="post-card-media">
                  <img :src="resolveThumbnail(post)" :alt="post.title" />
                </div>
                <div class="post-card-content">
                  <div class="post-meta compact">
                    <span class="post-tag subtle">{{ resolveCategoryName(post) }}</span>
                    <span class="post-meta-item">{{ formatDate(post.publishedAt || post.createdAt) }}</span>
                    <span class="post-meta-item">{{ isFeaturedPost(post.id) ? 'Nổi bật' : (post.authorName || 'Administrator') }}</span>
                  </div>
                  <h4>{{ post.title }}</h4>
                </div>
              </article>
            </div>

            <div v-if="visibleExtraPosts.length > 0" class="extra-grid">
              <article
                v-for="post in visibleExtraPosts"
                :key="post.id"
                class="post-card extra"
              >
                <div class="post-card-media">
                  <img :src="resolveThumbnail(post)" :alt="post.title" />
                </div>
                <div class="post-card-content">
                  <div class="post-meta compact">
                    <span class="post-tag subtle">{{ resolveCategoryName(post) }}</span>
                    <span class="post-meta-item">{{ formatDate(post.publishedAt || post.createdAt) }}</span>
                    <span class="post-meta-item">{{ post.viewCount || 0 }} lượt xem</span>
                  </div>
                  <h4>{{ post.title }}</h4>
                  <p class="truncate-2">{{ post.summary || 'Nội dung đang được cập nhật phần tóm tắt.' }}</p>
                  <router-link :to="post.slug ? '/projects/' + post.slug : '/projects'" class="card-link">
                    Xem chi tiết <ArrowRight :size="14" />
                  </router-link>
                </div>
              </article>
            </div>

            <div v-if="hasMorePosts" class="more-actions">
              <button class="more-button" @click="toggleShowMore">
                {{ expandedFilters[activeFilter] ? 'Thu gọn' : 'Xem thêm' }}
              </button>
            </div>
          </section>

          <section class="cta-panel">
            <div class="cta-copy">
              <h3>Cần tư vấn thêm?</h3>
              <p>Để lại thông tin để đội ngũ Misel hỗ trợ theo đúng nhu cầu công trình.</p>
            </div>
            <router-link to="/contact" class="cta-button">Gửi yêu cầu tư vấn</router-link>
          </section>
        </template>
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

.posts-page {
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
  max-width: 660px;
  margin: 0 auto;
  font-size: 1.02rem;
  line-height: 1.75;
  color: #5d5b59;
}

.filter-tabs {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 0.85rem;
  margin: 2rem 0 1rem;
}

.filter-tab {
  min-width: 128px;
  padding: 0.82rem 1.25rem;
  border: 1px solid rgba(193, 160, 82, 0.8);
  border-radius: 999px;
  background: #fff;
  color: #9b7a29;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transition);
}

.filter-tab.active,
.filter-tab:hover {
  background: linear-gradient(180deg, #d3ae4c 0%, #b98d2b 100%);
  color: white;
  box-shadow: 0 10px 24px rgba(193, 160, 82, 0.24);
}

.filter-description {
  min-height: 48px;
}

.posts-body {
  padding-bottom: 80px;
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

.spinner {
  animation: spin 1s linear infinite;
}

.hero-card {
  display: grid;
  grid-template-columns: minmax(320px, 1.05fr) minmax(320px, 0.95fr);
  background: #fff;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 20px 44px rgba(27, 33, 41, 0.09);
  border: 1px solid rgba(15, 23, 42, 0.05);
}

.hero-card-media {
  min-height: 400px;
}

.hero-card-media img,
.post-card-media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.hero-card-content {
  padding: 2.6rem 2.4rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.post-meta {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-bottom: 1rem;
  color: #5f6368;
  font-size: 0.9rem;
}

.post-meta.compact {
  gap: 0.55rem;
  margin-bottom: 0.7rem;
  font-size: 0.82rem;
}

.post-meta-item {
  display: inline-flex;
  align-items: center;
  gap: 0.3rem;
}

.post-tag {
  display: inline-flex;
  align-items: center;
  padding: 0.35rem 0.65rem;
  border-radius: 8px;
  background: #f5e6a7;
  color: #88630d;
  font-size: 0.82rem;
  font-weight: 600;
}

.post-tag.subtle {
  background: transparent;
  padding: 0;
  color: #ab842a;
}

.hero-card-content h2 {
  font-size: 2.55rem;
  line-height: 1.15;
  margin-bottom: 1rem;
  color: #201a17;
}

.hero-card-content p {
  font-size: 1.02rem;
  line-height: 1.8;
  color: #4f4d4a;
  margin-bottom: 1.5rem;
}

.hero-link,
.cta-button,
.more-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: fit-content;
  padding: 0.86rem 1.35rem;
  border-radius: 999px;
  background: linear-gradient(180deg, #d3ae4c 0%, #b98d2b 100%);
  color: white;
  font-weight: 600;
  box-shadow: 0 12px 24px rgba(193, 160, 82, 0.24);
}

.list-section {
  margin-top: 2.5rem;
}

.section-head {
  margin-bottom: 1.2rem;
}

.section-head h3 {
  font-size: 2.25rem;
  color: #1e1b18;
}

.post-grid,
.extra-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 1.25rem;
}

.post-card {
  background: #fff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 16px 32px rgba(16, 24, 40, 0.08);
  border: 1px solid rgba(15, 23, 42, 0.05);
}

.post-card-media {
  height: 230px;
}

.post-card-content {
  padding: 1rem 1.05rem 1.15rem;
}

.post-card h4 {
  font-size: 1.12rem;
  line-height: 1.42;
  color: #191715;
}

.extra-grid {
  margin-top: 1.25rem;
}

.extra .post-card-content p {
  margin-top: 0.65rem;
  color: #5c5a57;
  line-height: 1.65;
}

.truncate-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-link {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  margin-top: 0.8rem;
  color: #aa8124;
  font-weight: 600;
}

.more-actions {
  display: flex;
  justify-content: center;
  margin-top: 1.5rem;
}

.more-button {
  border: none;
  cursor: pointer;
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

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@media (max-width: 1100px) {
  .hero-card,
  .post-grid,
  .extra-grid {
    grid-template-columns: 1fr 1fr;
  }

  .hero-card-media {
    min-height: 320px;
  }

  .hero-card-content {
    grid-column: span 2;
  }
}

@media (max-width: 768px) {
  .intro-section {
    padding-top: 148px;
  }

  .intro-copy h1 {
    font-size: 2.2rem;
  }

  .filter-tabs {
    flex-wrap: nowrap;
    justify-content: center;
    gap: 0.4rem;
    overflow: hidden;
    padding-bottom: 0;
  }

  .filter-tab {
    flex: 1 1 0;
    min-width: 0;
    width: 100%;
    padding: 0.72rem 0.5rem;
    font-size: 0.92rem;
  }

  .hero-card,
  .extra-grid {
    grid-template-columns: 1fr;
  }

  .post-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .hero-card-media {
    min-height: 250px;
  }

  .hero-card-content {
    grid-column: auto;
    padding: 1.4rem;
  }

  .hero-card-content h2 {
    font-size: 1.85rem;
  }

  .section-head h3,
  .cta-copy h3 {
    font-size: 1.6rem;
  }

  .cta-panel {
    flex-direction: column;
    align-items: flex-start;
    padding: 1.35rem;
  }
}

@media (max-width: 480px) {
  .filter-tabs {
    gap: 0.35rem;
  }

  .filter-tab {
    padding: 0.68rem 0.35rem;
    font-size: 0.84rem;
  }

  .post-grid,
  .extra-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 0.9rem;
  }

  .post-card-media {
    height: 138px;
  }

  .post-card-content {
    padding: 0.8rem 0.8rem 0.95rem;
  }

  .post-card h4 {
    font-size: 0.98rem;
    line-height: 1.38;
  }

  .post-meta.compact {
    font-size: 0.75rem;
    gap: 0.35rem;
  }

  .post-meta-item {
    gap: 0.22rem;
  }

  .extra .post-card-content p {
    font-size: 0.85rem;
    line-height: 1.5;
  }
}
</style>
