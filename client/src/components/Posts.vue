<script setup>
  import { onMounted, nextTick, ref } from "vue"
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
    setPerPage,
    setSort,
    setQuery
  } = postsState

  const listRef = ref(null)
  const search = ref("")
  const sort = ref("created_at_desc")

  const scrollListTop = async () => {
    await nextTick()
    listRef.value?.scrollTo?.({ top: 0, behavior: "smooth" })
  }

  const onPageChange = async (page) => {
    await fetchPosts(page)
    await scrollListTop()
  }

  const onPerPageChange = async (perPage) => {
    await setPerPage(perPage)
    await scrollListTop()
  }

  const applySort = async () => {
    await setSort(sort.value)
    await scrollListTop()
  }

  const applySearch = async () => {
    await setQuery(search.value)
    await scrollListTop()
  }

  const clearSearch = async () => {
    search.value = ""
    await setQuery("")
    await scrollListTop()
  }

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
      <!-- Search + Sort -->
      <div class="flex items-center gap-2 mb-3">
        <!-- Search input -->
        <div class="relative flex-1">
          <i class="fa-solid fa-magnifying-glass absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-sm pointer-events-none"></i>

          <button
            v-if="search"
            type="button"
            @click="clearSearch"
            class="absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-200 transition"
            aria-label="Clear search"
          >
            <i class="fa-solid fa-xmark"></i>
          </button>

          <input
            v-model="search"
            placeholder="Title or Body..."
            class="search-input w-full bg-white/5 border border-white/10 rounded-lg py-2 !pl-9 pr-3 text-gray-200 placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500/40"
            @keydown.enter="applySearch"
          />
        </div>

        <!-- Sort select -->
        <div class="relative">
          <i class="fa-solid fa-filter absolute left-2 top-1/2 -translate-y-1/2 text-gray-400 text-xs pointer-events-none"></i>

          <select
            v-model="sort"
            @change="applySort"
            class="bg-white/5 border border-white/10 rounded-lg py-2 pl-7 pr-2 text-gray-500 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500/40"
          >
            <option value="created_at_desc">Newest</option>
            <option value="created_at_asc">Oldest</option>
            <option value="title_asc">A → Z</option>
            <option value="title_desc">Z → A</option>
          </select>
        </div>
      </div>
      <div class="flex-1 overflow-y-auto" ref="listRef">
        <template v-for="post in posts" :key="post.id">
          <Post :post="post" @edit="editPost" @delete="deletePost" />
        </template>
      </div>

      <div class="shrink-0 pt-3">
        <Pagination
          :pagy="pagy"
          @change="(p) => onPageChange(p)"
          @per-page-change="(n) => onPerPageChange(n)"
        />
      </div>
    </div>
  </div>
</template>
