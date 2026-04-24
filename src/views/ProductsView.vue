<script setup>
import { ShoppingCart, Search, Loader2 } from 'lucide-vue-next'
import { ref, computed, onMounted, watch } from 'vue'
import productApi from '@/api/productApi'
import categoryApi from '@/api/categoryApi'

const isLoading = ref(true)
const products = ref([])
const categories = ref([{ id: 'all', name: 'Tất cả' }])
const activeCategoryId = ref('all')
const activeProductFilter = ref('all')
const searchKeyword = ref('')

const resolveProducts = (payload) => payload?.content || payload?.items || payload || []
const resolveImageUrl = (product) => product?.thumbnail?.publicUrl || product?.thumbnail?.url || product?.images?.[0] || 'https://images.unsplash.com/photo-1541819361361-b5413156942a?q=80&w=800'
const resolveCategoryName = (product) => product?.categoryObj?.name || product?.category?.name || product?.category || ''
const categoryIconText = (category) => (category?.name || 'DM').slice(0, 2).toUpperCase()
const sortedCategories = computed(() => {
  const list = categories.value.filter(c => c.id !== 'all')
  return [{ id: 'all', name: 'Tất cả', description: 'Xem toàn bộ sản phẩm', iconUrl: '' }, ...list.sort((a, b) => (a.sortOrder ?? 0) - (b.sortOrder ?? 0))]
})
const selectedCategory = computed(() => sortedCategories.value.find(c => c.id === activeCategoryId.value) || sortedCategories.value[0])
const productFilters = [
  { id: 'all', label: 'Tất cả' },
  { id: 'featured', label: 'Nổi bật' },
  { id: 'newest', label: 'Mới nhất' }
]

const filteredProducts = computed(() => {
  let list = [...products.value]

  if (activeProductFilter.value === 'newest') {
    list = list.sort((a, b) => new Date(b.createdAt || 0) - new Date(a.createdAt || 0))
  }

  return list
})

const selectCategory = (categoryId) => {
  activeCategoryId.value = categoryId
  document.getElementById('product-list')?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

const selectProductFilter = (filterId) => {
  activeProductFilter.value = filterId
  document.getElementById('product-list')?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

const fetchCategories = async () => {
  try {
    const res = await categoryApi.listActive()
    if (res.data) {
      categories.value = [{ id: 'all', name: 'Tất cả' }, ...res.data]
    }
  } catch (error) {
    console.error('Error fetching categories:', error)
  }
}

const fetchProducts = async () => {
  isLoading.value = true
  try {
    const params = {
      keyword: searchKeyword.value,
      categoryId: activeCategoryId.value === 'all' ? null : activeCategoryId.value,
      featured: activeProductFilter.value === 'featured' ? true : null,
      isActive: true
    }
    const res = await productApi.publicSearch(params)
    products.value = resolveProducts(res.data)
  } catch (error) {
    console.error('Error fetching products:', error)
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  fetchCategories()
  fetchProducts()
})

// Debounce search
let timeout = null
watch(searchKeyword, () => {
  if (timeout) clearTimeout(timeout)
  timeout = setTimeout(() => {
    fetchProducts()
  }, 500)
})

watch(activeCategoryId, () => {
  fetchProducts()
})

watch(activeProductFilter, () => {
  fetchProducts()
})
</script>

<template>
  <div class="products">
    <section class="subpage-hero">
      <div class="hero-bg">
        <img src="https://images.unsplash.com/photo-1541819361361-b5413156942a?q=80&w=2000" alt="Products Hero" />
        <div class="hero-overlay"></div>
      </div>
      <div class="container hero-content text-center">
        <h1>Sản Phẩm Thang Máy</h1>
        <p>Tìm giải pháp di chuyển tối ưu cho công trình của bạn.</p>
      </div>
    </section>

    <!-- Filters -->
    <section class="section-padding container">
      <div class="category-section animate-fade-in">
        <div class="section-head">
          <div>
            <h4 class="label">DANH MỤC</h4>
            <h2>Lựa chọn danh mục sản phẩm</h2>
            <p class="section-copy">{{ selectedCategory?.description || 'Chọn danh mục để xem nhóm sản phẩm phù hợp.' }}</p>
          </div>
          <div class="search-bar glass">
            <Search :size="18" />
            <input v-model="searchKeyword" type="text" placeholder="Tìm kiếm sản phẩm..." />
          </div>
        </div>

        <div class="category-grid">
          <button
            v-for="cat in sortedCategories"
            :key="cat.id"
            :class="['category-card', activeCategoryId === cat.id ? 'active' : '']"
            @click="selectCategory(cat.id)"
          >
            <div class="category-icon" :class="{ image: !!cat.iconUrl }">
              <img v-if="cat.iconUrl" :src="cat.iconUrl" :alt="cat.name" />
              <span v-else>{{ categoryIconText(cat) }}</span>
            </div>
            <div class="category-meta">
              <h3>{{ cat.name }}</h3>
            </div>
          </button>
        </div>
      </div>

        <div class="list-head">
          <div>
            <h4 class="label">KẾT QUẢ TÌM KIẾM</h4>
            <h3>{{ selectedCategory?.name || 'Tất cả' }}</h3>
          </div>
          <div class="list-count text-muted">
            Đang hiển thị {{ filteredProducts.length }} sản phẩm
          </div>
        </div>

      <div class="product-filters">
        <button
          v-for="filter in productFilters"
          :key="filter.id"
          :class="['tab-btn', activeProductFilter === filter.id ? 'active' : '']"
          @click="selectProductFilter(filter.id)"
        >
          {{ filter.label }}
        </button>
      </div>

      <div id="product-list" class="grid-3 mt-5 relative min-h-300">
        <div v-if="isLoading" class="flex-center col-span-full py-5">
           <Loader2 class="spinner text-primary" :size="48" />
        </div>
        <template v-else>
          <div v-if="filteredProducts.length === 0" class="col-span-full py-5 text-center text-muted">
            Không tìm thấy sản phẩm nào trong danh mục này.
          </div>
          <div v-for="product in filteredProducts" :key="product.id" class="product-card animate-fade-in">
            <div class="product-img">
              <img :src="resolveImageUrl(product)" :alt="product.name || 'Sản phẩm thang máy'" />
              <div v-if="resolveCategoryName(product)" class="badge">{{ resolveCategoryName(product) }}</div>
            </div>
            <div class="product-info">
              <h3>{{ product.name || 'Chưa có tiêu đề' }}</h3>
              <p class="truncate-2">{{ product.summary || product.desc || 'Chưa có mô tả ngắn.' }}</p>
              <div class="price-row">
                <span class="price-val">{{ product.price || 'Liên hệ' }}</span>
                <router-link :to="'/products/' + product.id" class="btn btn-primary sm">Chi tiết</router-link>
              </div>
            </div>
          </div>
        </template>
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

  .category-section {
    margin-bottom: 2rem;
  }

  .section-head {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    gap: 2rem;
    margin-bottom: 1.5rem;
  }

  .section-copy {
    max-width: 620px;
    color: var(--text-light);
    margin-top: 0.5rem;
    line-height: 1.7;
  }

  .category-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 1rem;
    margin-top: 1.25rem;
  }

  .category-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 0.8rem;
    text-align: center;
    min-height: 150px;
    padding: 1rem;
    border: 1px solid #ece7da;
    border-radius: 16px;
    background: #fff;
    box-shadow: 0 10px 30px rgba(14, 25, 38, 0.05);
    transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease, background 0.25s ease;
  }

  .category-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 18px 40px rgba(14, 25, 38, 0.1);
  }

  .category-card.active {
    border-color: var(--primary);
    background: #faf7ef;
    box-shadow: 0 18px 40px rgba(193, 160, 82, 0.18);
  }

  .category-icon {
    width: 46px;
    height: 46px;
    border-radius: 14px;
    background: rgba(193, 160, 82, 0.12);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--secondary);
    font-weight: 800;
    overflow: hidden;
    flex: none;
  }

  .category-icon img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .category-meta h3 {
    color: var(--secondary);
    margin-bottom: 0;
  }

  .category-meta p {
    margin: 0;
    color: var(--text-light);
    line-height: 1.6;
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
    border-radius: 999px;
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

  .list-head {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    gap: 1rem;
    margin-top: 3rem;
    padding-top: 2rem;
    border-top: 1px solid #eee;
  }

  .list-head h3 {
    margin: 0.25rem 0 0;
    color: var(--secondary);
    font-size: 1.6rem;
  }

  .list-count {
    white-space: nowrap;
    font-size: 0.95rem;
  }

  .product-filters {
    display: flex;
    gap: 0.75rem;
    margin-top: 1.25rem;
    flex-wrap: wrap;
  }

@media (max-width: 768px) {
    .section-head {
      flex-direction: column;
      align-items: stretch;
    }

    .search-bar {
      min-width: 0;
      width: 100%;
    }

    .list-head {
      align-items: flex-start;
      flex-direction: column;
    }

    .list-count {
      white-space: normal;
    }

    .product-filters {
      gap: 0.5rem;
      overflow-x: auto;
      flex-wrap: nowrap;
      padding-bottom: 0.25rem;
    }
  }

@media (max-width: 480px) {
  .subpage-hero {
    height: 260px;
  }

  .subpage-hero h1 {
    font-size: 2rem;
  }

  .subpage-hero p {
    font-size: 0.92rem;
  }

  .section-padding.container {
    padding-top: 48px;
    padding-bottom: 48px;
  }

  .category-grid {
    grid-template-columns: 1fr;
  }

  .category-card {
    min-height: 120px;
    padding: 0.9rem;
  }

  .search-bar {
    padding: 0.65rem 1rem;
  }

  .list-head {
    margin-top: 2rem;
    padding-top: 1.5rem;
  }

  .product-filters {
    gap: 0.4rem;
  }

  .tab-btn {
    padding: 0.7rem 1rem;
  }

  #product-list {
    grid-template-columns: 1fr;
  }

  .product-img {
    height: 200px;
  }

  .product-info {
    padding: 1.25rem;
  }

  .price-row {
    flex-direction: column;
    align-items: stretch;
    gap: 0.75rem;
  }

  .btn.sm {
    width: 100%;
    text-align: center;
  }
}

.product-card {
  box-shadow: 0 4px 15px rgba(0,0,0,0.05);
  border-radius: 12px;
  overflow: hidden;
  background: white;
  transition: var(--transition);
  height: 100%;
  display: flex;
  flex-direction: column;
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
  flex: 1;
  display: flex;
  flex-direction: column;
}

.product-info h3 {
  margin-bottom: 1rem;
  color: var(--secondary);
}

.product-info p {
  font-size: 0.95rem;
  color: var(--text-light);
  margin-bottom: 2rem;
}

.truncate-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.price-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: auto;
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

.min-h-300 {
  min-height: 300px;
}

.col-span-full {
  grid-column: 1 / -1;
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

</style>
