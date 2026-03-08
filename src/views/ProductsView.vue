<script setup>
import { ShoppingCart, Search, ArrowRight } from 'lucide-vue-next'
import { ref, computed } from 'vue'

const products = [
  { id: 1, name: 'Thang máy gia đình', category: 'Home', image: '/images/3653228387362596575.jpg', price: 'Liên hệ', desc: 'Thang máy gia đình hiện đại với thiết kế tinh xảo, tiết kiệm diện tích.' },
  { id: 2, name: 'Thang máy biệt thự', category: 'Premium', image: '/images/3726039324607881804 (1).jpg', price: 'Liên hệ', desc: 'Sự lựa chọn hoàn hảo cho các công trình biệt thự cao cấp.' },
  { id: 3, name: 'Thang máy kính', category: 'Art', image: '/images/56463040787009741.jpg', price: 'Liên hệ', desc: 'Vẻ đẹp hiện đại, cho phép quan sát toàn cảnh không gian.' },
  { id: 4, name: 'Thang máy tải khách', category: 'Commercial', image: '/images/3726039324607881804 (2).jpg', price: 'Liên hệ', desc: 'An toàn, bền bỉ và hiệu suất cao cho các tòa nhà.' },
  { id: 5, name: 'Thang máy tải hàng', category: 'Industry', image: '/images/1218206096172762156.jpg', price: 'Liên hệ', desc: 'Chịu lực tốt, vận hành ổn định trong môi trường công nghiệp.' },
  { id: 6, name: 'Linh kiện thang máy', category: 'Parts', image: '/images/3295663955585252783.jpg', price: 'Liên hệ', desc: 'Linh kiện chính hãng được nhập khẩu từ Châu Âu.' }
]

const categories = ['Tất cả', 'Home', 'Premium', 'Art', 'Commercial', 'Industry', 'Parts']
const activeCategory = ref('Tất cả')

const filteredProducts = computed(() => {
  if (activeCategory.value === 'Tất cả') return products
  return products.filter(p => p.category === activeCategory.value)
})
</script>

<template>
  <div class="products">
    <section class="subpage-hero">
      <div class="hero-bg">
        <img src="/images/3726039324607881804 (5).jpg" alt="Products Hero" />
        <div class="hero-overlay"></div>
      </div>
      <div class="container hero-content text-center">
        <h1>Sản Phẩm Thang Máy</h1>
        <p>Tìm giải pháp di chuyển tối ưu cho công trình của bạn.</p>
      </div>
    </section>

    <!-- Filters -->
    <section class="section-padding container">
      <div class="filters animate-fade-in">
        <div class="category-tabs">
          <button 
            v-for="cat in categories" 
            :key="cat" 
            :class="['tab-btn', activeCategory === cat ? 'active' : '']"
            @click="activeCategory = cat"
          >
            {{ cat }}
          </button>
        </div>
        <div class="search-bar glass">
          <Search :size="18" />
          <input type="text" placeholder="Tìm kiếm sản phẩm..." />
        </div>
      </div>

      <div class="grid-3 mt-5">
        <div v-for="product in filteredProducts" :key="product.id" class="product-card animate-fade-in">
          <div class="product-img">
            <img :src="product.image" :alt="product.name" />
            <div class="badge">{{ product.category }}</div>
          </div>
          <div class="product-info">
            <h3>{{ product.name }}</h3>
            <p>{{ product.desc }}</p>
            <div class="price-row">
              <span class="price-val">{{ product.price }}</span>
              <router-link :to="'/products/' + product.id" class="btn btn-primary sm">Chi tiết</router-link>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Product Inquiry Section -->
    <section class="bg-dark section-padding text-center">
      <div class="container animate-fade-in">
        <h2 class="text-white">Không tìm thấy sản phẩm phù hợp?</h2>
        <p class="text-white opacity-0.8 mb-4">Hãy để chúng tôi thiết kế riêng cho bạn giải pháp thang máy phù hợp nhất.</p>
        <router-link to="/contact" class="btn btn-primary lg">Liên hệ tư vấn thiết kế</router-link>
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

.filters {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 2rem;
  border-bottom: 1px solid #eee;
  padding-bottom: 2rem;
}

.category-tabs {
  display: flex;
  gap: 1rem;
  overflow-x: auto;
  padding-bottom: 0.5rem;
}

.tab-btn {
  background: #f8f9fa;
  border: none;
  padding: 0.8rem 1.5rem;
  border-radius: 4px;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transition);
  white-space: nowrap;
}

.tab-btn:hover, .tab-btn.active {
  background: var(--primary);
  color: white;
}

.search-bar {
  display: flex;
  align-items: center;
  padding: 0.7rem 1.2rem;
  border-radius: 4px;
  border: 1px solid rgba(0,0,0,0.1);
  min-width: 300px;
}

.search-bar input {
  border: none;
  background: transparent;
  margin-left: 0.8rem;
  width: 100%;
  outline: none;
}

.product-card {
  box-shadow: 0 4px 15px rgba(0,0,0,0.05);
  border-radius: 12px;
  overflow: hidden;
  background: white;
  transition: var(--transition);
}

.product-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 30px rgba(0,0,0,0.1);
}

.product-img {
  position: relative;
  height: 250px;
}

.product-img .badge {
  position: absolute;
  top: 1rem;
  left: 1rem;
  background: var(--primary);
  color: white;
  padding: 0.3rem 1rem;
  border-radius: 20px;
  font-size: 0.75rem;
  text-transform: uppercase;
  font-weight: 700;
}

.product-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.product-info {
  padding: 2rem;
}

.product-info h3 {
  margin-bottom: 1rem;
  color: var(--secondary);
}

.product-info p {
  font-size: 0.95rem;
  color: var(--text-light);
  margin-bottom: 2rem;
  height: 60px;
  overflow: hidden;
}

.price-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.price-val {
  color: var(--primary);
  font-weight: 800;
  font-size: 1.25rem;
}

.btn.sm {
  padding: 0.6rem 1.5rem;
  font-size: 0.85rem;
}

.bg-dark {
  background: var(--bg-dark);
}

.text-white {
  color: white;
}

@media (max-width: 768px) {
  .filters {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
