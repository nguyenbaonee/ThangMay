<script setup>
import { MapPin, Phone, Mail, Facebook, Instagram, Linkedin, Send } from 'lucide-vue-next'
</script>

<template>
  <footer class="footer">
    <div class="container footer-content">
      <div class="footer-grid">
        <!-- Brand -->
        <div class="footer-brand">
          <router-link to="/" class="logo">
            <span class="logo-text">BaoThangMay</span>
            <span class="logo-subtext">Elevating Living</span>
          </router-link>
          <p class="brand-desc">
            Chuyên gia cung cấp giải pháp thang máy nội thất và công trình cao tầng. 
            Kiến tạo không gian sống hiện đại, an toàn và sang trọng.
          </p>
          <div class="social-links">
            <a href="#"><Facebook :size="20" /></a>
            <a href="#"><Instagram :size="20" /></a>
            <a href="#"><Linkedin :size="20" /></a>
          </div>
        </div>

        <!-- Links -->
        <div class="footer-links">
          <h3>Dịch vụ</h3>
          <ul>
            <li><router-link to="/services">Tư vấn thiết kế</router-link></li>
            <li><router-link to="/services">Lắp đặt thang máy</router-link></li>
            <li><router-link to="/services">Bảo trì - Sửa chữa</router-link></li>
            <li><router-link to="/services">Nâng cấp thang máy</router-link></li>
          </ul>
        </div>

        <div class="footer-links">
          <h3>Sản phẩm</h3>
          <ul>
            <li><router-link to="/products">Thang máy gia đình</router-link></li>
            <li><router-link to="/products">Thang máy tải khách</router-link></li>
            <li><router-link to="/products">Thang máy tải hàng</router-link></li>
            <li><router-link to="/products">Linh kiện thang máy</router-link></li>
          </ul>
        </div>

        <!-- Contact -->
        <div class="footer-contact">
          <h3>Liên hệ</h3>
          <ul class="contact-info">
            <li>
              <MapPin :size="20" class="icon" />
              <span>Số 123 Đường Láng, Quận Đống Đa, Hà Nội</span>
            </li>
            <li>
              <Phone :size="20" class="icon" />
              <span>0912.345.678</span>
            </li>
            <li>
              <Mail :size="20" class="icon" />
              <span>info@baothangmay.vn</span>
            </li>
          </ul>
          <div class="newsletter">
            <input type="email" placeholder="Nhận bản tin..." />
            <button class="newsletter-btn"><Send :size="16" /></button>
          </div>
        </div>
      </div>
    </div>

    <!-- Bottom -->
    <div class="footer-bottom">
      <div class="container bottom-content">
        <p>&copy; 2024 BaoThangMay ELEVATOR. All rights reserved.</p>
        <div class="bottom-links">
          <a href="#">Điều khoản sử dụng</a>
          <a href="#">Chính sách bảo mật</a>
        </div>
      </div>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  background: var(--bg-dark);
  color: white;
  padding-top: 80px;
}

.footer-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 3rem;
  padding-bottom: 60px;
}

.footer-brand .logo {
  display: flex;
  flex-direction: column;
  margin-bottom: 1.5rem;
}

.logo-text {
  font-size: 2rem;
  font-weight: 800;
  color: white;
  letter-spacing: 2px;
}

.logo-subtext {
  font-size: 0.7rem;
  color: var(--primary);
  letter-spacing: 4px;
}

.brand-desc {
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 2rem;
  line-height: 1.8;
}

.social-links {
  display: flex;
  gap: 1.5rem;
}

.social-links a {
  width: 40px;
  height: 40px;
  background: rgba(255, 255, 255, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: var(--transition);
}

.social-links a:hover {
  background: var(--primary);
  transform: translateY(-3px);
}

.footer-links h3, .footer-contact h3 {
  color: white;
  margin-bottom: 2rem;
  font-size: 1.2rem;
  position: relative;
}

.footer-links h3::after, .footer-contact h3::after {
  content: '';
  position: absolute;
  bottom: -0.5rem;
  left: 0;
  width: 40px;
  height: 2px;
  background: var(--primary);
}

.footer-links ul li {
  margin-bottom: 1rem;
}

.footer-links ul li a {
  color: rgba(255, 255, 255, 0.7);
}

.footer-links ul li a:hover {
  color: var(--primary);
  padding-left: 0.5rem;
}

.contact-info li {
  display: flex;
  gap: 1rem;
  margin-bottom: 1.5rem;
  color: rgba(255, 255, 255, 0.7);
}

.contact-info .icon {
  color: var(--primary);
  flex-shrink: 0;
}

.newsletter {
  display: flex;
  margin-top: 2rem;
}

.newsletter input {
  flex: 1;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  padding: 0.8rem 1rem;
  border-radius: 4px 0 0 4px;
  color: white;
}

.newsletter-btn {
  background: var(--primary);
  border: none;
  width: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  border-radius: 0 4px 4px 0;
  cursor: pointer;
}

.footer-bottom {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 2rem 0;
  font-size: 0.9rem;
  color: rgba(255, 255, 255, 0.5);
}

.bottom-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.bottom-links {
  display: flex;
  gap: 2rem;
}

.bottom-links a:hover {
  color: white;
}

@media (max-width: 768px) {
  .footer-grid {
    grid-template-columns: 1fr;
    text-align: center;
  }
  .footer-links h3::after, .footer-contact h3::after {
    left: 50%;
    transform: translateX(-50%);
  }
  .contact-info li {
    justify-content: center;
  }
  .bottom-content {
    justify-content: center;
  }
}
</style>
