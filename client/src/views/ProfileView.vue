<script setup>
import { useAuth } from "../composables/useAuth"

const { user } = useAuth()
</script>

<template>
  <div>
    <h1>Profile</h1>
    <p>Email: {{ user.email }}</p>
  </div>
</template>
