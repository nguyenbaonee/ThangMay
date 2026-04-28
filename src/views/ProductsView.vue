<script setup>
import { Search, Loader2, SlidersHorizontal, Phone, X, Check, LayoutGrid } from 'lucide-vue-next'
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

// Pick column count so every row has equal items
const categoryGridCols = computed(() => {
  const n = sortedCategories.value.length
  if (n <= 3) return n
  if (n <= 4) return 4
  if (n <= 6) return 3   // 6 → 3×2
  if (n <= 8) return 4   // 8 → 4×2
  if (n <= 9) return 3   // 9 → 3×3
  if (n <= 10) return 5  // 10 → 5×2
  if (n <= 12) return 4  // 12 → 4×3
  return Math.ceil(Math.sqrt(n))
})
const productFilters = [
  { id: 'all', label: 'Tất cả' },
  { id: 'featured', label: 'Nổi bật' },
  { id: 'newest', label: 'Mới nhất' }
]

// ── Spec filters ─────────────────────────────────────────────────────────────
const isFilterOpen = ref(false)

const loadOptions = [
  { label: '≤ 450 kg',       min: null,  max: 450  },
  { label: '450 – 750 kg',   min: 450,   max: 750  },
  { label: '750 – 1000 kg',  min: 750,   max: 1000 },
  { label: '> 1000 kg',      min: 1000,  max: null },
]
const speedOptions = [
  { label: '≤ 1.0 m/s',      min: null,  max: 1.0  },
  { label: '1.0 – 1.75 m/s', min: 1.0,   max: 1.75 },
  { label: '> 1.75 m/s',     min: 1.75,  max: null },
]

// draft state inside drawer (apply only on "Áp dụng")
const draftLoad  = ref(null)   // index into loadOptions or null
const draftSpeed = ref(null)   // index into speedOptions or null

// applied state (drives API)
const appliedLoad  = ref(null)
const appliedSpeed = ref(null)

const activeFilterCount = computed(() => {
  let count = 0
  if (appliedLoad.value  !== null) count++
  if (appliedSpeed.value !== null) count++
  return count
})

const openFilter = () => {
  // sync draft from applied
  draftLoad.value  = appliedLoad.value
  draftSpeed.value = appliedSpeed.value
  isFilterOpen.value = true
}
const closeFilter = () => { isFilterOpen.value = false }

const applyFilter = () => {
  appliedLoad.value  = draftLoad.value
  appliedSpeed.value = draftSpeed.value
  isFilterOpen.value = false
  fetchProducts()
}
const clearFilter = () => {
  draftLoad.value  = null
  draftSpeed.value = null
  appliedLoad.value  = null
  appliedSpeed.value = null
  isFilterOpen.value = false
  fetchProducts()
}

// ── Data helpers ──────────────────────────────────────────────────────────────
const filteredProducts = computed(() => {
  let list = [...products.value]
  if (activeProductFilter.value === 'newest') {
    list = list.sort((a, b) => new Date(b.createdAt || 0) - new Date(a.createdAt || 0))
  }
  return list
})

const selectCategory = (categoryId) => { activeCategoryId.value = categoryId }
const selectProductFilter = (filterId) => { activeProductFilter.value = filterId }

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
    const load  = appliedLoad.value  !== null ? loadOptions[appliedLoad.value]  : {}
    const speed = appliedSpeed.value !== null ? speedOptions[appliedSpeed.value] : {}
    const params = {
      keyword: searchKeyword.value,
      categoryId: activeCategoryId.value === 'all' ? null : activeCategoryId.value,
      featured: activeProductFilter.value === 'featured' ? true : null,
      isActive: true,
      loadMin:  load.min  ?? null,
      loadMax:  load.max  ?? null,
      speedMin: speed.min ?? null,
      speedMax: speed.max ?? null,
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

let timeout = null
watch(searchKeyword, () => {
  if (timeout) clearTimeout(timeout)
  timeout = setTimeout(() => { fetchProducts() }, 500)
})
watch(activeCategoryId, () => { fetchProducts() })
watch(activeProductFilter, () => { fetchProducts() })
</script>

<template>
  <div class="products-page">

    <!-- Search Bar -->
    <div class="search-section">
      <div class="search-wrap">
        <Search :size="18" class="search-icon" />
        <input
          v-model="searchKeyword"
          type="text"
          placeholder="Tìm kiếm giải pháp thang máy..."
          class="search-input"
        />
      </div>
    </div>

    <!-- Category Grid -->
    <div class="category-section">
      <div
        class="category-grid"
        :style="{ '--cat-cols': categoryGridCols }"
      >
        <button
          v-for="cat in sortedCategories"
          :key="cat.id"
          :class="['cat-item', activeCategoryId === cat.id ? 'active' : '']"
          @click="selectCategory(cat.id)"
        >
          <div class="cat-icon">
            <LayoutGrid v-if="cat.id === 'all'" :size="20" />
            <template v-else>
              <img v-if="cat.iconUrl" :src="cat.iconUrl" :alt="cat.name" />
              <span v-else>{{ categoryIconText(cat) }}</span>
            </template>
          </div>
          <span class="cat-name">{{ cat.name }}</span>
        </button>
      </div>
    </div>

    <!-- Filter Bar -->
    <div class="filter-bar">
      <div class="filter-tabs">
        <button
          v-for="f in productFilters"
          :key="f.id"
          :class="['filter-tab', activeProductFilter === f.id ? 'active' : '']"
          @click="selectProductFilter(f.id)"
        >
          {{ f.label }}
        </button>
      </div>
      <button :class="['filter-more', activeFilterCount > 0 ? 'active' : '']" @click="openFilter">
        <SlidersHorizontal :size="15" />
        Bộ lọc
        <span v-if="activeFilterCount > 0" class="filter-badge">{{ activeFilterCount }}</span>
      </button>
    </div>

    <!-- ── Filter Drawer ── -->
    <Teleport to="body">
      <Transition name="drawer">
        <div v-if="isFilterOpen" class="drawer-overlay" @click.self="closeFilter">
          <div class="drawer-panel">

            <!-- Header -->
            <div class="drawer-header">
              <h3>Bộ lọc sản phẩm</h3>
              <button class="drawer-close" @click="closeFilter"><X :size="20" /></button>
            </div>

            <!-- Tải trọng -->
            <div class="drawer-section">
              <p class="drawer-label">Tải trọng</p>
              <div class="drawer-options">
                <button
                  v-for="(opt, i) in loadOptions"
                  :key="i"
                  :class="['drawer-opt', draftLoad === i ? 'selected' : '']"
                  @click="draftLoad = (draftLoad === i ? null : i)"
                >
                  <span class="opt-check"><Check :size="12" /></span>
                  {{ opt.label }}
                </button>
              </div>
            </div>

            <!-- Tốc độ -->
            <div class="drawer-section">
              <p class="drawer-label">Tốc độ</p>
              <div class="drawer-options">
                <button
                  v-for="(opt, i) in speedOptions"
                  :key="i"
                  :class="['drawer-opt', draftSpeed === i ? 'selected' : '']"
                  @click="draftSpeed = (draftSpeed === i ? null : i)"
                >
                  <span class="opt-check"><Check :size="12" /></span>
                  {{ opt.label }}
                </button>
              </div>
            </div>

            <!-- Actions -->
            <div class="drawer-actions">
              <button class="drawer-clear" @click="clearFilter">Xóa bộ lọc</button>
              <button class="drawer-apply" @click="applyFilter">Áp dụng</button>
            </div>

          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- Product List -->
    <div id="product-list" class="product-list">
      <div v-if="isLoading" class="loading-wrap">
        <Loader2 class="spinner" :size="40" />
      </div>
      <template v-else>
        <div v-if="filteredProducts.length === 0" class="empty-state">
          Không tìm thấy sản phẩm nào.
        </div>
        <div
          v-for="product in filteredProducts"
          :key="product.id"
          class="product-card animate-fade-in"
        >
          <!-- Image -->
          <div class="card-img-wrap">
            <img
              :src="resolveImageUrl(product)"
              :alt="product.name || 'Sản phẩm thang máy'"
              class="card-img"
            />
            <span v-if="resolveCategoryName(product)" class="card-badge">
              {{ resolveCategoryName(product) }}
            </span>
          </div>

          <!-- Body -->
          <div class="card-body">
            <h3 class="card-title">{{ product.name || 'Chưa có tiêu đề' }}</h3>
            <p class="card-desc truncate-3">{{ product.summary || product.desc || 'Giải pháp thang máy chất lượng cao, được thiết kế tối ưu cho nhu cầu của bạn.' }}</p>
            <div class="card-actions">
              <a href="tel:0345986669" class="action-link">
                <Phone :size="14" />
                Liên hệ
              </a>
              <router-link :to="{ name: 'product-detail', params: { id: product.id } }" class="action-btn">
                Chi tiết →
              </router-link>
            </div>
          </div>
        </div>
      </template>
    </div>

  </div>
</template>

<style scoped>
/* ── Page wrapper ── */
.products-page {
  padding-top: 168px; /* desktop: banner(56) + top-bar(36) + nav(68) + 8px gap */
  min-height: 100vh;
  background: #f7f6f3;
}

/* ── Search ── */
.search-section {
  padding: 1.25rem 1rem 0.75rem;
  background: #f7f6f3;
}

.search-wrap {
  display: flex;
  align-items: center;
  background: #fff;
  border: 1px solid #e0ddd5;
  border-radius: 999px;
  padding: 0.65rem 1.1rem;
  gap: 0.6rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

.search-icon {
  color: #999;
  flex-shrink: 0;
}

.search-input {
  flex: 1;
  border: none;
  background: transparent;
  outline: none;
  font-size: 0.95rem;
  color: var(--text-main);
  font-family: inherit;
}

.search-input::placeholder {
  color: #bbb;
}

/* ── Categories ── */
.category-section {
  padding: 0.75rem 1rem;
}

.category-grid {
  display: grid;
  grid-template-columns: repeat(var(--cat-cols, 3), 1fr);
  gap: 0.75rem;
}

.cat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  padding: 0.85rem 0.5rem;
  background: #fff;
  border: 1.5px solid #e8e3d8;
  border-radius: 14px;
  cursor: pointer;
  transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
  font-family: inherit;
}

.cat-item:hover {
  border-color: var(--primary);
  box-shadow: 0 4px 14px rgba(193,160,82,0.12);
}

.cat-item.active {
  border-color: var(--primary);
  background: #faf7ef;
  box-shadow: 0 4px 18px rgba(193,160,82,0.18);
}

.cat-icon {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  background: rgba(193, 160, 82, 0.12);
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 800;
  font-size: 0.8rem;
  color: var(--secondary);
  overflow: hidden;
  flex-shrink: 0;
}

.cat-icon img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.cat-name {
  font-size: 0.82rem;
  font-weight: 600;
  color: var(--secondary);
  text-align: center;
  line-height: 1.3;
}

.cat-item.active .cat-name {
  color: var(--primary);
}

/* ── Filter Bar ── */
.filter-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.5rem 1rem 0.75rem;
  gap: 0.75rem;
}

.filter-tabs {
  display: flex;
  gap: 0.4rem;
  flex-wrap: nowrap;
  overflow-x: auto;
}

.filter-tab {
  padding: 0.38rem 1rem;
  border-radius: 999px;
  border: 1.5px solid #ddd;
  background: transparent;
  font-size: 0.82rem;
  font-weight: 600;
  color: var(--text-light);
  cursor: pointer;
  white-space: nowrap;
  font-family: inherit;
  transition: all 0.2s;
}

.filter-tab:hover {
  border-color: var(--primary);
  color: var(--primary);
}

.filter-tab.active {
  background: var(--primary);
  border-color: var(--primary);
  color: #fff;
}

.filter-more {
  display: inline-flex;
  align-items: center;
  gap: 0.3rem;
  padding: 0.38rem 0.85rem;
  border-radius: 999px;
  border: 1.5px solid #ddd;
  background: transparent;
  font-size: 0.82rem;
  font-weight: 600;
  color: var(--text-light);
  cursor: pointer;
  white-space: nowrap;
  font-family: inherit;
  transition: all 0.2s;
  flex-shrink: 0;
}

.filter-more:hover {
  border-color: var(--secondary);
  color: var(--secondary);
}

/* ── Product List ── */
.product-list {
  padding: 0 1rem 2rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.loading-wrap {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 4rem 0;
}

.spinner {
  color: var(--primary);
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.empty-state {
  text-align: center;
  color: var(--text-light);
  padding: 3rem 0;
  font-size: 0.95rem;
}

/* ── Product Card ── */
.product-card {
  background: #fff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0,0,0,0.07);
  transition: transform 0.25s ease, box-shadow 0.25s ease;
}

.product-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 28px rgba(0,0,0,0.12);
}

.card-img-wrap {
  position: relative;
  width: 100%;
  height: 220px;
  overflow: hidden;
}

.card-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.4s ease;
}

.product-card:hover .card-img {
  transform: scale(1.04);
}

.card-badge {
  position: absolute;
  top: 0.85rem;
  left: 0.85rem;
  background: var(--primary);
  color: #fff;
  font-size: 0.68rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  padding: 0.28rem 0.75rem;
  border-radius: 999px;
}

.card-body {
  padding: 1.1rem 1.15rem 1.15rem;
}

.card-title {
  font-size: 1rem;
  font-weight: 700;
  color: var(--secondary);
  margin-bottom: 0.45rem;
  line-height: 1.35;
}

.card-desc {
  font-size: 0.85rem;
  color: var(--text-light);
  line-height: 1.55;
  margin-bottom: 0.9rem;
}

.truncate-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.75rem;
}

.action-link {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  font-size: 0.84rem;
  font-weight: 600;
  color: var(--text-light);
  text-decoration: none;
  transition: color 0.2s;
}

.action-link:hover {
  color: var(--secondary);
}

.action-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.3rem;
  padding: 0.48rem 1.2rem;
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
  color: #fff;
  font-size: 0.84rem;
  font-weight: 600;
  border-radius: 6px;
  text-decoration: none;
  transition: transform 0.2s, box-shadow 0.2s;
  box-shadow: 0 3px 10px rgba(193,160,82,0.28);
}

.action-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 5px 16px rgba(193,160,82,0.38);
}

/* ── Desktop overrides ── */
@media (min-width: 992px) {
  .products-page {
    padding-top: 168px;
  }

  .search-section {
    max-width: 900px;
    margin: 0 auto;
    padding: 2rem 2rem 1rem;
  }

  .category-section {
    max-width: 900px;
    margin: 0 auto;
    padding: 0.75rem 2rem;
  }

  .category-grid {
    grid-template-columns: repeat(var(--cat-cols, 3), 1fr);
  }

  .filter-bar {
    max-width: 900px;
    margin: 0 auto;
    padding: 0.5rem 2rem 1rem;
  }

  .product-list {
    max-width: 900px;
    margin: 0 auto;
    padding: 0 2rem 3rem;
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1.25rem;
  }

  .card-img-wrap {
    height: 260px;
  }
}

@media (min-width: 1280px) {
  .product-list {
    grid-template-columns: repeat(3, 1fr);
  }
}

/* ── Mobile adjustments ── */
@media (max-width: 768px) {
  .products-page {
    padding-top: 118px; /* banner(52) + nav(~66) */
  }
}

@media (max-width: 480px) {
  .products-page {
    padding-top: 108px; /* banner(44) + nav(~64) */
  }

  .category-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .card-img-wrap {
    height: 200px;
  }
}

/* ── Filter Drawer ── */
.drawer-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 9999;
  display: flex;
  justify-content: flex-end;
}

.drawer-panel {
  width: 100%;
  max-width: 400px;
  background: #fff;
  height: 100%;
  display: flex;
  flex-direction: column;
  box-shadow: -4px 0 24px rgba(0,0,0,0.1);
}

.drawer-header {
  padding: 20px;
  border-bottom: 1px solid #eaeaea;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.drawer-header h3 {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 600;
  color: #1a1a1a;
}
.drawer-close {
  background: none;
  border: none;
  cursor: pointer;
  color: #666;
  padding: 4px;
}
.drawer-close:hover { color: #000; }

.drawer-section {
  padding: 20px;
  border-bottom: 1px solid #eaeaea;
}
.drawer-label {
  font-weight: 600;
  margin: 0 0 12px 0;
  color: #1a1a1a;
}
.drawer-options {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.drawer-opt {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  border: 1px solid #eaeaea;
  border-radius: 8px;
  background: #fff;
  cursor: pointer;
  text-align: left;
  transition: all 0.2s ease;
  color: #4a4a4a;
}
.drawer-opt:hover {
  border-color: #d0d0d0;
  background: #fcfcfc;
}
.drawer-opt.selected {
  border-color: #bfa15f;
  background: rgba(191, 161, 95, 0.05);
  color: #bfa15f;
  font-weight: 500;
}
.opt-check {
  width: 18px;
  height: 18px;
  border-radius: 4px;
  border: 1px solid #ccc;
  display: flex;
  align-items: center;
  justify-content: center;
  color: transparent;
}
.drawer-opt.selected .opt-check {
  background: #bfa15f;
  border-color: #bfa15f;
  color: #fff;
}

.drawer-actions {
  margin-top: auto;
  padding: 20px;
  border-top: 1px solid #eaeaea;
  display: flex;
  gap: 12px;
}
.drawer-clear {
  flex: 1;
  padding: 12px;
  border: 1px solid #ccc;
  border-radius: 8px;
  background: #fff;
  color: #4a4a4a;
  font-weight: 600;
  cursor: pointer;
}
.drawer-apply {
  flex: 1;
  padding: 12px;
  border: none;
  border-radius: 8px;
  background: #bfa15f;
  color: #fff;
  font-weight: 600;
  cursor: pointer;
}

/* Animations */
.drawer-enter-active,
.drawer-leave-active {
  transition: opacity 0.3s ease;
}
.drawer-enter-active .drawer-panel,
.drawer-leave-active .drawer-panel {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.drawer-enter-from,
.drawer-leave-to {
  opacity: 0;
}
.drawer-enter-from .drawer-panel,
.drawer-leave-to .drawer-panel {
  transform: translateX(100%);
}

.filter-more.active {
  background: #bfa15f;
  color: white;
  border-color: #bfa15f;
}
.filter-badge {
  background: white;
  color: #bfa15f;
  font-size: 0.75rem;
  font-weight: bold;
  padding: 2px 6px;
  border-radius: 10px;
  margin-left: 4px;
}
</style>
