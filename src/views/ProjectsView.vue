<script setup>
import { MapPin, Calendar, ExternalLink, Loader2 } from 'lucide-vue-next'
import { onMounted, ref } from 'vue'
import postApi from '@/api/postApi'

const isLoading = ref(true)
const projects = ref([])

const fetchProjects = async () => {
  try {
    const res = await postApi.search({ type: 'PROJECT', status: 'PUBLISHED' })
    projects.value = res.data?.content || res.data?.items || res.data || []
  } catch (error) {
    console.error('Error fetching projects:', error)
  } finally {
    isLoading.value = false
  }
}

onMounted(fetchProjects)
</script>

<template>
  <div class="projects">
    <section class="subpage-hero">
      <div class="hero-bg">
        <img src="https://images.unsplash.com/photo-1541819361361-b5413156942a?q=80&w=2000" alt="Projects Hero" />
        <div class="hero-overlay"></div>
      </div>
      <div class="container hero-content text-center">
        <h1>Dự Án Tiêu Biểu</h1>
        <p>Minh chứng cho chất lượng và sự tin tưởng của khách hàng.</p>
      </div>
    </section>

    <section class="section-padding container min-h-300">
      <div v-if="isLoading" class="flex-center py-5">
        <Loader2 class="spinner text-primary" :size="48" />
      </div>
      <div v-else class="grid-2">
        <div v-if="projects.length === 0" class="col-span-full py-5 text-center text-muted">
          Chưa có dự án nào được cập nhật.
        </div>
        <div v-for="project in projects" :key="project.id" class="project-box animate-fade-in">
          <div class="box-image">
            <img :src="project.thumbnail?.publicUrl || project.thumbnail?.url || 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=1000'" :alt="project.title" />
            <div class="overlay-info">
              <!-- Post categories or metadata can be used here -->
              <span class="location"><MapPin :size="14" /> {{ project.category?.name || project.category?.slug || project.category || 'Dự án tiêu biểu' }}</span>
              <span class="date"><Calendar :size="14" /> {{ project.createdAt ? new Date(project.createdAt).toLocaleDateString() : '2023' }}</span>
            </div>
          </div>
          <div class="box-content">
            <h3>{{ project.title }}</h3>
            <p v-if="project.summary" class="truncate-2">{{ project.summary }}</p>
            <router-link :to="project.slug ? '/projects/' + project.slug : '/projects'" class="btn-link mt-3">Chi tiết dự án <ExternalLink :size="14" /></router-link>
          </div>
        </div>
      </div>
    </section>

    <!-- Testimonials -->
    <section class="bg-light section-padding">
        <div class="container text-center mb-5">
            <h4 class="label">PHẢN HỒI</h4>
            <h2>Khách hàng nói gì về <span class="text-gradient">Misel</span></h2>
        </div>
        <div class="container grid-3">
            <div class="testimonial-card glass">
                <p>"Tôi rất hài lòng với sự tư vấn tận tình của đội ngũ kỹ sư Misel. Chiếc thang máy kính thực sự là điểm nhấn cho ngôi nhà của tôi."</p>
                <div class="user p-3">
                    <strong>Anh Minh</strong>
                    <span>Chủ biệt thự Riviera</span>
                </div>
            </div>
            <div class="testimonial-card glass">
                <p>"Thời gian lắp đặt nhanh chóng, quy định an toàn được thực hiện rất nghiêm ngặt. Bảo hành định kỳ rất đúng hẹn."</p>
                <div class="user p-3">
                    <strong>Chị Thu</strong>
                    <span>Giám đốc KS Đà Lạt</span>
                </div>
            </div>
            <div class="testimonial-card glass">
                <p>"Giải pháp không hố Pit của Misel đã giúp tôi lắp được thang máy cho căn nhà cũ mà không cần cải tạo quá nhiều."</p>
                <div class="user p-3">
                    <strong>Chú Bảy</strong>
                    <span>Quận 3, TP.HCM</span>
                </div>
            </div>
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

.grid-2 {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 3rem;
}

.project-box {
    border-radius: 16px;
    overflow: hidden;
    background: white;
    box-shadow: 0 5px 20px rgba(0,0,0,0.05);
    transition: var(--transition);
    height: 100%;
    display: flex;
    flex-direction: column;
}

.project-box:hover {
    transform: translateY(-10px);
    box-shadow: 0 15px 40px rgba(0,0,0,0.1);
}

.box-image {
    height: 350px;
    position: relative;
    overflow: hidden;
}

.box-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.8s;
}

.project-box:hover .box-image img {
    transform: scale(1.1);
}

.overlay-info {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
    padding: 2rem;
    color: white;
    display: flex;
    justify-content: space-between;
}

.location, .date {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.85rem;
    font-weight: 500;
}

.box-content {
    padding: 2.5rem;
    flex: 1;
    display: flex;
    flex-direction: column;
}

.box-content h3 {
    font-size: 1.5rem;
    margin-bottom: 1rem;
    color: var(--secondary);
}

.box-content p {
    color: var(--text-light);
    margin-bottom: 1.5rem;
}

.truncate-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.btn-link {
    color: var(--primary);
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin-top: auto;
}

.testimonial-card {
    padding: 3rem;
    border-radius: 12px;
    background: white !important;
    text-align: center;
}

.testimonial-card p {
    font-style: italic;
    font-size: 1.1rem;
    color: var(--text-light);
    margin-bottom: 2rem;
}

.user {
    display: flex;
    flex-direction: column;
}

.user strong {
    color: var(--secondary);
    font-size: 1.1rem;
}

.user span {
    font-size: 0.85rem;
    color: var(--primary);
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
  .grid-2 {
    grid-template-columns: 1fr;
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

  .grid-2,
  .grid-3 {
    grid-template-columns: 1fr;
  }

  .box-image {
    height: 220px;
  }

  .overlay-info {
    padding: 1rem;
    flex-direction: column;
    align-items: flex-start;
    gap: 0.35rem;
  }

  .box-content {
    padding: 1.25rem;
  }

  .testimonial-card {
    padding: 1.5rem;
  }

  .testimonial-card p {
    font-size: 1rem;
    margin-bottom: 1.25rem;
  }
}
</style>
