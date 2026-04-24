<script setup>
import { MapPin, Phone, Mail, Send, Facebook, Instagram, Linkedin, Loader2 } from 'lucide-vue-next'
import { ref, onMounted } from 'vue'
import contactApi from '@/api/contactApi'
import companyContactApi from '@/api/companyContactApi'
import { toast } from 'vue3-toastify'

const isSubmitting = ref(false)
const contacts = ref([])
const defaultHotline = '034 598 6669'
const normalizeHotline = (value) => {
  const cleaned = String(value || '').replace(/\s+/g, '')
  if (!cleaned || cleaned === '0900000000' || cleaned === '090000000') return defaultHotline
  return value
}

onMounted(async () => {
  try {
    const res = await companyContactApi.getPublic()
    contacts.value = res.data || []
  } catch (error) {
    console.error('Error fetching contacts:', error)
  }
})

const getVal = (key) => contacts.value.find(c => c.configKey === key)?.configValue || ''
const formData = ref({
  fullName: '',
  phoneNumber: '',
  email: '',
  subject: 'Tư vấn lắp đặt',
  message: ''
})

const submitForm = async () => {
  isSubmitting.value = true
  try {
    await contactApi.create({
      fullName: formData.value.fullName,
      phone: formData.value.phoneNumber,
      email: formData.value.email,
      subject: formData.value.subject,
      message: formData.value.message
    })
    toast.success('Cảm ơn bạn đã gửi liên hệ! Chúng tôi sẽ phản hồi sớm nhất.')
    formData.value = {
      fullName: '',
      phoneNumber: '',
      email: '',
      subject: 'Tư vấn lắp đặt',
      message: ''
    }
  } catch (error) {
    console.error('Error submitting contact:', error)
    toast.error('Có lỗi xảy ra, vui lòng thử lại sau.')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<template>
  <div class="contact">
    <section class="subpage-hero">
      <div class="hero-bg">
        <img src="https://images.unsplash.com/photo-1541819361361-b5413156942a?q=80&w=2000" alt="Contact Hero" />
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
          <h2>Kết nối với <span class="text-gradient">Misel</span></h2>
          <p class="mb-5">Chúng tôi luôn sẵn sàng lắng nghe và tư vấn giải pháp tốt nhất cho nhu cầu của bạn. Đừng ngần ngại liên hệ qua các kênh dưới đây:</p>
          
          <div class="info-cards">
            <div class="info-card glass">
              <MapPin :size="24" class="icon" />
              <div>
                <h3>Địa chỉ</h3>
                <p><strong>Trụ sở chính:</strong> {{ getVal('address') || 'Số 12 Hẻm 35/7/1 Tu Hoàng, P. Xuân Phương, Hà Nội' }}</p>
                <p v-if="getVal('address_2')"><strong>Chi nhánh 2:</strong> {{ getVal('address_2') }}</p>
              </div>
            </div>
            <div class="info-card glass">
              <Phone :size="24" class="icon" />
              <div>
                <h3>Hotline 24/7</h3>
                <p>Hotline: {{ normalizeHotline(getVal('hotline')) }}</p>
              </div>
            </div>
            <div class="info-card glass">
              <Mail :size="24" class="icon" />
              <div>
                <h3>Email</h3>
                <p>{{ getVal('email') || 'info@thangmaymisel.com' }}</p>
              </div>
            </div>
          </div>

          <div class="social-connect mt-5">
            <h3>Theo dõi chúng tôi</h3>
            <div class="social-btns">
              <a :href="getVal('facebook_url') || 'https://web.facebook.com/thangmaymisel'" target="_blank" class="social-btn fb"><Facebook :size="20" /></a>
              <a :href="getVal('instagram_url') || '#'" target="_blank" class="social-btn ig"><Instagram :size="20" /></a>
              <a :href="getVal('linkedin_url') || '#'" target="_blank" class="social-btn li"><Linkedin :size="20" /></a>
              <a :href="getVal('zalo_url') || 'https://zalo.me/0345986669'" target="_blank" class="social-btn zalo">
                <img src="/images.png" alt="Zalo" style="width: 24px; height: 24px; object-fit: contain;" />
              </a>
            </div>
          </div>
        </div>

        <!-- Contact Form -->
        <div class="contact-form-side glass animate-fade-in">
          <h3>Gửi yêu cầu tư vấn</h3>
          <p class="mb-4">Vui lòng để lại thông tin, chuyên viên của chúng tôi sẽ gọi lại ngay để báo giá chi tiết.</p>
          
          <form @submit.prevent="submitForm">
            <div class="form-group">
                <label>Họ và tên *</label>
                <input type="text" v-model="formData.fullName" placeholder="Nhập họ tên của bạn" required />
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Số điện thoại *</label>
                    <input type="tel" v-model="formData.phoneNumber" placeholder="VD: 0912345678" required />
                </div>
                <div class="form-group">
                    <label>Email (nếu có)</label>
                    <input type="email" v-model="formData.email" placeholder="VD: example@mail.com" />
                </div>
            </div>
            <div class="form-group">
                <label>Dịch vụ quan tâm</label>
                <select v-model="formData.subject">
                    <option value="Tư vấn lắp đặt">Tư vấn lắp đặt</option>
                    <option value="Báo giá thang máy">Báo giá thang máy gia đình</option>
                    <option value="Bảo trì - Bảo dưỡng">Bảo trì - Bảo dưỡng</option>
                    <option value="Sửa chữa - Nâng cấp">Sửa chữa - Nâng cấp</option>
                    <option value="Hợp tác đại lý">Hợp tác đại lý</option>
                </select>
            </div>
            <div class="form-group">
                <label>Ghi chú yêu cầu</label>
                <textarea v-model="formData.message" rows="4" placeholder="VD: Tôi muốn lắp thang máy kính cho nhà 4 tầng..."></textarea>
            </div>
            <button type="submit" class="btn btn-primary w-full lg" :disabled="isSubmitting">
                <Loader2 v-if="isSubmitting" class="spinner" :size="18" />
                <Send v-else :size="18" />
                Gửi liên hệ ngay
            </button>
          </form>
        </div>
      </div>
    </section>

    <!-- Map -->
    <section class="map-section section-padding">
        <div class="container overflow-hidden rounded-20 shadow-lg">
            <iframe v-if="getVal('map_embed_url')"
                :src="getVal('map_embed_url')" 
                width="100%" 
                height="450" 
                style="border:0;" 
                allowfullscreen="" 
                loading="lazy">
            </iframe>
            <iframe v-else
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
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
}

.rounded-20 {
    border-radius: 20px;
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
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

  .contact-info-side h2 {
    font-size: 1.9rem;
  }

  .info-card {
    padding: 1.25rem;
    gap: 1rem;
  }

  .contact-form-side {
    padding: 1.5rem;
    border-radius: 16px;
  }

  .form-group {
    margin-bottom: 1rem;
  }

  input, select, textarea {
    padding: 0.9rem;
  }

  button[type="submit"] {
    width: 100%;
  }

  .social-btns {
    flex-wrap: wrap;
  }

  .social-btn {
    width: 42px;
    height: 42px;
  }

  iframe {
    height: 320px;
  }
}
</style>
