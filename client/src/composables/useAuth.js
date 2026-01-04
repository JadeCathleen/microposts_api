import { ref, computed } from "vue"

const user = ref(JSON.parse(localStorage.getItem("user")))
const token = ref(localStorage.getItem("token"))

const isAuthenticated = computed(() => !!token.value)

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

    const data = await res.json()

    if (!res.ok) {
      throw new Error(data.error || "Invalid credentials")
    }

    token.value = res.headers.get("authorization")
    user.value = data.user

    localStorage.setItem("token", token.value)
    localStorage.setItem("user", JSON.stringify(user.value))
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
    localStorage.removeItem("user")
  }

  return { user, token, login, logout, isAuthenticated }
}
