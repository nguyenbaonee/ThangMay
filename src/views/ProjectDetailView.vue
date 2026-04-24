<script setup>
import { CheckCircle, ArrowLeft, Loader2, MapPin, Calendar, Share2, Download } from 'lucide-vue-next'
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import postApi from '@/api/postApi'

const route = useRoute()
const isLoading = ref(true)
const project = ref(null)
const activeImage = ref('')

const resolveImageUrl = (item) => item?.publicUrl || item?.url || item || ''
const resolveCategoryName = (p) => p?.category?.name || p?.category?.slug || p?.category || 'Dự án tiêu biểu'

const fetchProject = async () => {
  try {
    const res = await postApi.getBySlug(route.params.slug)
    project.value = res.data

    if (project.value?.thumbnail) {
      activeImage.value = resolveImageUrl(project.value.thumbnail)
    } else if (project.value?.images?.length > 0) {
      activeImage.value = resolveImageUrl(project.value.images[0])
    }
  } catch (error) {
    console.error('Error fetching project detail:', error)
  } finally {
    isLoading.value = false
  }
}

onMounted(fetchProject)

const galleryImages = computed(() => {
  const imgs = []
  if (project.value?.thumbnail) imgs.push(resolveImageUrl(project.value.thumbnail))
  if (project.value?.images?.length) {
    project.value.images.forEach((img) => {
      const resolved = resolveImageUrl(img)
      if (resolved && !imgs.includes(resolved)) imgs.push(resolved)
    })
  }
  return imgs
})
</script>

<template>
  <div class="project-detail">
    <div class="container py-subnav">
      <router-link to="/projects" class="back-link"><ArrowLeft :size="16" /> Quay lại dự án</router-link>
    </div>

    <div v-if="isLoading" class="flex-center py-5">
      <Loader2 class="spinner text-primary" :size="48" />
    </div>

    <div v-else-if="!project" class="container text-center py-5">
      <h2>Không tìm thấy dự án</h2>
      <p>Dự án bạn đang xem không tồn tại hoặc đã bị gỡ bỏ.</p>
    </div>

    <template v-else>
      <section class="section-padding container">
        <div class="project-grid">
          <div class="gallery-side">
            <div class="main-image glass animate-fade-in">
              <img v-if="activeImage" :src="activeImage" :alt="project.title" />
              <div v-else class="flex-center h-100 bg-light text-muted">No Image</div>
            </div>
            <div v-if="galleryImages.length > 1" class="thumbnails animate-fade-in">
              <div
                v-for="img in galleryImages"
                :key="img"
                :class="['thumb', activeImage === img ? 'active' : '']"
                @click="activeImage = img"
              >
                <img :src="img" :alt="project.title" />
              </div>
            </div>
          </div>

          <div class="info-side animate-fade-in">
            <h4 class="label">{{ resolveCategoryName(project) }}</h4>
            <h1>{{ project.title }}</h1>
            <p class="short-desc">{{ project.summary || 'Chưa có mô tả ngắn.' }}</p>

            <div class="quick-info">
              <div class="info-item">
                <MapPin :size="20" class="primary-icon" />
                <span>{{ resolveCategoryName(project) }}</span>
              </div>
              <div class="info-item">
                <Calendar :size="20" class="primary-icon" />
                <span>{{ project.createdAt ? new Date(project.createdAt).toLocaleDateString('vi-VN') : 'Đang cập nhật' }}</span>
              </div>
            </div>

            <div class="action-btns">
              <router-link to="/contact" class="btn btn-primary lg">Liên hệ tư vấn</router-link>
              <div class="secondary-actions">
                <button class="icon-btn" title="Chia sẻ"><Share2 :size="20" /></button>
                <button class="icon-btn" title="Tải xuống"><Download :size="20" /></button>
              </div>
            </div>

            <div class="quick-info mt-4">
              <div class="info-item">
                <CheckCircle :size="20" class="primary-icon" />
                <span>Thông tin dự án đã xác thực từ BE</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="section-padding bg-light">
        <div class="container">
          <div class="glass p-4 rich-content" v-html="project.content || 'Chưa có nội dung chi tiết.'"></div>
        </div>
      </section>
    </template>
  </div>
</template>

<style scoped>
.py-subnav {
  padding-top: 120px;
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

.project-grid {
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: 5rem;
  align-items: flex-start;
}

.gallery-side {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.main-image {
  height: 500px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow);
}

.main-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.thumbnails {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}

.thumb {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  border: 2px solid transparent;
  transition: var(--transition);
}

.thumb.active {
  border-color: var(--primary);
}

.thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.info-side h1 {
  margin-bottom: 1rem;
}

.short-desc {
  color: var(--text-light);
  line-height: 1.8;
}

.quick-info {
  display: grid;
  gap: 0.75rem;
  margin-top: 1.5rem;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.primary-icon {
  color: var(--primary);
}

.action-btns {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-top: 2rem;
}

.secondary-actions {
  display: flex;
  gap: 0.75rem;
}

@media (max-width: 992px) {
  .project-grid {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
}

@media (max-width: 768px) {
  .project-grid {
    gap: 1.5rem;
  }

  .main-image {
    height: 260px;
  }

  .thumbnails {
    gap: 0.75rem;
  }

  .thumb {
    width: 64px;
    height: 64px;
  }

  .info-side h1 {
    font-size: 2rem;
  }

  .action-btns {
    flex-direction: column;
    align-items: stretch;
    gap: 0.85rem;
    margin-top: 1.5rem;
  }

  .secondary-actions {
    justify-content: center;
  }

  .quick-info {
    gap: 0.6rem;
  }
}
</style>
