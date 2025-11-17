<script setup>
  import { ref, onMounted } from "vue";

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
    posts.value.push(data)
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
    posts.value[post_index] = data

    resetValues()
    isEditing.value = false
  }
  const cancelEdit = async() => {
    resetValues()
    isEditing.value = false
  }

  const deletePost = async(id) => {
    await fetch(`${API_URL}/${id}`, {
      method: 'DELETE'
    })
    posts.value = posts.value.filter(post => post.id !== id)
  }

  const editPost = async(id) => {
    const post = posts.value.find(post => post.id === id )
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
  <div>
    <h1>Posts</h1>

    <!-- Create or Post -->
     <input type="text"
        v-model="title"
        placeholder="Title"
        class="input" />
      <input type="text"
        v-model="body"
        placeholder="Body"
        class="input" />

      <template v-if="isEditing">
        <button @click="updatePost">Update</button>
        <button @click="cancelEdit">Cancel</button>
      </template>
      <button v-else @click="createPost">Create</button>

      <div v-for="post in posts" :key="post.id">
        <h5>[{{ post.id }}] {{ post.title }}</h5>
        <p>{{ post.body }}</p>

        <button class="me-2" @click="editPost(post.id)">Edit</button>
        <button @click="deletePost(post.id)">Delete</button>
      </div>
  </div>
</template>

<style scoped>
  .input {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: 2px solid #ccc;
  }
</style>
