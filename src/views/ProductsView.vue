<script setup>
import {
  ArrowRight,
  Building2,
  CheckCircle2,
  ChevronRight,
  ChevronsUp,
  Grid2X2,
  Headphones,
  Home,
  Hotel,
  Loader2,
  PhoneCall,
  Search,
  Settings2,
  ShieldCheck,
  SlidersHorizontal,
  Wrench,
  X
} from 'lucide-vue-next'
import { computed, onMounted, ref, watch } from 'vue'
import productApi from '@/api/productApi'
import categoryApi from '@/api/categoryApi'

const isLoading = ref(true)
const isFilterOpen = ref(false)
const products = ref([])
const categories = ref([{ id: 'all', name: 'Tất cả sản phẩm' }])
const activeCategoryId = ref('all')
const sortMode = ref('newest')
const searchKeyword = ref('')
const selectedLoads = ref([])
const selectedSpeeds = ref([])

let timeout = null

const categoryImages = [
  '/images/3653228387362596575.jpg',
  '/images/d0ca929ac1724f2c1663.jpg',
  '/images/56463040787009741.jpg',
  '/images/3295663955585252783.jpg',
  '/images/3726039324607881804.jpg',
  '/images/2820939941982689699.jpg'
]

const fallbackProducts = [
  '/images/3653228387362596575.jpg',
  '/images/d0ca929ac1724f2c1663.jpg',
  '/images/56463040787009741.jpg',
  '/images/3295663955585252783.jpg'
]

const loadOptions = [
  { label: '≤ 450 kg', min: null, max: 450 },
  { label: '450 – 750 kg', min: 450, max: 750 },
  { label: '750 – 1000 kg', min: 750, max: 1000 },
  { label: '> 1000 kg', min: 1000, max: null }
]

const speedOptions = [
  { label: '≤ 1.0 m/s', min: null, max: 1.0 },
  { label: '1.0 – 1.75 m/s', min: 1.0, max: 1.75 },
  { label: '> 1.75 m/s', min: 1.75, max: null }
]

const sortOptions = [
  { value: 'newest', label: 'Mới nhất' },
  { value: 'featured', label: 'Nổi bật' },
  { value: 'name', label: 'Tên A-Z' }
]

const heroFeatures = [
  { icon: Settings2, text: 'Công nghệ tiên tiến' },
  { icon: ShieldCheck, text: 'An toàn tuyệt đối' },
  { icon: Wrench, text: 'Thiết kế tinh tế' }
]

const commitments = [
  { icon: Headphones, title: 'Tư vấn miễn phí', text: 'Đội ngũ chuyên gia sẵn sàng hỗ trợ' },
  { icon: ShieldCheck, title: 'Bảo hành chính hãng', text: 'Bảo hành lên đến 24 tháng' },
  { icon: Wrench, title: 'Lắp đặt chuyên nghiệp', text: 'Đội ngũ kỹ thuật giàu kinh nghiệm' },
  { icon: CheckCircle2, title: 'Hỗ trợ 24/7', text: 'Luôn đồng hành cùng khách hàng' }
]

const defaultCategories = [
  { id: 'all', name: 'Tất cả sản phẩm', icon: Grid2X2 },
  { id: 'family', name: 'Thang máy gia đình', icon: Home },
  { id: 'hotel', name: 'Thang máy khách sạn', icon: Hotel },
  { id: 'building', name: 'Thang máy công trình', icon: Building2 },
  { id: 'cargo', name: 'Thang máy tải hàng', icon: ChevronsUp },
  { id: 'other', name: 'Thang máy khác', icon: Grid2X2 }
]

const resolveProducts = (payload) => payload?.content || payload?.items || payload || []
const resolveImageUrl = (product, index = 0) =>
  product?.thumbnail?.publicUrl ||
  product?.thumbnail?.url ||
  product?.images?.[0] ||
  fallbackProducts[index % fallbackProducts.length]

const resolveCategoryName = (product) =>
  product?.categoryObj?.name || product?.category?.name || product?.category || 'Misel elevator'

const getNumber = (...values) => values.find((value) => value !== undefined && value !== null && value !== '') ?? null

const productLoad = (product) => getNumber(product.loadKg, product.load, product.capacity, product.capacityKg)
const productStops = (product) => getNumber(product.stops, product.stopCount, product.numberOfStops)
const productPeople = (product) => getNumber(product.people, product.persons, product.passengers)

const displayCategoryName = (category) => {
  const name = category?.name || ''
  const normalized = name.toLowerCase()
  if (category?.id === 'all') return 'Tất cả'
  if (normalized.includes('gia đình')) return 'Gia đình'
  if (normalized.includes('khách')) return 'Tải khách'
  if (normalized.includes('hàng')) return 'Tải hàng'
  if (normalized.includes('cuốn')) return 'Thang cuốn'
  if (normalized.includes('kính')) return 'Kính'
  return name.replace(/^Thang máy\s*/i, '').replace(/^Thang\s*/i, 'Thang ')
}

const productPrice = (product) => getNumber(product.price, product.salePrice, product.minPrice, product.basePrice)

const formatPrice = (value) => {
  const number = Number(value)
  if (!Number.isFinite(number) || number <= 0) return ''
  return new Intl.NumberFormat('vi-VN').format(number)
}

const sortedCategories = computed(() => {
  const list = categories.value
    .filter((category) => category.id !== 'all')
    .sort((a, b) => (a.sortOrder ?? 0) - (b.sortOrder ?? 0))

  return [{ id: 'all', name: 'Tất cả sản phẩm', description: 'Xem toàn bộ sản phẩm' }, ...list]
})

const sidebarCategories = computed(() => {
  const dynamic = sortedCategories.value.slice(0, 8)
  if (dynamic.length > 1) return dynamic
  return defaultCategories
})

const filteredProducts = computed(() => {
  const list = [...products.value]
  if (sortMode.value === 'name') {
    return list.sort((a, b) => (a.name || '').localeCompare(b.name || '', 'vi'))
  }
  if (sortMode.value === 'newest') {
    return list.sort((a, b) => new Date(b.createdAt || 0) - new Date(a.createdAt || 0))
  }
  return list
})

const selectCategory = (categoryId) => {
  activeCategoryId.value = categoryId
}

const toggleLoad = (index) => {
  selectedLoads.value = selectedLoads.value.includes(index)
    ? selectedLoads.value.filter((item) => item !== index)
    : [index]
}

const toggleSpeed = (index) => {
  selectedSpeeds.value = selectedSpeeds.value.includes(index)
    ? selectedSpeeds.value.filter((item) => item !== index)
    : [index]
}

const clearFilters = () => {
  selectedLoads.value = []
  selectedSpeeds.value = []
  activeCategoryId.value = 'all'
  searchKeyword.value = ''
  fetchProducts()
}

const getCategoryIcon = (category, index) => {
  if (category.id === 'all') return Grid2X2
  return defaultCategories[(index % (defaultCategories.length - 1)) + 1]?.icon || Grid2X2
}

const getCategoryImage = (category, index) => category.iconUrl || categoryImages[index % categoryImages.length]

const fetchCategories = async () => {
  try {
    const res = await categoryApi.listActive()
    categories.value = [{ id: 'all', name: 'Tất cả sản phẩm' }, ...(res.data || [])]
  } catch (error) {
    console.error('Error fetching categories:', error)
  }
}

const fetchProducts = async () => {
  isLoading.value = true
  try {
    const load = selectedLoads.value.length ? loadOptions[selectedLoads.value[0]] : {}
    const speed = selectedSpeeds.value.length ? speedOptions[selectedSpeeds.value[0]] : {}
    const params = {
      keyword: searchKeyword.value,
      categoryId: activeCategoryId.value === 'all' ? null : activeCategoryId.value,
      featured: sortMode.value === 'featured' ? true : null,
      isActive: true,
      loadMin: load?.min ?? null,
      loadMax: load?.max ?? null,
      speedMin: speed?.min ?? null,
      speedMax: speed?.max ?? null,
      size: 24
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

watch(searchKeyword, () => {
  if (timeout) clearTimeout(timeout)
  timeout = setTimeout(fetchProducts, 450)
})
watch(activeCategoryId, fetchProducts)
watch(sortMode, fetchProducts)
watch(selectedLoads, fetchProducts, { deep: true })
watch(selectedSpeeds, fetchProducts, { deep: true })
</script>

<template>
  <div class="products-page">
    <section class="products-hero">
      <div class="container hero-inner">
        <div class="hero-copy">
          <h1>MISEL</h1>
          <p>Giải pháp thang máy hiện đại, an toàn và đẳng cấp cho mọi công trình.</p>
          <div class="hero-features">
            <span v-for="item in heroFeatures" :key="item.text">
              <component :is="item.icon" :size="18" />
              {{ item.text }}
            </span>
          </div>
        </div>
      </div>
    </section>

    <section class="catalog-section">
      <div class="container catalog-layout">
        <aside class="catalog-sidebar">
          <div class="sidebar-card">
            <h2>Danh mục sản phẩm</h2>
            <div class="sidebar-category-list">
              <button
                v-for="(cat, index) in sidebarCategories"
                :key="cat.id"
                :class="['sidebar-category', activeCategoryId === cat.id ? 'active' : '']"
                type="button"
                @click="selectCategory(cat.id)"
              >
                <component :is="getCategoryIcon(cat, index)" :size="17" />
                <span>{{ displayCategoryName(cat) }}</span>
                <ChevronRight v-if="cat.id !== 'all'" :size="15" />
              </button>
            </div>
          </div>

          <div class="sidebar-card filters-card">
            <div class="filter-title-row">
              <h2>Bộ lọc sản phẩm</h2>
              <button type="button" @click="clearFilters">Xóa</button>
            </div>

            <div class="filter-group">
              <h3>Tải trọng</h3>
              <label v-for="(option, index) in loadOptions" :key="option.label" class="check-row">
                <input
                  type="checkbox"
                  :checked="selectedLoads.includes(index)"
                  @change="toggleLoad(index)"
                />
                <span>{{ option.label }}</span>
              </label>
            </div>

            <div class="filter-group">
              <h3>Tốc độ</h3>
              <label v-for="(option, index) in speedOptions" :key="option.label" class="check-row">
                <input
                  type="checkbox"
                  :checked="selectedSpeeds.includes(index)"
                  @change="toggleSpeed(index)"
                />
                <span>{{ option.label }}</span>
              </label>
            </div>
          </div>
        </aside>

        <main class="catalog-main">
          <div class="catalog-toolbar">
            <div class="search-box">
              <Search :size="19" />
              <input v-model="searchKeyword" type="text" placeholder="Tìm kiếm giải pháp thang máy..." />
            </div>

            <select v-model="sortMode" class="sort-select">
              <option v-for="option in sortOptions" :key="option.value" :value="option.value">
                {{ option.label }}
              </option>
            </select>

            <button class="mobile-filter-btn" type="button" @click="isFilterOpen = true">
              <SlidersHorizontal :size="18" />
            </button>
          </div>

          <div class="category-strip visually-hidden">
            <button
              v-for="(cat, index) in sortedCategories.slice(0, 8)"
              :key="cat.id"
              :class="['category-tile', activeCategoryId === cat.id ? 'active' : '']"
              type="button"
              @click="selectCategory(cat.id)"
            >
              <span class="tile-media">
                <Grid2X2 v-if="cat.id === 'all'" :size="24" />
                <img v-else :src="getCategoryImage(cat, index)" :alt="cat.name" />
              </span>
              <span>{{ cat.name }}</span>
            </button>
          </div>

          <div v-if="isLoading" class="loading-wrap">
            <Loader2 class="spinner" :size="42" />
          </div>

          <div v-else-if="filteredProducts.length === 0" class="empty-state">
            Không tìm thấy sản phẩm phù hợp.
          </div>

          <div v-else class="product-grid">
            <article
              v-for="(product, index) in filteredProducts"
              :key="product.id"
              class="product-card animate-fade-in"
            >
              <div class="product-image">
                <img :src="resolveImageUrl(product, index)" :alt="product.name || 'Sản phẩm thang máy Misel'" />
                <span v-if="index === 0" class="product-badge gold">Bán chạy</span>
                <span v-else-if="index === 2" class="product-badge blue">Mới</span>
              </div>

              <div class="product-body">
                <h3>{{ product.name || 'Thang máy Misel cao cấp' }}</h3>
                <div class="product-specs">
                  <span v-if="productLoad(product)">{{ productLoad(product) }} kg</span>
                  <span v-else>450 kg</span>
                  <span v-if="productPeople(product)">{{ productPeople(product) }} người</span>
                  <span v-else>4 - 6 người</span>
                  <span v-if="productStops(product)">{{ productStops(product) }} điểm dừng</span>
                  <span v-else>2 - 5 điểm dừng</span>
                </div>
                <p>{{ product.summary || product.desc || 'Thiết kế sang trọng, vận hành êm ái, phù hợp cho nhà phố, biệt thự và công trình cao cấp.' }}</p>
                <strong v-if="productPrice(product)" class="product-price">Giá {{ formatPrice(productPrice(product)) }}đ</strong>
                <router-link :to="{ name: 'product-detail', params: { id: product.id } }" class="detail-btn">
                  Xem chi tiết <ArrowRight :size="15" />
                </router-link>
              </div>
            </article>
          </div>

          <div class="commitment-bar visually-hidden">
            <div v-for="item in commitments" :key="item.title" class="commitment-item">
              <component :is="item.icon" :size="24" />
              <div>
                <strong>{{ item.title }}</strong>
                <span>{{ item.text }}</span>
              </div>
            </div>
          </div>
        </main>
      </div>
    </section>

    <a href="tel:19001234" class="catalog-phone visually-hidden">
      <PhoneCall :size="22" />
      <span>
        <strong>1900 1234</strong>
        <small>Tư vấn miễn phí</small>
      </span>
    </a>

    <Teleport to="body">
      <Transition name="drawer">
        <div v-if="isFilterOpen" class="drawer-overlay" @click.self="isFilterOpen = false">
          <div class="drawer-panel">
            <div class="drawer-header">
              <h3>Bộ lọc sản phẩm</h3>
              <button type="button" @click="isFilterOpen = false"><X :size="20" /></button>
            </div>
            <div class="drawer-body">
              <div class="filter-group">
                <h3>Tải trọng</h3>
                <label v-for="(option, index) in loadOptions" :key="option.label" class="check-row">
                  <input
                    type="checkbox"
                    :checked="selectedLoads.includes(index)"
                    @change="toggleLoad(index)"
                  />
                  <span>{{ option.label }}</span>
                </label>
              </div>
              <div class="filter-group">
                <h3>Tốc độ</h3>
                <label v-for="(option, index) in speedOptions" :key="option.label" class="check-row">
                  <input
                    type="checkbox"
                    :checked="selectedSpeeds.includes(index)"
                    @change="toggleSpeed(index)"
                  />
                  <span>{{ option.label }}</span>
                </label>
              </div>
            </div>
            <div class="drawer-actions">
              <button type="button" class="clear-btn" @click="clearFilters">Xóa bộ lọc</button>
              <button type="button" class="apply-btn" @click="isFilterOpen = false">Áp dụng</button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<style scoped>
.products-page {
  min-height: 100vh;
  padding-top: 132px;
  background: #f5f6f8;
  color: #16233a;
}

.products-hero {
  position: relative;
  min-height: 330px;
  overflow: hidden;
  background:
    linear-gradient(90deg, rgba(255, 255, 255, 0.98) 0%, rgba(255, 255, 255, 0.88) 42%, rgba(255, 255, 255, 0.08) 72%),
    url('/images/3653228387362596575.jpg') center right / cover no-repeat;
}

.products-hero::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0), #f5f6f8 100%);
  pointer-events: none;
}

.hero-inner {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  min-height: 330px;
}

.hero-copy {
  max-width: 560px;
}

.hero-copy h1 {
  margin-bottom: 0.8rem;
  color: var(--secondary);
  font-size: clamp(2.2rem, 4.2vw, 4rem);
  line-height: 1;
}

.hero-copy p {
  max-width: 490px;
  color: #39465a;
  font-size: 1.06rem;
  line-height: 1.75;
}

.hero-features {
  display: flex;
  flex-wrap: wrap;
  gap: 1.1rem 2.4rem;
  margin-top: 1.6rem;
}

.hero-features span {
  display: inline-flex;
  align-items: center;
  gap: 0.7rem;
  color: var(--secondary);
  font-weight: 700;
}

.hero-features svg {
  box-sizing: content-box;
  padding: 0.55rem;
  color: var(--primary);
  background: #f7edda;
  border-radius: 10px;
}

.catalog-section {
  position: relative;
  z-index: 2;
  margin-top: -34px;
  padding-bottom: 4rem;
}

.catalog-layout {
  display: grid;
  grid-template-columns: 280px minmax(0, 1fr);
  gap: 1.35rem;
}

.catalog-sidebar {
  display: flex;
  flex-direction: column;
  gap: 1.15rem;
}

.sidebar-card,
.catalog-toolbar,
.product-card,
.category-tile {
  background: #fff;
  border: 1px solid rgba(17, 35, 64, 0.08);
  box-shadow: 0 16px 45px rgba(22, 35, 58, 0.08);
}

.sidebar-card {
  padding: 1rem;
  border-radius: 12px;
}

.sidebar-card h2 {
  margin-bottom: 0.75rem;
  color: var(--secondary);
  font-size: 1rem;
}

.sidebar-category {
  display: grid;
  grid-template-columns: 22px 1fr 16px;
  align-items: center;
  width: 100%;
  gap: 0.65rem;
  padding: 0.8rem 0.75rem;
  border: 0;
  border-radius: 8px;
  color: #4c5870;
  background: transparent;
  font: inherit;
  font-weight: 600;
  text-align: left;
  cursor: pointer;
  transition: 0.22s ease;
}

.sidebar-category svg {
  color: var(--secondary);
}

.sidebar-category.active {
  color: #fff;
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
}

.sidebar-category.active svg {
  color: #fff;
}

.filter-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.filter-title-row button {
  border: 0;
  color: var(--primary-dark);
  background: transparent;
  font: inherit;
  font-size: 0.78rem;
  font-weight: 700;
  cursor: pointer;
}

.filter-group {
  padding-top: 1rem;
}

.filter-group + .filter-group {
  margin-top: 0.9rem;
  border-top: 1px solid rgba(17, 35, 64, 0.1);
}

.filter-group h3 {
  margin-bottom: 0.65rem;
  color: var(--secondary);
  font-size: 0.86rem;
}

.check-row {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  padding: 0.4rem 0;
  color: #4f5d72;
  font-size: 0.9rem;
  cursor: pointer;
}

.check-row input {
  width: 16px;
  height: 16px;
  accent-color: var(--primary);
}

.catalog-main {
  min-width: 0;
}

.catalog-toolbar {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 170px;
  gap: 1rem;
  align-items: center;
  padding: 0.8rem;
  border-radius: 12px;
}

.search-box {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  min-height: 48px;
  padding: 0 1rem;
  color: #697386;
  background: #fff;
  border: 1px solid rgba(17, 35, 64, 0.1);
  border-radius: 10px;
}

.search-box input {
  width: 100%;
  border: 0;
  outline: 0;
  color: #1d293d;
  background: transparent;
  font: inherit;
}

.sort-select {
  min-height: 48px;
  padding: 0 1rem;
  border: 1px solid rgba(17, 35, 64, 0.1);
  border-radius: 10px;
  color: #26344d;
  background: #fff;
  font: inherit;
  font-weight: 600;
}

.mobile-filter-btn {
  display: none;
}

.category-strip {
  display: grid;
  grid-template-columns: repeat(8, minmax(92px, 1fr));
  gap: 1rem;
  margin: 1.3rem 0;
  overflow-x: auto;
  padding-bottom: 0.25rem;
}

.category-tile {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
  gap: 0.65rem;
  min-height: 112px;
  padding: 0;
  overflow: hidden;
  border-radius: 10px;
  color: var(--secondary);
  font: inherit;
  font-size: 0.82rem;
  font-weight: 700;
  cursor: pointer;
  transition: transform 0.22s ease, border-color 0.22s ease, box-shadow 0.22s ease;
}

.category-tile.active {
  color: #fff;
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
}

.category-tile:hover {
  transform: translateY(-4px);
}

.tile-media {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 62px;
  overflow: hidden;
  color: #fff;
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
}

.tile-media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.category-tile > span:last-child {
  display: flex;
  align-items: center;
  min-height: 38px;
  padding: 0 0.55rem 0.65rem;
  text-align: center;
  line-height: 1.25;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 1.35rem;
}

.product-card {
  overflow: hidden;
  border-radius: 12px;
  transition: transform 0.24s ease, box-shadow 0.24s ease;
}

.product-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 22px 55px rgba(22, 35, 58, 0.14);
}

.product-image {
  position: relative;
  overflow: hidden;
}

.product-image img {
  display: block;
  width: 100%;
  aspect-ratio: 1.15 / 1;
  object-fit: cover;
  transition: transform 0.55s ease;
}

.product-card:hover .product-image img {
  transform: scale(1.06);
}

.product-badge {
  position: absolute;
  top: 0.8rem;
  left: 0.8rem;
  padding: 0.35rem 0.65rem;
  border-radius: 5px;
  color: #fff;
  font-size: 0.68rem;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
}

.product-badge.gold {
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
}

.product-badge.blue {
  background: #2d75ff;
}

.product-body {
  padding: 1rem;
}

.product-body h3 {
  min-height: 2.55em;
  margin-bottom: 0.65rem;
  color: var(--secondary);
  font-size: 1rem;
  line-height: 1.28;
}

.product-specs {
  display: flex;
  flex-wrap: wrap;
  gap: 0.45rem 0.7rem;
  margin-bottom: 0.75rem;
  color: #536075;
  font-size: 0.72rem;
}

.product-specs span::before {
  content: '';
  display: inline-block;
  width: 5px;
  height: 5px;
  margin-right: 0.35rem;
  vertical-align: 0.08em;
  border-radius: 999px;
  background: var(--primary);
}

.product-body p {
  display: -webkit-box;
  min-height: 3.3em;
  margin-bottom: 1rem;
  overflow: hidden;
  color: #536075;
  font-size: 0.86rem;
  line-height: 1.65;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  line-clamp: 2;
}

.detail-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.45rem;
  padding: 0.58rem 0.9rem;
  border-radius: 5px;
  color: #fff;
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
  font-size: 0.82rem;
  font-weight: 800;
}

.commitment-bar {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1px;
  margin-top: 1.6rem;
  overflow: hidden;
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.16);
  box-shadow: 0 16px 45px rgba(5, 28, 64, 0.18);
}

.commitment-item {
  display: flex;
  align-items: center;
  gap: 0.8rem;
  padding: 1rem 1.15rem;
  color: #fff;
  background: linear-gradient(135deg, #063269, #0b4c93);
}

.commitment-item svg {
  flex: 0 0 auto;
  color: var(--primary);
}

.commitment-item strong,
.commitment-item span {
  display: block;
}

.commitment-item strong {
  margin-bottom: 0.2rem;
  font-size: 0.9rem;
}

.commitment-item span {
  color: rgba(255, 255, 255, 0.78);
  font-size: 0.76rem;
}

.loading-wrap,
.empty-state {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 320px;
  color: var(--primary);
}

.empty-state {
  color: #657184;
  background: #fff;
  border-radius: 12px;
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.catalog-phone {
  position: fixed;
  right: 1.4rem;
  bottom: 2rem;
  z-index: 20;
  display: inline-flex;
  align-items: center;
  gap: 0.7rem;
  padding: 0.75rem 1rem;
  color: #fff;
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
  border-radius: 18px;
  box-shadow: 0 16px 34px rgba(117, 88, 23, 0.32);
}

.catalog-phone strong,
.catalog-phone small {
  display: block;
  line-height: 1.15;
}

.catalog-phone small {
  font-size: 0.72rem;
}

.drawer-overlay {
  position: fixed;
  inset: 0;
  z-index: 9999;
  display: flex;
  justify-content: flex-end;
  background: rgba(0, 0, 0, 0.42);
}

.drawer-panel {
  width: min(420px, 100%);
  height: 100%;
  display: flex;
  flex-direction: column;
  background: #fff;
}

.drawer-header,
.drawer-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.75rem;
  padding: 1rem;
  border-bottom: 1px solid #e7eaf0;
}

.drawer-header button {
  border: 0;
  background: transparent;
}

.drawer-body {
  flex: 1;
  overflow-y: auto;
  padding: 0 1rem 1rem;
}

.drawer-actions {
  border-top: 1px solid #e7eaf0;
  border-bottom: 0;
}

.clear-btn,
.apply-btn {
  flex: 1;
  min-height: 44px;
  border: 1px solid rgba(17, 35, 64, 0.14);
  border-radius: 8px;
  font: inherit;
  font-weight: 800;
}

.apply-btn {
  color: #fff;
  background: var(--primary);
}

.drawer-enter-active,
.drawer-leave-active {
  transition: opacity 0.25s ease;
}

.drawer-enter-active .drawer-panel,
.drawer-leave-active .drawer-panel {
  transition: transform 0.25s ease;
}

.drawer-enter-from,
.drawer-leave-to {
  opacity: 0;
}

.drawer-enter-from .drawer-panel,
.drawer-leave-to .drawer-panel {
  transform: translateX(100%);
}

@media (max-width: 1280px) {
  .product-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }

  .category-strip {
    grid-template-columns: repeat(6, minmax(104px, 1fr));
  }
}

@media (max-width: 1024px) {
  .products-page {
    padding-top: 108px;
  }

  .catalog-layout {
    grid-template-columns: 1fr;
  }

  .catalog-sidebar {
    display: block;
    margin-bottom: 1.25rem;
  }

  .catalog-sidebar .sidebar-card:first-child {
    padding: 1rem;
  }

  .catalog-sidebar .sidebar-card:first-child h2 {
    font-size: 1.05rem;
  }

  .sidebar-category {
    min-height: 48px;
    grid-template-columns: 34px 1fr 14px;
    font-size: 0.88rem;
  }

  .sidebar-category svg {
    padding: 0.42rem;
  }

  .filters-card {
    display: none;
  }

  .catalog-toolbar {
    grid-template-columns: minmax(0, 1fr) 145px 48px;
  }

  .mobile-filter-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 48px;
    border: 1px solid rgba(17, 35, 64, 0.1);
    border-radius: 10px;
    color: var(--secondary);
    background: #fff;
  }

  .commitment-bar {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .products-page {
    padding-top: 86px;
  }

  .products-hero {
    min-height: 360px;
    background:
      linear-gradient(180deg, rgba(255, 255, 255, 0.94), rgba(255, 255, 255, 0.64)),
      url('/images/3653228387362596575.jpg') center / cover no-repeat;
  }

  .hero-inner {
    min-height: 360px;
    align-items: flex-end;
    padding-bottom: 3rem;
  }

  .hero-features {
    gap: 0.8rem;
  }

  .hero-features span {
    width: 100%;
  }

  .catalog-section {
    margin-top: -24px;
  }

  .catalog-toolbar {
    grid-template-columns: 1fr 48px;
  }

  .sort-select {
    grid-column: 1 / -1;
    order: 3;
  }

  .category-strip {
    display: flex;
    overflow-x: auto;
  }

  .category-tile {
    flex: 0 0 112px;
  }

  .product-grid {
    grid-template-columns: 1fr;
  }

  .commitment-bar {
    grid-template-columns: 1fr;
  }

  .catalog-phone {
    right: 1rem;
    bottom: 1rem;
    padding: 0.7rem;
  }

  .catalog-phone span {
    display: none;
  }
}

/* Figma refinement for elevator catalog page */
.visually-hidden {
  display: none !important;
}

.products-page {
  background: #fff;
}

.products-hero {
  min-height: clamp(310px, 38vh, 420px);
  background:
    linear-gradient(90deg, rgba(5, 17, 32, 0.48), rgba(5, 17, 32, 0.56)),
    url('/images/3653228387362596575.jpg') center / cover no-repeat;
}

.products-hero::after {
  background: rgba(0, 0, 0, 0.2);
}

.hero-inner {
  justify-content: center;
  min-height: clamp(310px, 38vh, 420px);
  text-align: center;
}

.hero-copy {
  max-width: 760px;
}

.hero-copy h1 {
  color: #fff;
  font-size: clamp(3rem, 5.6vw, 5.35rem);
  text-shadow: 0 16px 42px rgba(0, 0, 0, 0.35);
}

.hero-copy p {
  margin: 0 auto;
  color: rgba(255, 255, 255, 0.92);
  font-size: 1.1rem;
}

.hero-features {
  display: none;
}

.catalog-section {
  margin-top: 0;
  padding: clamp(3rem, 5vw, 5rem) 0;
}

.catalog-layout {
  grid-template-columns: 300px minmax(0, 1fr);
  gap: 2rem;
  align-items: start;
}

.catalog-sidebar .sidebar-card:first-child {
  color: #fff;
  background: #021f43;
  border: 0;
  border-radius: 8px;
  box-shadow: 0 22px 50px rgba(2, 31, 67, 0.2);
}

.catalog-sidebar .sidebar-card:first-child h2 {
  color: var(--primary);
  font-size: 1.28rem;
}

.catalog-sidebar .sidebar-card:first-child h2::after {
  content: '';
  display: block;
  height: 1px;
  margin-top: 1rem;
  background: rgba(193, 160, 82, 0.55);
}

.sidebar-card {
  border-radius: 8px;
}

.sidebar-category {
  grid-template-columns: 38px 1fr 16px;
  min-height: 56px;
  color: #fff;
  border-radius: 6px;
}

.sidebar-category svg {
  box-sizing: content-box;
  padding: 0.52rem;
  color: #fff;
  background: rgba(193, 160, 82, 0.95);
  border-radius: 5px;
}

.sidebar-category:hover {
  background: rgba(255, 255, 255, 0.08);
}

.sidebar-category.active svg {
  background: rgba(255, 255, 255, 0.18);
}

.filters-card {
  border-color: rgba(193, 160, 82, 0.55);
  box-shadow: none;
}

.filter-title-row button {
  min-width: 52px;
  min-height: 34px;
  border-radius: 5px;
  color: #fff;
  background: var(--primary);
}

.filter-group + .filter-group {
  padding-top: 1rem;
  border-top-color: rgba(193, 160, 82, 0.42);
}

.filter-group h3 {
  color: #071d3b;
  font-size: 0.92rem;
}

.check-row {
  color: #1c2b45;
  font-weight: 600;
}

.catalog-toolbar {
  grid-template-columns: minmax(0, 1fr) 150px;
  margin-bottom: 1.8rem;
  padding: 0;
  border: 0;
  border-radius: 0;
  box-shadow: none;
}

.search-box,
.sort-select {
  min-height: 50px;
  border-radius: 6px;
}

.sort-select {
  border: 2px solid var(--primary);
  color: #fff;
  background: #021f43;
  font-weight: 800;
}

.product-grid {
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 2rem;
}

.product-card {
  border-radius: 8px;
  box-shadow: 0 18px 50px rgba(22, 35, 58, 0.1);
}

.product-image img {
  aspect-ratio: 1.35 / 0.95;
}

.product-badge {
  right: 0.75rem;
  left: auto;
  border-radius: 999px;
}

.product-body {
  padding: 1.25rem 1.3rem 1.35rem;
}

.product-body h3 {
  min-height: auto;
  color: var(--secondary);
  font-size: 1.35rem;
  line-height: 1.22;
}

.product-body h3::before {
  content: 'Misel elevator';
  display: block;
  margin-bottom: 0.4rem;
  color: var(--primary);
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.product-specs {
  color: #071d3b;
  font-size: 0.88rem;
  font-weight: 700;
}

.product-body p {
  color: #687483;
  font-size: 0.94rem;
}

.detail-btn {
  padding: 0.75rem 1.1rem;
  font-size: 0.9rem;
}

@media (max-width: 1024px) {
  .catalog-layout {
    grid-template-columns: 1fr;
  }

  .catalog-sidebar {
    display: block;
  }

  .catalog-toolbar {
    grid-template-columns: minmax(0, 1fr) 145px 48px;
  }
}

@media (max-width: 768px) {
  .products-hero {
    min-height: 300px;
    background:
      linear-gradient(90deg, rgba(5, 17, 32, 0.58), rgba(5, 17, 32, 0.58)),
      url('/images/3653228387362596575.jpg') center / cover no-repeat;
  }

  .hero-inner {
    min-height: 300px;
    align-items: center;
    padding-bottom: 0;
  }

  .catalog-section {
    margin-top: 0;
  }

  .catalog-toolbar {
    grid-template-columns: 1fr 48px;
  }

  .sort-select {
    grid-column: 1 / -1;
  }

  .product-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 640px) {
  .products-page {
    padding-top: 82px;
    background: #fff;
    overflow-x: hidden;
  }

  .products-hero {
    display: none;
  }

  .catalog-section {
    padding: 1.35rem 0 3rem;
    overflow-x: hidden;
  }

  .catalog-section .container {
    width: 100%;
    max-width: 100%;
    padding-left: 1rem;
    padding-right: 1rem;
  }

  .catalog-layout {
    display: flex;
    flex-direction: column;
  }

  .catalog-sidebar {
    display: block;
    order: 1;
    margin-bottom: 1.35rem;
  }

  .catalog-sidebar .sidebar-card:first-child {
    display: block;
    padding: 0;
    width: 100%;
    max-width: 100%;
    overflow: hidden;
    color: var(--secondary);
    background: #fff;
    border: 0;
    border-radius: 0;
    box-shadow: none;
  }

  .sidebar-category-list {
    display: flex;
    flex-wrap: nowrap;
    gap: 1.35rem;
    width: 100%;
    max-width: 100%;
    overflow-x: auto;
    overscroll-behavior-x: contain;
    padding-bottom: 0.15rem;
    scrollbar-width: none;
  }

  .sidebar-category-list::-webkit-scrollbar {
    display: none;
  }

  .catalog-sidebar .sidebar-card:first-child h2 {
    margin-bottom: 1.1rem;
    color: var(--secondary);
    font-size: 1.35rem;
    line-height: 1.25;
  }

  .catalog-sidebar .sidebar-card:first-child h2::after {
    display: none;
  }

  .sidebar-category {
    flex: 0 0 70px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    gap: 0.45rem;
    min-height: 100px;
    padding: 0;
    color: #121a2b;
    border: 0;
    border-radius: 0;
    text-align: center;
    font-size: 0.9rem;
    font-weight: 500;
    line-height: 1.15;
    white-space: normal;
    background: transparent;
  }

  .sidebar-category svg {
    width: 56px;
    height: 56px;
    box-sizing: border-box;
    padding: 0.85rem;
    color: var(--primary);
    background: #fff;
    border: 1px solid rgba(193, 160, 82, 0.84);
    border-radius: 999px;
  }

  .sidebar-category .lucide-chevron-right {
    display: none;
  }

  .sidebar-category.active {
    color: var(--primary-dark);
    border: 0;
    background: transparent;
    box-shadow: none;
  }

  .sidebar-category.active svg {
    color: #fff;
    background: linear-gradient(135deg, var(--primary), var(--primary-dark));
    border-color: transparent;
  }

  .filters-card {
    display: none;
  }

  .catalog-main {
    order: 2;
  }

  .catalog-toolbar {
    display: grid;
    grid-template-columns: minmax(138px, 168px) 1fr 52px;
    gap: 0.75rem;
    width: calc(100% + 2rem);
    max-width: calc(100% + 2rem);
    margin: 0 -1rem 1.4rem;
    padding: 1.25rem 1rem 0.9rem;
    background: #061b3b;
  }

  .search-box {
    grid-column: 1 / -1;
    min-height: 50px;
    padding: 0 1rem;
    border: 1px solid rgba(17, 35, 64, 0.22);
    border-radius: 7px;
    background: #fff;
    box-shadow: none;
  }

  .search-box input {
    font-size: 0.9rem;
  }

  .sort-select {
    grid-column: 1 / 2;
    order: initial;
    min-height: 48px;
    width: 100%;
    padding: 0 2.25rem 0 1rem;
    font-size: 0.88rem;
    font-weight: 800;
    color: #172033;
    background: #fff;
    border-color: rgba(17, 35, 64, 0.16);
    border-radius: 8px;
  }

  .mobile-filter-btn {
    display: inline-flex;
    grid-column: 3 / 4;
    justify-self: end;
    align-items: center;
    justify-content: center;
    width: 52px;
    min-height: 48px;
    border: 0;
    border-radius: 7px;
    color: #59606b;
    background: #f2f2f6;
  }

  .product-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1rem;
    width: 100%;
  }

  .product-card {
    overflow: hidden;
    border: 0;
    border-radius: 8px;
    box-shadow: 0 12px 28px rgba(22, 35, 58, 0.12);
  }

  .product-image img {
    aspect-ratio: 1 / 0.92;
  }

  .product-badge {
    right: 0.45rem;
    top: 0.45rem;
    padding: 0.35rem 0.7rem;
    font-size: 0.68rem;
  }

  .product-body {
    padding: 0.75rem 0.8rem 0.9rem;
  }

  .product-body h3 {
    margin-bottom: 0.45rem;
    color: #071d3b;
    font-size: 0.98rem;
    line-height: 1.22;
  }

  .product-body h3::before {
    margin-bottom: 0.25rem;
    font-size: 0.62rem;
  }

  .product-specs {
    display: none;
  }

  .product-specs span {
    display: block;
  }

  .product-body p {
    display: block;
    min-height: 0;
    margin-bottom: 0.35rem;
    color: #273344;
    font-size: 0.82rem;
    line-height: 1.4;
    -webkit-line-clamp: 1;
    line-clamp: 1;
  }

  .product-price {
    display: block;
    color: var(--primary-dark);
    font-size: 0.95rem;
    font-weight: 800;
  }

  .detail-btn {
    display: none;
  }

  .drawer-panel {
    width: min(88vw, 380px);
    background: #fffdf8;
  }

  .drawer-header h3 {
    color: var(--secondary);
    font-size: 1.2rem;
  }

  .drawer-body .filter-group {
    padding-top: 1.15rem;
  }

  .drawer-body .check-row {
    min-height: 34px;
  }
}
</style>
