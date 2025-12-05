<script setup>
  import { ref, onMounted } from "vue";
  import Post from "./Post.vue"

  const API_URL = "http://localhost:3000/microposts"
  const posts = ref([])
  const title = ref('')
  const body = ref('')
  const post_id = ref(0)
  const isEditing = ref(false)

  onMounted(async() => {
    const res = await fetch(API_URL)
    const json_response = await res.json()
    posts.value = json_response.microposts
  })

  const resetValues = () => {
    title.value = ''
    body.value = ''
    post_id.value = 0
  }
  const createPost = async() => {
    const res = await fetch(API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        title: title.value,
        body: body.value
      })
    })

    const data = await res.json()
    console.log(data)
    posts.value.push(data["micropost"])
    resetValues()
  }

  const updatePost = async() => {
    const res = await fetch(`${API_URL}/${post_id.value}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        title: title.value,
        body: body.value,
        id: post_id.value
      })
    })

    const data = await res.json()
    const post_index = posts.value.findIndex(post => post.id === post_id.value )
    posts.value[post_index] = data["micropost"]

    resetValues()
    isEditing.value = false
  }
  const cancelEdit = async() => {
    resetValues()
    isEditing.value = false
  }

  const deletePost = async(post_id) => {
    await fetch(`${API_URL}/${post_id}`, {
      method: 'DELETE'
    })
    posts.value = posts.value.filter(post => post.id !== post_id)
  }

  const editPost = async(post) => {
    isEditing.value = true
    title.value = post.title
    body.value = post.body
    post_id.value = post.id

    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    })
  }
</script>

<template>
  <div class="md:flex md:justify-between md:items-center">
    <div class="flex flex-col md:me-8">
      <h1 class="text-3xl font-bold mb-8">Posts</h1>

      <div class="flex flex-col items-center">
        <input type="text"
          v-model="title"
          placeholder="Title"
          class=" bg-white/5 placeholder:text-gray-500 w-70 mb-2" />
        <textarea type="text"
          v-model="body"
          placeholder="Body"
          class=" bg-white/5 placeholder:text-gray-500 w-70" />
      </div>

        <div class="mt-2 mb-4">
          <template v-if="isEditing">
            <button @click="updatePost" class="bg-indigo-500 hover:bg-indigo-400 me-2">Update</button>
            <button @click="cancelEdit" class="bg-gray-300 hover:bg-gray-200 text-gray-600">Cancel</button>
          </template>
          <button class="bg-indigo-500 hover:bg-indigo-400" v-else @click="createPost">Create</button>
        </div>
    </div>

    <div class="flex flex-col text-gray-300 overflow-y-auto w-100 h-200">
      <template v-for="post in posts" :key="post.id">
        <Post :post="post" @edit="editPost" @delete="deletePost"/>
      </template>
    </div>
  </div>
</template>
