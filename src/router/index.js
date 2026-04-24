import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const routes = [
  {
    path: '/',
    component: () => import('../layouts/MainLayout.vue'),
    children: [
      {
        path: '',
        name: 'home',
        component: HomeView
      },
      {
        path: 'about',
        name: 'about',
        component: () => import('../views/AboutView.vue')
      },
      {
        path: 'products',
        name: 'products',
        component: () => import('../views/ProductsView.vue')
      },
      {
        path: 'products/:id',
        name: 'product-detail',
        component: () => import('../views/ProductDetailView.vue')
      },
      {
        path: 'services',
        name: 'services',
        component: () => import('../views/ServicesView.vue')
      },
      {
        path: 'projects',
        name: 'projects',
        component: () => import('../views/ProjectsView.vue')
      },
      {
        path: 'projects/:slug',
        name: 'project-detail',
        component: () => import('../views/ProjectDetailView.vue')
      },
      {
        path: 'documents',
        name: 'documents',
        component: () => import('../views/DocumentsView.vue')
      },
      {
        path: 'contact',
        name: 'contact',
        component: () => import('../views/ContactView.vue')
      }
    ]
  },
  {
    path: '/admin/login',
    name: 'admin-login',
    component: () => import('../views/admin/LoginView.vue'),
    meta: { public: true }
  },
  {
    path: '/admin',
    component: () => import('../layouts/AdminLayout.vue'),
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        name: 'admin-dashboard',
        component: () => import('../views/admin/DashboardView.vue')
      },
      {
        path: 'categories',
        name: 'admin-categories',
        component: () => import('../views/admin/CategoryManagement.vue')
      },
      {
        path: 'products',
        name: 'admin-products',
        component: () => import('../views/admin/ProductManagement.vue')
      },
      {
        path: 'documents',
        name: 'admin-documents',
        component: () => import('../views/admin/DocumentManagement.vue')
      },
      {
        path: 'blogs',
        name: 'admin-blogs',
        component: () => import('../views/admin/BlogManagement.vue')
      },
      {
        path: 'contacts',
        name: 'admin-contacts',
        component: () => import('../views/admin/ContactManagement.vue')
      },
      {
        path: 'banners',
        name: 'admin-banners',
        component: () => import('../views/admin/BannerManagement.vue')
      },
      {
        path: 'web-info',
        name: 'admin-web-info',
        component: () => import('../views/admin/WebInfoManagement.vue')
      },
      {
        path: 'users',
        name: 'admin-users',
        component: () => import('../views/admin/UserManagement.vue'),
        meta: { requiresAuth: true, role: 'ADMIN' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
  scrollBehavior() {
    return { top: 0 }
  }
})

router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem('access_token')
  const user = JSON.parse(localStorage.getItem('user') || '{}')
  const userRoles = user.roles || []
  
  if (to.meta.requiresAuth && !isAuthenticated) {
    next({ name: 'admin-login' })
  } else if (to.name === 'admin-login' && isAuthenticated) {
    next({ name: 'admin-dashboard' })
  } else if (to.meta.role) {
    // roles là mảng string ["ROLE_ADMIN", "ROLE_EDITOR"]
    const hasRole = userRoles.some(r => {
      if (typeof r === 'string') {
        return r === 'ROLE_' + to.meta.role || r === to.meta.role
      }
      // Fallback nếu r là object
      return r.code === to.meta.role || r.name === 'ROLE_' + to.meta.role
    })
    if (!hasRole) {
      next({ name: 'admin-dashboard' })
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
