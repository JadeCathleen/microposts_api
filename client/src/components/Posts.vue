<script setup>
  import { ref, onMounted, computed, watch } from "vue";
  import Post from "./Post.vue";
  import FlashMessage from "./FlashMessage.vue";

  /* ---------- Config & state ---------- */
  const API_URL = "http://localhost:3000/microposts";
  const MAX_TITLE = 50;
  const MAX_BODY = 140;

  const posts = ref([]);
  const title = ref("");
  const body = ref("");
  const postId = ref(null);
  const isEditing = ref(false);

  // UI / feedback
  const flashMessage = ref("");
  const errors = ref([]);

  // Handling errors' appearance
  const titleTouched = ref(false)
  const bodyTouched = ref(false)

  /* ---------- Live validation ---------- */
  const titleError = computed(() => {
    if (!title.value) return "Title is required.";
    if (title.value.length > MAX_TITLE) return "Title must be <= 50 characters.";
    return null;
  });

  const bodyError = computed(() => {
    if (!body.value) return "Body is required.";
    if (body.value.length > MAX_BODY) return "Body must be <= 140 characters.";
    return null;
  });

  // Disable create/update button
  const isDisabled = computed(() => titleError.value || bodyError.value);

  // simple validateForm() for create/update
  const validateForm = () => !isDisabled.value;

  // Handling errors' appearance
  const markTitleTouched = () => titleTouched.value = true
  const markBodyTouched = () => bodyTouched.value = true

  /* ---------- Lifecycle: fetch posts ---------- */
  onMounted(fetchPosts);

  async function fetchPosts() {
    try {
      const res = await fetch(API_URL);
      const json = await res.json();
      posts.value = json.microposts || [];
    } catch (err) {
      errors.value.push("Failed to load posts: " + err.message);
    }
  }

  /* ---------- Small helpers ---------- */
  const setFlash = (msg, timeout = 3000) => {
    flashMessage.value = msg || "";
    if (!msg) return;
    setTimeout(() => (flashMessage.value = ""), timeout);
  };

  const pushErrorsFromResponse = (data) => {
    if (!data) return;
    if (Array.isArray(data.errors) && data.errors.length) {
      errors.value.push(...data.errors);
    } else if (data.flash?.alert) {
      errors.value.push(data.flash.alert);
    }
  };

  const apiRequest = async (method, url, payload = null) => {
    const options = { method, headers: {} };
    if (payload) {
      options.headers["Content-Type"] = "application/json";
      options.body = JSON.stringify(payload);
    }

    const res = await fetch(url, options);
    const data = await res.json().catch(() => ({}));
    return { ok: res.ok, status: res.status, data };
  };

  /* ---------- CRUD actions ---------- */
  const resetValues = () => {
    title.value = "";
    body.value = "";
    postId.value = null;
    errors.value = [];
    titleTouched.value = false;
    bodyTouched.value = false;
  };

  const createPost = async () => {
    if (!validateForm()) return;

    try {
      const { ok, data } = await apiRequest("POST", API_URL, {
        micropost: { title: title.value, body: body.value },
      });

      if (!ok) {
        pushErrorsFromResponse(data);
        return;
      }

      setFlash(data.flash?.notice || "Created");
      posts.value.push(data.micropost);
      resetValues();
    } catch (err) {
      errors.value.push(err.message);
    }
  };

  const updatePost = async () => {
    if (!validateForm()) return;

    try {
      const { ok, data } = await apiRequest("PUT", `${API_URL}/${postId.value}`, {
        micropost: { title: title.value, body: body.value },
      });

      if (!ok) {
        pushErrorsFromResponse(data);
        return;
      }

      setFlash(data.flash?.notice || "Updated");
      const idx = posts.value.findIndex((p) => p.id === postId.value);
      if (idx !== -1) posts.value.splice(idx, 1, data.micropost);
      resetValues();
    } catch (err) {
      errors.value.push(err.message);
    } finally {
      isEditing.value = false;
    }
  };

  const deletePost = async (id) => {
    if (!window.confirm("Are you sure you want to delete this post?")) {
      return;
    }

    try {
      const { ok, data } = await apiRequest("DELETE", `${API_URL}/${id}`);
      if (!ok) {
        pushErrorsFromResponse(data);
        return;
      }
      posts.value = posts.value.filter((p) => p.id !== id);
      setFlash("Deleted");
    } catch (err) {
      errors.value.push(err.message);
    }
  };

  const editPost = async(post) => {
    isEditing.value = true
    title.value = post.title
    body.value = post.body
    postId.value = post.id

    // UX: scroll to top to show form
    if (window.scrollY > 200) {
      window.scrollTo({ top: 0, behavior: 'smooth' })
    }
  };

  const cancelEdit = () => {
    resetValues();
    isEditing.value = false;
  };
</script>

<template>
  <div class="md:flex md:justify-between md:items-center">
    <div class="flex flex-col md:me-8">
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
            :disabled="isDisabled"
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
          :disabled="isDisabled"
          class="bg-indigo-500 hover:bg-indigo-400 px-4 py-2 rounded text-white disabled:opacity-50 disabled:hover:bg-indigo-500 font-semibold"
        >
          Create
        </button>
      </div>
    </div>

    <div class="flex flex-col text-gray-300 overflow-y-auto w-100 h-200">
      <template v-for="post in posts" :key="post.id">
        <Post :post="post" @edit="editPost" @delete="deletePost" />
      </template>
    </div>
  </div>
</template>
