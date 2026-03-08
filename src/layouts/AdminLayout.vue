<script setup>
import { LayoutDashboard, ShoppingCart, FileText, MessageSquare, PhoneCall, LogOut, ChevronRight, Menu, X } from 'lucide-vue-next'
import { ref } from 'vue'

const isCollapsed = ref(false)
const isMobileOpen = ref(false)

const menuItems = [
  { name: 'Tổng quan', path: '/admin', icon: LayoutDashboard },
  { name: 'Sản phẩm', path: '/admin/products', icon: ShoppingCart },
  { name: 'Tài liệu', path: '/admin/documents', icon: FileText },
  { name: 'Bài viết', path: '/admin/blogs', icon: MessageSquare },
  { name: 'Liên hệ', path: '/admin/contacts', icon: PhoneCall },
]

const toggleSidebar = () => {
    isCollapsed.value = !isCollapsed.value
}
</script>

<template>
  <div class="admin-layout">
    <!-- Mobile Sidebar Trigger -->
    <button class="mobile-menu-trigger" @click="isMobileOpen = true">
        <Menu :size="24" />
    </button>

    <!-- Sidebar -->
    <aside :class="['sidebar', isCollapsed ? 'collapsed' : '', isMobileOpen ? 'mobile-open' : '']">
      <div class="sidebar-header">
        <div class="logo-admin">
          <span class="logo-text">BaoThangMay</span>
          <span class="badge">ADMIN</span>
        </div>
        <button class="toggle-btn" @click="toggleSidebar">
           <ChevronRight :size="18" :class="isCollapsed ? 'rotate-0' : 'rotate-180'" />
        </button>
        <button class="mobile-close" @click="isMobileOpen = false">
            <X :size="24" />
        </button>
      </div>

      <nav class="sidebar-nav">
        <ul>
          <li v-for="item in menuItems" :key="item.path">
            <router-link :to="item.path" active-class="active" @click="isMobileOpen = false">
              <component :is="item.icon" :size="20" class="nav-icon" />
              <span v-if="!isCollapsed">{{ item.name }}</span>
            </router-link>
          </li>
        </ul>
      </nav>

      <div class="sidebar-footer">
        <router-link to="/" class="logout-link">
          <LogOut :size="20" class="nav-icon" />
          <span v-if="!isCollapsed">Xem Website</span>
        </router-link>
      </div>
    </aside>

    <!-- Main Admin Content -->
    <main class="admin-main">
      <header class="admin-topbar">
        <div class="topbar-search">
            <input type="text" placeholder="Tìm kiếm nhanh..." />
        </div>
        <div class="topbar-user">
            <span class="user-role">Administrator</span>
            <div class="avatar">AD</div>
        </div>
      </header>

      <div class="admin-page-content">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </div>
    </main>

    <!-- Overlay for mobile sidebar -->
    <div v-if="isMobileOpen" class="sidebar-overlay" @click="isMobileOpen = false"></div>
  </div>
</template>

<style scoped>
.admin-layout {
  display: flex;
  min-height: 100vh;
  background: #f4f7fa;
}

.sidebar {
  width: 280px;
  background: #1a237e; /* Deep indigo for admin */
  color: white;
  display: flex;
  flex-direction: column;
  transition: width 0.3s ease;
  position: sticky;
  top: 0;
  height: 100vh;
  z-index: 1000;
}

.sidebar.collapsed {
  width: 80px;
}

.sidebar-header {
  padding: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  min-height: 80px;
}

.logo-admin .logo-text {
  font-weight: 800;
  font-size: 1.4rem;
  letter-spacing: 1px;
}

.logo-admin .badge {
  background: var(--primary);
  font-size: 0.65rem;
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
  margin-left: 0.5rem;
  vertical-align: middle;
}

.sidebar.collapsed .logo-admin {
    display: none;
}

.toggle-btn {
  background: rgba(255, 255, 255, 0.1);
  border: none;
  color: white;
  width: 30px;
  height: 30px;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.rotate-180 { transform: rotate(180deg); transition: 0.3s; }
.rotate-0 { transform: rotate(0deg); transition: 0.3s; }

.sidebar-nav {
  flex: 1;
  padding: 1.5rem 0;
}

.sidebar-nav ul li {
  margin-bottom: 0.5rem;
}

.sidebar-nav a, .logout-link {
  display: flex;
  align-items: center;
  padding: 1rem 1.5rem;
  color: rgba(255, 255, 255, 0.7);
  gap: 1rem;
  transition: 0.2s;
}

.sidebar-nav a:hover, .sidebar-nav a.active {
  background: rgba(255, 255, 255, 0.1);
  color: white;
  border-left: 4px solid var(--primary);
}

.sidebar.collapsed a {
    justify-content: center;
}

.sidebar-footer {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 1.5rem 0;
}

.admin-main {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.admin-topbar {
  height: 80px;
  background: white;
  box-shadow: 0 1px 10px rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 2rem;
  position: sticky;
  top: 0;
  z-index: 100;
}

.topbar-search input {
    background: #f0f2f5;
    border: none;
    padding: 0.7rem 1.5rem;
    border-radius: 20px;
    width: 300px;
}

.topbar-user {
    display: flex;
    align-items: center;
    gap: 1rem;
}

.user-role {
    font-size: 0.9rem;
    color: #666;
    font-weight: 600;
}

.avatar {
    width: 40px;
    height: 40px;
    background: var(--primary);
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
}

.admin-page-content {
  padding: 2.5rem;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
}

.mobile-menu-trigger, .mobile-close {
    display: none;
}

@media (max-width: 992px) {
  .sidebar {
    position: fixed;
    left: -280px;
    width: 280px;
  }
  .sidebar.mobile-open {
    left: 0;
  }
  .sidebar.collapsed { width: 280px; }
  .mobile-menu-trigger {
    display: block;
    position: fixed;
    top: 25px;
    left: 20px;
    z-index: 200;
    background: white;
    border: none;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    width: 40px;
    height: 40px;
    border-radius: 8px;
  }
  .mobile-close {
      display: block;
      background: none;
      border: none;
      color: white;
  }
  .sidebar-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.5);
    z-index: 999;
  }
  .topbar-search { display: none; }
}
</style>
