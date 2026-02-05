<script setup>
import Navbar from './components/Navbar.vue';
</script>

<template>
  <div>
    <Navbar class="bg-gray-800 border-b border-gray-600" />
    <main class="mt-14 min-h-[calc(100vh-56px)] flex justify-center items-center px-4 py-6 md:px-8">
      <router-view />
    </main>
  </div>
</template>
