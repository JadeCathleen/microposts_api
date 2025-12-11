<script setup>
  import { ref, onMounted } from "vue";
  const props = defineProps({
    post: {
      type: Object,
      required: true
    }
  })
  const emit = defineEmits(['edit', 'delete'])
  const handleEditEvent = () => {
    emit('edit', props.post)
  }
  const handleDeleteEvent = () => {
    emit('delete', props.post.id)
  }
</script>

<template>
  <div class=" bg-gray-800 px-3 py-3 rounded-md outline-1 outline-gray-500 flex justify-between mx-2 my-2">
    <div class="flex flex-col items-start me-2">
      <h5 class="font-bold">[{{ post.id }}] {{ post.title }}</h5>
      <p class="text-wrap text-left">{{ post.body }}</p>
    </div>

    <div class="flex flex-col items-start">
      <a class="hover:text-indigo-500 me-1" @click="handleEditEvent"><i class="fa-solid fa-pen-to-square"></i></a>
      <a class="hover:text-red-500" @click="handleDeleteEvent"><i class="fa-solid fa-trash-can"></i></a>
    </div>
  </div>
</template>
