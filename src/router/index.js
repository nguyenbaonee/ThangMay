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
        path: '/admin',
        component: () => import('../layouts/AdminLayout.vue'),
        children: [
            {
                path: '',
                name: 'admin-dashboard',
                component: () => import('../views/admin/DashboardView.vue')
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

export default router
