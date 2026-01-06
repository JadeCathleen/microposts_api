<script setup>
import Navbar from './components/Navbar.vue';
</script>

<template>
  <div>
    <Navbar class="bg-gray-800 border-b border-gray-600" />
    <main class="flex justify-center items-center min-h-[calc(100vh-56px)]">
      <router-view />
    </main>
  </div>
</template>
