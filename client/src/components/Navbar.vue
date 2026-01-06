<script setup>
import { useAuth } from "../composables/useAuth"
import { useRouter } from "vue-router"

const { user, isAuthenticated, logout } = useAuth()
const router = useRouter()

const handleLogout = async () => {
  await logout()
  router.push("/login")
}
</script>

<template>
  <nav class="navbar flex justify-between items-center p-4 fixed top-0 left-0 right-0 z-10">
    <router-link to="/" class="logo font-bold text-lg text-gray-400">
      MICROPOSTS
    </router-link>

    <div class="nav-right">
      <template v-if="isAuthenticated">
        <router-link class="font-semibold" to="/profile">{{ user?.username }}</router-link>
        <button class="ml-2" @click="handleLogout">Logout</button>
      </template>

      <template v-else>
        <router-link class="mr-2" to="/login">Login</router-link>
        <router-link to="/signup">Sign up</router-link>
      </template>
    </div>
  </nav>
</template>
