<script setup>
import { ref } from "vue"
import { useRouter } from "vue-router"
import { useAuth } from "../composables/useAuth"

const username = ref("")
const email = ref("")
const password = ref("")
const passwordConfirmation = ref("")
const error = ref("")

const router = useRouter()
const { login } = useAuth()

const submit = async () => {
  try {
    const res = await fetch("http://localhost:3000/api/v1/sign_up", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        user: {
          username: username.value,
          email: email.value,
          password: password.value,
          password_confirmation: passwordConfirmation.value
        }
      })
    })

    const data = await res.json()

    if (!res.ok) throw new Error(data.error || "Signup failed")

    // auto-login after signup
    await login(email.value, password.value)
    router.push("/")
  } catch (e) {
    error.value = e.message
  }
}
</script>

<template>
  <div class="signup">
    <h1 class="flex items-center justify-center mb-10">Sign up</h1>

    <form class="flex flex-col items-center justify-center" @submit.prevent="submit">
      <input v-model="username" class="mb-1" type="text" placeholder="Username" />
      <input v-model="email" class="mb-1" type="email" autocomplete="username" placeholder="Email" />
      <input v-model="password" class="mb-1" type="password" autocomplete="new-password" placeholder="Password" />
      <input
        v-model="passwordConfirmation"
        class="mb-2"
        type="password"
        autocomplete="new-password"
        placeholder="Confirm password"
      />
      <button class="bg-indigo-500 hover:bg-indigo-400 me-2 px-4 py-2 rounded text-white disabled:opacity-50 disabled:hover:bg-indigo-500 font-semibold">Create account</button>
    </form>

    <p v-if="error">{{ error }}</p>
  </div>
</template>
