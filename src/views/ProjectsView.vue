<script setup>
import { MapPin, Calendar, ExternalLink } from 'lucide-vue-next'

const projects = [
  { 
    id: 1, 
    title: 'Biệt thự Riviera Point Quận 7', 
    customer: 'Anh Minh', 
    date: 'Tháng 12/2023',
    location: 'TP. Hồ Chí Minh',
    image: '/images/3726039324607881804.jpg',
    desc: 'Lắp đặt hệ thống thang máy kính tròn nhập khẩu nguyên chiếc từ Thụy Điển.'
  },
  { 
    id: 2, 
    title: 'Căn hộ Shophouse Sala Thủ Thiêm', 
    customer: 'Chị Lan', 
    date: 'Tháng 10/2023',
    location: 'TP. Thủ Đức',
    image: '/images/3726039324607881804 (3).jpg',
    desc: 'Giải pháp thang máy gia đình không hố Pit cho nhà phố thương mại.'
  },
  { 
    id: 3, 
    title: 'Penhouse Vinhomes Central Park', 
    customer: 'Tập đoàn ABC', 
    date: 'Tháng 08/2023',
    location: 'Bình Thạnh, TP.HCM',
    image: '/images/3726039324607881804 (4).jpg',
    desc: 'Thang máy nội thất Inox gương vàng cực kỳ sang trọng phục vụ căn hộ cao cấp.'
  },
  { 
    id: 4, 
    title: 'Khách sạn Boutique Hotel Đà Lạt', 
    customer: 'Anh Hoàng', 
    date: 'Tháng 05/2023',
    location: 'Lâm Đồng',
    image: '/images/3726039324607881804 (1).jpg',
    desc: 'Hệ thống 2 thang máy tải khách đồng bộ phục vụ khách sạn 4 sao.'
  }
]
</script>

<template>
  <div class="projects">
    <section class="subpage-hero">
      <div class="hero-bg">
        <img src="/images/3726039324607881804 (2).jpg" alt="Projects Hero" />
        <div class="hero-overlay"></div>
      </div>
      <div class="container hero-content text-center">
        <h1>Dự Án Tiêu Biểu</h1>
        <p>Minh chứng cho chất lượng và sự tin tưởng của khách hàng.</p>
      </div>
    </section>

    <section class="section-padding container">
      <div class="grid-2">
        <div v-for="project in projects" :key="project.id" class="project-box animate-fade-in">
          <div class="box-image">
            <img :src="project.image" :alt="project.title" />
            <div class="overlay-info">
              <span class="location"><MapPin :size="14" /> {{ project.location }}</span>
              <span class="date"><Calendar :size="14" /> {{ project.date }}</span>
            </div>
          </div>
          <div class="box-content">
            <h3>{{ project.title }}</h3>
            <p class="customer">Khách hàng: <strong>{{ project.customer }}</strong></p>
            <p>{{ project.desc }}</p>
            <router-link to="/projects" class="btn-link">Chi tiết dự án <ExternalLink :size="14" /></router-link>
          </div>
        </div>
      </div>
    </section>

    <!-- Testimonials -->
    <section class="bg-light section-padding">
        <div class="container text-center mb-5">
            <h4 class="label">PHẢN HỒI</h4>
            <h2>Khách hàng nói gì về <span class="text-gradient">BaoThangMay</span></h2>
        </div>
        <div class="container grid-3">
            <div class="testimonial-card glass">
                <p>"Tôi rất hài lòng với sự tư vấn tận tình của đội ngũ kỹ sư BaoThangMay. Chiếc thang máy kính thực sự là điểm nhấn cho ngôi nhà của tôi."</p>
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
                <p>"Giải pháp không hố Pit của BaoThangMay đã giúp tôi lắp được thang máy cho căn nhà cũ mà không cần cải tạo quá nhiều."</p>
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
}

.box-content h3 {
    font-size: 1.5rem;
    margin-bottom: 1rem;
    color: var(--secondary);
}

.customer {
    color: var(--primary);
    margin-bottom: 1.5rem;
}

.box-content p:last-of-type {
    color: var(--text-light);
    margin-bottom: 2rem;
}

.btn-link {
    color: var(--primary);
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 0.5rem;
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

@media (max-width: 992px) {
  .grid-2 {
    grid-template-columns: 1fr;
  }
}
</style>
