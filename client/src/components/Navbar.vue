<script setup>
import { onMounted } from "vue"
import { useAuth } from "../composables/useAuth"
import { useRouter } from "vue-router"

const { user, isAuthenticated, logout } = useAuth()
const router = useRouter()
onMounted(() => {
  console.log("Navbar mounted", user)
})
const handleLogout = async () => {
  await logout()
  router.push("/login")
}
</script>

<template>
  <nav class="navbar flex justify-between items-center p-4">
    <router-link to="/" class="logo">
      📝 Microposts
    </router-link>

    <div class="nav-right">
      <template v-if="isAuthenticated">
        <router-link to="/profile">Profile</router-link>
        <span>{{ user?.username }}</span>
        <button @click="handleLogout">Logout</button>
      </template>

      <template v-else>
        <router-link class="mr-2" to="/login">Login</router-link>
        <router-link to="/signup">Sign up</router-link>
      </template>
    </div>
  </nav>
</template>
