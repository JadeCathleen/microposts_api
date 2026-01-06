<script setup>
import { useAuth } from "../composables/useAuth"

const { user } = useAuth()
</script>

<template>
  <div>
    <h1 class="flex items-center justify-center mb-10">Profile</h1>
    <p>Email: {{ user.email }}</p>
    <p>Username: {{ user.username }}</p>
  </div>
</template>
