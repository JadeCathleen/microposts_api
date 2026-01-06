<script setup>
import { useAuth } from "../composables/useAuth"
import Posts from "../components/Posts.vue"

const { isAuthenticated, user, logout } = useAuth()
</script>

<template>
  <Posts v-if="isAuthenticated" />
  <template v-else>
    <h1>Welcome to Microposts API</h1>
    <p>Please <router-link to="/login">login</router-link> to view posts.</p>
  </template>
</template>
