<script setup>
import { computed } from "vue";

const props = defineProps({
  message: { type: String, default: "" },
  errors: { type: Array, default: () => [] }
});

const hasContent = computed(() => {
  return props.message || props.errors.length > 0;
});
</script>

<template>
  <div v-if="hasContent" class="space-y-2 mb-4">

    <!-- Flash message (success) -->
    <div
      v-if="message"
      class="px-4 py-3 rounded-lg bg-green-500 text-white shadow border border-green-400"
    >
      {{ message }}
    </div>

    <!-- Errors -->
    <div
      v-for="(error, index) in errors"
      :key="index"
      class="px-4 py-3 rounded-lg bg-red-500 text-white shadow border border-red-400"
    >
      {{ error }}
    </div>

  </div>
</template>
