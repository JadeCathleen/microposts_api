import { ref, computed, watch } from "vue"

const user = ref(null)
const token = ref(localStorage.getItem("token"))

const isAuthenticated = computed(() => !!token.value)

const storedUser = localStorage.getItem("user")
if (storedUser) {
  user.value = JSON.parse(storedUser)
}

watch(user, (val) => {
  if (val) {
    localStorage.setItem("user", JSON.stringify(val))
  } else {
    localStorage.removeItem("user")
  }
})

export function useAuth() {
  const login = async (email, password) => {
    const res = await fetch("http://localhost:3000/api/v1/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        user: { email, password }
      })
    })

    if (!res.ok) {
      throw new Error("Invalid credentials")
    }

    const data = await res.json()
    token.value = res.headers.get("authorization")
    localStorage.setItem("token", token.value)

    user.value = data.user
  }

  const logout = async () => {
    await fetch("http://localhost:3000/api/v1/logout", {
      method: "DELETE",
      headers: {
        Authorization: token.value
      }
    })

    token.value = null
    user.value = null

    localStorage.removeItem("token")
  }

  return { user, token, login, logout, isAuthenticated }
}
