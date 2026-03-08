<script setup>
import { MapPin, Phone, Mail, Send, Facebook, Instagram, Linkedin, MessageCircle } from 'lucide-vue-next'
import { ref } from 'vue'

const formData = ref({
  name: '',
  phone: '',
  email: '',
  service: 'Tư vấn lắp đặt',
  message: ''
})

const submitForm = () => {
    alert('Cảm ơn bạn đã gửi liên hệ! Chúng tôi sẽ phản hồi trong vòng 24h.')
    formData.value = {
        name: '',
        phone: '',
        email: '',
        service: 'Tư vấn lắp đặt',
        message: ''
    }
}
</script>

<template>
  <div class="contact">
    <section class="subpage-hero">
      <div class="hero-bg">
        <img src="/images/3726039324607881804 (6).jpg" alt="Contact Hero" />
        <div class="hero-overlay"></div>
      </div>
      <div class="container hero-content text-center">
        <h1>Liên Hệ Với Chúng Tôi</h1>
        <p>Kiến tạo không gian di chuyển hoàn mỹ cho công trình của bạn.</p>
      </div>
    </section>

    <section class="section-padding container">
      <div class="contact-grid">
        <!-- Contact Info -->
        <div class="contact-info-side">
          <h4 class="label">THÔNG TIN LIÊN HỆ</h4>
          <h2>Kết nối với <span class="text-gradient">BaoThangMay</span></h2>
          <p class="mb-5">Chúng tôi luôn sẵn sàng lắng nghe và tư vấn giải pháp tốt nhất cho nhu cầu của bạn. Đừng ngần ngại liên hệ qua các kênh dưới đây:</p>
          
          <div class="info-cards">
            <div class="info-card glass">
              <MapPin :size="24" class="icon" />
              <div>
                <h3>Địa chỉ</h3>
                <p>Số 123 Đường Láng, Quận Đống Đa, Hà Nội</p>
              </div>
            </div>
            <div class="info-card glass">
              <Phone :size="24" class="icon" />
              <div>
                <h3>Hotline 24/7</h3>
                <p>0912.345.678 (Kỹ thuật)</p>
                <p>0988.777.666 (Kinh doanh)</p>
              </div>
            </div>
            <div class="info-card glass">
              <Mail :size="24" class="icon" />
              <div>
                <h3>Email</h3>
                <p>info@baothangmay.vn</p>
                <p>sales@baothangmay.vn</p>
              </div>
            </div>
          </div>

          <div class="social-connect mt-5">
            <h3>Theo dõi chúng tôi</h3>
            <div class="social-btns">
              <a href="#" class="social-btn fb"><Facebook :size="20" /></a>
              <a href="#" class="social-btn ig"><Instagram :size="20" /></a>
              <a href="#" class="social-btn li"><Linkedin :size="20" /></a>
              <a href="https://zalo.me/0912345678" target="_blank" class="social-btn zalo">
                <img src="https://upload.wikimedia.org/wikipedia/commons/9/91/Icon_Zalo.png" alt="Zalo" width="20" />
              </a>
            </div>
          </div>
        </div>

        <!-- Contact Form -->
        <div class="contact-form-side glass">
          <h3>Gửi yêu cầu tư vấn</h3>
          <p class="mb-4">Vui lòng để lại thông tin, chuyên viên của chúng tôi sẽ gọi lại ngay để báo giá chi tiết.</p>
          
          <form @submit.prevent="submitForm">
            <div class="form-group">
                <label>Họ và tên *</label>
                <input type="text" v-model="formData.name" placeholder="Nhập họ tên của bạn" required />
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Số điện thoại *</label>
                    <input type="tel" v-model="formData.phone" placeholder="VD: 0912345678" required />
                </div>
                <div class="form-group">
                    <label>Email (nếu có)</label>
                    <input type="email" v-model="formData.email" placeholder="VD: example@mail.com" />
                </div>
            </div>
            <div class="form-group">
                <label>Dịch vụ quan tâm</label>
                <select v-model="formData.service">
                    <option>Tư vấn lắp đặt</option>
                    <option>Báo giá thang máy gia đình</option>
                    <option>Bảo trì - Bảo dưỡng</option>
                    <option>Sửa chữa - Nâng cấp</option>
                    <option>Hợp tác đại lý</option>
                </select>
            </div>
            <div class="form-group">
                <label>Ghi chú yêu cầu</label>
                <textarea v-model="formData.message" rows="4" placeholder="VD: Tôi muốn lắp thang máy kính cho nhà 4 tầng..."></textarea>
            </div>
            <button type="submit" class="btn btn-primary w-full lg"><Send :size="18" /> Gửi liên hệ ngay</button>
          </form>
        </div>
      </div>
    </section>

    <!-- Map -->
    <section class="map-section section-padding">
        <div class="container overflow-hidden rounded-20 shadow-lg">
            <iframe 
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.0854441674482!2d105.815228!3d21.03!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ab6ad5a88c79%3A0x9f53e070c793664d!2zMTIzIMSQxrDhu51uZyBMw6FuZywgSOG6o2kgQsOgIFRyxrBuZywgSMOgIE7hu5lpLCBWaeG7h3QgTmFt!5e0!3m2!1svi!2s!4v1710000000000!5m2!1svi!2s" 
                width="100%" 
                height="450" 
                style="border:0;" 
                allowfullscreen="" 
                loading="lazy">
            </iframe>
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

.contact-grid {
    display: grid;
    grid-template-columns: 1fr 1.2fr;
    gap: 5rem;
    align-items: flex-start;
}

.contact-info-side h2 {
    font-size: 2.5rem;
    margin-bottom: 2rem;
}

.info-cards {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.info-card {
    display: flex;
    gap: 1.5rem;
    padding: 2rem;
    border-radius: 12px;
    background: white !important;
    transition: var(--transition);
}

.info-card:hover {
    transform: translateX(10px);
    border-color: var(--primary);
}

.info-card .icon {
    color: var(--primary);
    flex-shrink: 0;
}

.info-card h3 {
    font-size: 1.25rem;
    margin-bottom: 0.5rem;
    color: var(--secondary);
}

.info-card p {
    color: var(--text-light);
    font-size: 1rem;
    line-height: 1.6;
}

.social-btns {
    display: flex;
    gap: 1rem;
    margin-top: 1rem;
}

.social-btn {
    width: 45px;
    height: 45px;
    border-radius: 50%;
    background: #f0f0f0;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #555;
    transition: var(--transition);
}

.social-btn:hover {
    background: var(--primary);
    color: white;
    transform: translateY(-3px);
}

.contact-form-side {
    padding: 3rem;
    border-radius: 20px;
    background: white !important;
    box-shadow: 0 10px 40px rgba(0,0,0,0.05);
}

.contact-form-side h3 {
    font-size: 1.8rem;
    margin-bottom: 1rem;
    color: var(--secondary);
}

.form-group {
    margin-bottom: 1.5rem;
}

.form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.5rem;
}

label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 600;
    color: var(--text-main);
}

input, select, textarea {
    width: 100%;
    padding: 1rem;
    border: 1px solid #ddd;
    border-radius: 8px;
    outline: none;
    transition: var(--transition);
    background: #fdfdfd;
}

input:focus, select:focus, textarea:focus {
    border-color: var(--primary);
    box-shadow: 0 0 0 3px rgba(193, 160, 82, 0.1);
    background: white;
}

button[type="submit"] {
    margin-top: 1rem;
}

.rounded-20 {
    border-radius: 20px;
}

@media (max-width: 992px) {
  .contact-grid {
    grid-template-columns: 1fr;
    gap: 3rem;
  }
  .form-row {
      grid-template-columns: 1fr;
      gap: 0;
  }
}
</style>
