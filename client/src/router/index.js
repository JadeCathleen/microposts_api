import { createRouter, createWebHistory } from "vue-router"
import { useAuth } from "../composables/useAuth"

import LoginView from "../views/LoginView.vue"
import SignUpView from "../views/SignUpView.vue"
import PostsView from "../views/PostsView.vue"
import ProfileView from "../views/ProfileView.vue"

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: "/login",
      component: LoginView,
      meta: { guestOnly: true }
    },
    {
      path: "/signup",
      component: SignUpView,
      meta: { guestOnly: true }
    },
    {
      path: "/",
      component: PostsView,
      meta: { requiresAuth: true }
    },
    {
      path: "/profile",
      component: ProfileView,
      meta: { requiresAuth: true }
    }
  ]
})

/* 🔐 GLOBAL GUARD */
router.beforeEach((to) => {
  const { isAuthenticated } = useAuth()

  if (to.meta.requiresAuth && !isAuthenticated.value) {
    return "/login"
  }

  if (to.meta.guestOnly && isAuthenticated.value) {
    return "/"
  }
})

export default router
