<script setup>
  import { onMounted } from "vue"
  import { usePosts } from "../composables/usePosts"
  import Post from "./Post.vue"
  import FlashMessage from "./FlashMessage.vue"
  import Pagination from "./Pagination.vue"

  const postsState = usePosts()
  const {
    posts,
    pagy,
    errors,
    flashMessage,
    title,
    body,
    titleError,
    bodyError,
    titleTouched,
    bodyTouched,
    markTitleTouched,
    markBodyTouched,
    isDisabled,
    isEditing,
    fetchPosts,
    createPost,
    updatePost,
    deletePost,
    editPost,
    cancelEdit,
    setPerPage
  } = postsState

  onMounted(fetchPosts)
</script>

<template>
  <div class="md:flex md:justify-between md:items-center">
    <div class="flex flex-col justify-center items-center md:me-8">
      <h1 class="text-3xl font-bold mb-8">Posts</h1>

      <!-- Global flash + errors -->
      <FlashMessage :message="flashMessage" :errors="errors" />

      <div class="flex flex-col items-center">
        <input
          v-model="title"
          @blur="markTitleTouched"
          placeholder="Title (max 50 characters)"
          class="required bg-white/5 placeholder:text-gray-500 w-70 mb-2 p-2 rounded border transition"
          :class="titleError && titleTouched ? 'border-2 border-red-500 ring-1 ring-red-200' : 'border-transparent'"
        />
        <p v-if="titleError && titleTouched" class="text-red-400 text-sm mb-2">{{ titleError }}</p>

        <textarea
          v-model="body"
          @blur="markBodyTouched"
          placeholder="Body (max 140 characters)"
          class="bg-white/5 placeholder:text-gray-500 w-70 p-2 rounded border transition"
          :class="bodyError && bodyTouched ? 'border-2 border-red-500 ring-1 ring-red-200' : 'border-transparent'"
        ></textarea>
        <p v-if="bodyError && bodyTouched" class="text-red-400 text-sm mb-2">{{ bodyError }}</p>

      </div>

      <div class="mt-2 mb-4">
        <template v-if="isEditing">
          <button
            @click="updatePost"
            class="bg-indigo-500 hover:bg-indigo-400 me-2 px-4 py-2 rounded text-white disabled:opacity-50 disabled:hover:bg-indigo-500 font-semibold"
            :disabled="isDisabled || loading"
          >
            Update
          </button>
          <button
            @click="cancelEdit"
            class="bg-gray-300 hover:bg-gray-200 text-gray-600 px-4 py-2 rounded font-semibold"
          >
            Cancel
          </button>
        </template>

        <button
          v-else
          @click="createPost"
          :disabled="isDisabled || loading"
          class="bg-indigo-500 hover:bg-indigo-400 px-4 py-2 rounded text-white disabled:opacity-50 disabled:hover:bg-indigo-500 font-semibold"
        >
          Create
        </button>
      </div>
    </div>

    <div class="flex flex-col text-gray-300 w-100 h-100">
      <div class="flex-1 overflow-y-auto">
        <template v-for="post in posts" :key="post.id">
          <Post :post="post" @edit="editPost" @delete="deletePost" />
        </template>
      </div>

      <div class="shrink-0 pt-3">
        <Pagination
          :pagy="pagy"
          @change="(p) => { fetchPosts(p); window.scrollTo({ top: 0, behavior: 'smooth' }) }"
          @per-page-change="(n) => { setPerPage(n); window.scrollTo({ top: 0, behavior: 'smooth' }) }"
        />
      </div>
    </div>
  </div>
</template>
