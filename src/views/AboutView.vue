<script setup>
import { CheckCircle, History, Target, Users } from 'lucide-vue-next'

const values = [
  { title: 'Tận tâm', desc: 'Luôn lắng nghe và thấu hiểu nhu cầu của khách hàng để mang đến giải pháp tốt nhất.' },
  { title: 'Sáng tạo', desc: 'Không ngừng đổi mới công nghệ và thiết kế để dẫn đầu xu hướng thị trường.' },
  { title: 'Chất lượng', desc: 'Cam kết mỗi sản phẩm đều đạt tiêu chuẩn an toàn khắt khe nhất của quốc tế.' }
]
</script>

<template>
  <div class="about">
    <section class="subpage-hero">
      <div class="hero-bg">
        <img src="https://images.unsplash.com/photo-1541819361361-b5413156942a?q=80&w=2000" alt="About Hero" />
        <div class="hero-overlay"></div>
      </div>
      <div class="container hero-content text-center">
        <h1>Về Chúng Tôi</h1>
        <p>Hơn một thập kỷ nâng tầm không gian sống Việt.</p>
      </div>
    </section>

    <section class="section-padding container">
      <div class="intro-grid animate-fade-in">
        <div class="intro-text">
          <h4 class="label">CÂU CHUYỆN THƯƠNG HIỆU</h4>
          <h2>Misel – Sự kết hợp hoàn hảo giữa <br/><span class="text-gradient">Công nghệ & Nghệ thuật</span></h2>
          <p>Được thành lập với khát vọng mang đến những giải pháp di chuyển an toàn, sang trọng và hiện đại cho các công trình Việt, Misel đã không ngừng nỗ lực để trở thành đối tác tin cậy của hàng nghìn khách hàng trên khắp cả nước.</p>
          <p>Chúng tôi hiểu rằng, mỗi chiếc thang máy không chỉ là một thiết bị kỹ thuật, mà còn là trái tim của ngôi nhà, là nơi kết nối các thành viên và thể hiện đẳng cấp của gia chủ. Vì vậy, mỗi sản phẩm của Misel đều được cá nhân hóa tối đa theo phong cách kiến trúc và sở thích riêng biệt.</p>
          <div class="milestones">
            <div class="milestone">
              <History :size="32" class="milestone-icon" />
              <div>
                <h4>2012</h4>
                <p>Khởi đầu với xưởng cơ khí chính xác tại TP.HCM</p>
              </div>
            </div>
            <div class="milestone">
              <Target :size="32" class="milestone-icon" />
              <div>
                <h4>2018</h4>
                <p>Trở thành đơn vị phân phối chính hãng linh kiện Châu Âu</p>
              </div>
            </div>
            <div class="milestone">
              <Users :size="32" class="milestone-icon" />
              <div>
                <h4>2024</h4>
                <p>Mở rộng mạng lưới bảo trì trên toàn lãnh thổ Việt Nam</p>
              </div>
            </div>
          </div>
        </div>
        <div class="intro-image">
          <img src="/images/d0ca929ac1724f2c1663.jpg" alt="About Misel" />
        </div>
      </div>
    </section>

    <section class="values section-padding">
      <div class="container">
        <div class="text-center mb-5">
          <h4 class="label">GIÁ TRỊ CỐT LÕI</h4>
          <h2>Những gì chúng tôi <span class="text-gradient">luôn theo đuổi</span></h2>
        </div>
        <div class="grid-3">
          <div v-for="val in values" :key="val.title" class="value-card glass">
            <div class="value-icon"><CheckCircle :size="40" /></div>
            <h3>{{ val.title }}</h3>
            <p>{{ val.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <section class="section-padding container-narrow">
      <h2 class="text-center mb-5">Tầm nhìn & Sứ mệnh</h2>
      <div class="vision-mission">
        <div class="box mission glass">
          <h3>Sứ mệnh</h3>
          <p>Mang đến cho khách hàng những giải pháp thang máy tiên tiến, giúp việc di chuyển trong các công trình trở nên thuận tiện, an toàn và sang trọng nhất.</p>
        </div>
        <div class="box vision glass">
          <h3>Tầm nhìn</h3>
          <p>Trở thành biểu tượng uy tín hàng đầu Đông Nam Á trong lĩnh vực thang máy nội thất và công trình dân dụng cao cấp.</p>
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

.subpage-hero .hero-overlay {
  background: rgba(0, 0, 0, 0.6);
}

.subpage-hero h1 {
  font-size: 3.5rem;
  color: white;
  margin-bottom: 1rem;
}

.intro-grid {
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: 4rem;
  align-items: center;
}

.label {
  color: var(--primary);
  letter-spacing: 2px;
  margin-bottom: 1rem;
  font-weight: 700;
}

.intro-text h2 {
  font-size: 2.5rem;
  margin-bottom: 2rem;
}

.intro-text p {
  color: var(--text-light);
}

.milestones {
  margin-top: 3rem;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.milestone {
  display: flex;
  gap: 1.5rem;
  align-items: flex-start;
}

.milestone-icon {
  color: var(--primary);
}

.milestone h4 {
  color: var(--secondary);
  font-size: 1.25rem;
  margin-bottom: 0.25rem;
}

.milestone p {
  font-size: 0.95rem;
}

.intro-image img {
  width: 100%;
  border-radius: 12px;
  box-shadow: var(--shadow);
}

.values {
  background: #fdfdfd;
}

.value-card {
  padding: 3rem 2rem;
  text-align: center;
  border-radius: 12px;
  background: white !important;
  box-shadow: 0 5px 20px rgba(0,0,0,0.03);
  transition: var(--transition);
}

.value-card:hover {
  transform: translateY(-10px);
  box-shadow: var(--shadow);
}

.value-icon {
  color: var(--primary);
  margin-bottom: 1.5rem;
}

.vision-mission {
  display: flex;
  gap: 2rem;
}

.box {
  flex: 1;
  padding: 3rem;
  border-radius: 16px;
  background: white !important;
  border: 1px solid rgba(193, 160, 82, 0.2);
}

.box h3 {
  color: var(--primary);
  margin-bottom: 1.5rem;
  font-size: 1.8rem;
}

@media (max-width: 992px) {
  .intro-grid {
    grid-template-columns: 1fr;
  }
  .vision-mission {
    flex-direction: column;
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

  .intro-text h2 {
    font-size: 1.8rem;
  }

  .milestones {
    margin-top: 2rem;
    gap: 1.25rem;
  }

  .milestone {
    gap: 1rem;
  }

  .grid-3 {
    grid-template-columns: 1fr;
  }

  .value-card {
    padding: 1.5rem;
  }

  .box {
    padding: 1.5rem;
  }
}
</style>
