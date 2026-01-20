<script setup>
import { useAuth } from "../composables/useAuth"

const { user, isAuthenticated } = useAuth()
</script>

<template>
  <div v-if="isAuthenticated">
    <h1 class="flex items-center justify-center mb-10">Profile</h1>
    <p>Email: {{ user?.email }}</p>
    <p>Username: {{ user?.username }}</p>
  </div>
  <div v-else>
    <h1 class="flex items-center justify-center mb-10">Profile</h1>
    <p>Please log in to view your profile.</p>
  </div>
</template>
