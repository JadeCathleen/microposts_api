<script setup>
import { ref } from "vue"
import { useAuth } from "../composables/useAuth"
import { useRouter } from "vue-router"

const email = ref("")
const password = ref("")
const error = ref("")

const { login } = useAuth()
const router = useRouter()

const submit = async () => {
  try {
    await login(email.value, password.value)
    router.replace('/');
  } catch (e) {
    console.log(e.message)
    error.value = e.message
  }
}
</script>

<template>
  <div class="login">
    <h1 class="flex items-center justify-center mb-10">Login</h1>

    <form class="flex flex-col items-center w-100" @submit.prevent="submit">
      <input v-model="email" class="mb-1" type="email" placeholder="Email" />
      <input v-model="password" class="mb-2" type="password" autocomplete="current-password" placeholder="Password" />
      <button class="bg-indigo-500 hover:bg-indigo-400 me-2 px-4 py-2 rounded text-white disabled:opacity-50 disabled:hover:bg-indigo-500 font-semibold">Login</button>
    </form>

    <p v-if="error">{{ error }}</p>
  </div>
</template>
