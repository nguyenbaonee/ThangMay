<script setup>
import { LayoutDashboard, ShoppingCart, FileText, MessageSquare, PhoneCall, LogOut, ChevronLeft, Menu, X, LayoutGrid, Bell, Users } from 'lucide-vue-next'
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const isCollapsed = ref(false)
const isMobileOpen = ref(false)

const user = ref(JSON.parse(localStorage.getItem('user') || '{"fullName": "Admin", "roles": []}'))

// Kiểm tra quyền Admin — roles có thể là string[] hoặc object[]
const isAdmin = computed(() => {
  return user.value.roles?.some(r => {
    if (typeof r === 'string') {
      return r === 'ROLE_ADMIN' || r === 'ADMIN'
    }
    return r.code === 'ADMIN' || r.code === 'AD' || r.name === 'ROLE_ADMIN'
  })
})

const menuItems = computed(() => {
  const items = [
    { name: 'Tổng quan', path: '/admin', icon: LayoutDashboard },
    { name: 'Danh mục', path: '/admin/categories', icon: LayoutGrid },
    { name: 'Sản phẩm', path: '/admin/products', icon: ShoppingCart },
    { name: 'Tài liệu', path: '/admin/documents', icon: FileText },
    { name: 'Bài viết', path: '/admin/blogs', icon: MessageSquare },
    { name: 'Liên hệ', path: '/admin/contacts', icon: PhoneCall },
    { name: 'Banners', path: '/admin/banners', icon: LayoutDashboard },
    { name: 'Thông tin Web', path: '/admin/web-info', icon: FileText },
  ]

  // Chỉ Admin mới thấy mục quản lý nhân viên
  if (isAdmin.value) {
    items.push({ name: 'Nhân viên', path: '/admin/users', icon: Users })
  }

  return items
})

const isWebInfoPage = computed(() => route.path === '/admin/web-info')

const handleLogout = () => {
  localStorage.removeItem('access_token')
  localStorage.removeItem('refresh_token')
  localStorage.removeItem('user')
  router.push('/admin/login')
}
</script>

<template>
  <div :class="['admin-shell', isCollapsed ? 'sidebar-collapsed' : '']">
    <!-- Mobile trigger -->
    <button class="m-trigger" @click="isMobileOpen = true">
      <Menu :size="22" />
    </button>

    <!-- Sidebar -->
    <aside :class="['admin-sidebar', isMobileOpen ? 'open' : '']">
      <div class="sb-top">
        <div class="sb-brand" v-show="!isCollapsed">
          <span class="brand-name">Elevator</span>
          <span class="brand-tag">ADMIN</span>
        </div>
        <button class="sb-toggle" @click="isCollapsed = !isCollapsed" title="Thu gọn">
          <ChevronLeft :size="18" :style="{ transform: isCollapsed ? 'rotate(180deg)' : 'rotate(0)' }" />
        </button>
        <button class="sb-close" @click="isMobileOpen = false"><X :size="22" /></button>
      </div>

      <nav class="sb-nav">
        <router-link
          v-for="item in menuItems" :key="item.path"
          :to="item.path" :class="['sb-link', route.path === item.path ? 'active' : '']"
          @click="isMobileOpen = false"
        >
          <component :is="item.icon" :size="20" class="sb-icon" />
          <span class="sb-label" v-show="!isCollapsed">{{ item.name }}</span>
        </router-link>
      </nav>

      <div class="sb-bottom">
        <router-link to="/" class="sb-link" @click="isMobileOpen = false">
          <LogOut :size="20" class="sb-icon" />
          <span class="sb-label" v-show="!isCollapsed">Xem Website</span>
        </router-link>
        <button class="sb-link logout-btn" @click="handleLogout">
          <LogOut :size="20" class="sb-icon" />
          <span class="sb-label" v-show="!isCollapsed">Đăng xuất</span>
        </button>
      </div>
    </aside>

    <!-- Mobile overlay -->
    <div v-if="isMobileOpen" class="m-overlay" @click="isMobileOpen = false"></div>

      <!-- Main -->
      <div class="admin-body">
        <header class="admin-bar">
          <div class="bar-left">
          <h1 :class="['bar-title', isWebInfoPage ? 'two-line' : '']">
            <span v-if="isWebInfoPage">
              <span class="bar-title-top">Thông tin</span>
              <span class="bar-title-bottom">Web</span>
            </span>
            <span v-else>{{ menuItems.find(m => m.path === route.path)?.name || 'Admin' }}</span>
          </h1>
          </div>
        <div class="bar-right">
          <button class="bar-icon-btn"><Bell :size="18" /></button>
          <div class="bar-user">
            <span class="user-name">{{ user.fullName }}</span>
            <div class="user-avatar">{{ user.fullName.substring(0, 2).toUpperCase() }}</div>
          </div>
        </div>
      </header>

      <main class="admin-content">
        <router-view v-slot="{ Component }">
          <transition name="page" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </main>
    </div>
  </div>
</template>

<style scoped>
/* ═══ Layout Shell ═══ */
.admin-shell {
  display: flex; min-height: 100vh; background: #f1f5f9;
}

/* ═══ Sidebar ═══ */
.admin-sidebar {
  width: 260px; background: linear-gradient(180deg, #1e1b4b 0%, #312e81 100%);
  color: #fff; display: flex; flex-direction: column;
  position: sticky; top: 0; height: 100vh; z-index: 1100;
  transition: width 0.25s cubic-bezier(0.4,0,0.2,1);
  flex-shrink: 0;
}
.sidebar-collapsed .admin-sidebar { width: 72px; }

.sb-top {
  padding: 1.25rem; display: flex; align-items: center;
  justify-content: space-between; min-height: 68px;
  border-bottom: 1px solid rgba(255,255,255,0.08);
}
.sb-brand { display: flex; align-items: center; gap: 0.5rem; }
.brand-name { font-weight: 800; font-size: 1.25rem; letter-spacing: 0.5px; }
.brand-tag {
  background: #6366f1; font-size: 0.6rem; padding: 0.15rem 0.45rem;
  border-radius: 4px; font-weight: 700; letter-spacing: 1px;
}
.sb-toggle {
  background: rgba(255,255,255,0.08); border: none; color: #c7d2fe;
  width: 30px; height: 30px; border-radius: 6px; cursor: pointer;
  display: flex; align-items: center; justify-content: center; transition: 0.2s;
}
.sb-toggle:hover { background: rgba(255,255,255,0.15); }
.sb-close { display: none; }

/* ═══ Nav Links ═══ */
.sb-nav { flex: 1; padding: 1rem 0; display: flex; flex-direction: column; gap: 2px; overflow-y: auto; }
.sb-link {
  display: flex; align-items: center; gap: 0.85rem;
  padding: 0.7rem 1.25rem; color: rgba(255,255,255,0.6);
  transition: 0.15s; border-left: 3px solid transparent; text-decoration: none;
  font-size: 0.9rem; font-weight: 500;
}
.sb-link:hover { color: #fff; background: rgba(255,255,255,0.06); }
.sb-link.active {
  color: #fff; background: rgba(255,255,255,0.1);
  border-left-color: #818cf8;
}
.sidebar-collapsed .sb-link { justify-content: center; padding: 0.7rem; }
.sb-icon { flex-shrink: 0; }
.sb-label { white-space: nowrap; }

.sb-bottom {
  border-top: 1px solid rgba(255,255,255,0.08); padding: 0.75rem 0;
}

.logout-btn {
  background: transparent;
  border: 0;
  border-left: 3px solid transparent;
  width: 100%;
  cursor: pointer;
  color: #fca5a5;
  font-family: inherit;
  justify-content: flex-start;
  text-align: left;
}
.logout-btn:hover {
  background: rgba(239, 68, 68, 0.15) !important;
  color: #f87171 !important;
  border-left-color: #f87171 !important;
}

/* ═══ Main Body ═══ */
.admin-body { flex: 1; display: flex; flex-direction: column; min-width: 0; }

.admin-bar {
  height: 64px; background: #fff; box-shadow: 0 1px 3px rgba(0,0,0,0.04);
  display: flex; align-items: center; justify-content: space-between;
  padding: 0 1.75rem; position: sticky; top: 0; z-index: 100;
}
.bar-left {
  display: flex;
  align-items: center;
  min-width: 0;
}
.bar-title { font-size: 1.1rem; font-weight: 700; color: #1e293b; margin: 0; }
.bar-title.two-line {
  display: flex;
  flex-direction: column;
  line-height: 1;
  justify-content: center;
}
.bar-title-top {
  display: block;
}
.bar-title-bottom {
  display: block;
}
.bar-right { display: flex; align-items: center; gap: 1rem; }
.bar-icon-btn {
  background: #f1f5f9; border: none; width: 36px; height: 36px;
  border-radius: 8px; display: flex; align-items: center; justify-content: center;
  cursor: pointer; color: #64748b; transition: 0.15s;
}
.bar-icon-btn:hover { background: #e2e8f0; }
.bar-user { display: flex; align-items: center; gap: 0.6rem; }
.user-name { font-size: 0.85rem; color: #64748b; font-weight: 600; }
.user-avatar {
  width: 36px; height: 36px; background: linear-gradient(135deg, #6366f1, #818cf8);
  color: #fff; border-radius: 50%; display: flex; align-items: center;
  justify-content: center; font-weight: 700; font-size: 0.78rem;
}

.admin-content {
  padding: 1.75rem; flex: 1;
  max-width: 1440px; width: 100%; margin: 0 auto; box-sizing: border-box;
}

/* ═══ Mobile ═══ */
.m-trigger { display: none; }
.m-overlay { display: none; }

@media (max-width: 1024px) {
  .admin-sidebar {
    position: fixed; left: -280px; width: 260px !important;
    transition: left 0.3s ease;
  }
  .admin-sidebar.open { left: 0; }
  .sidebar-collapsed .admin-sidebar { width: 260px !important; }
  .m-trigger {
    display: flex; align-items: center; justify-content: center;
    position: fixed; top: 12px; left: 16px; z-index: 200;
    background: #fff; border: none; width: 40px; height: 40px;
    border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    cursor: pointer; color: #334155;
  }
  .sb-close {
    display: flex; background: none; border: none; color: #c7d2fe;
    cursor: pointer; align-items: center; justify-content: center;
  }
  .sb-toggle { display: none; }
  .m-overlay {
    display: block; position: fixed; inset: 0;
    background: rgba(15,23,42,0.5); z-index: 1050;
  }
  .admin-bar { padding-left: 4.5rem; }
  .admin-content { padding: 1rem; }
}

@media (max-width: 768px) {
  .m-trigger {
    top: 9px; left: 12px;
  }
  .admin-bar {
    height: 58px;
    padding: 0 0.75rem 0 4.25rem;
  }

  .bar-title {
    font-size: 0.98rem;
    line-height: 1.05;
  }

  .bar-title.two-line {
    font-size: 0.9rem;
    line-height: 1;
  }

  .bar-right {
    gap: 0.6rem;
  }

  .user-name {
    display: none;
  }

  .bar-icon-btn,
  .user-avatar {
    width: 32px;
    height: 32px;
  }

  .admin-content {
    padding: 0.75rem;
  }
}

/* ═══ Page Transition ═══ */
.page-enter-active, .page-leave-active { transition: opacity 0.15s ease; }
.page-enter-from, .page-leave-to { opacity: 0; }
</style>
