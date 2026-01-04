<script setup>
import Navbar from './components/Navbar.vue';
</script>

<template>
  <div>
    <Navbar class="bg-gray-400" />
    <main class="flex justify-center items-center min-h-[calc(100vh-4rem)]">
      <router-view />
    </main>
  </div>
</template>
