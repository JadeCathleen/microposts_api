import { ref, computed } from "vue"

const user = ref(localStorage.getItem("user"))
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

    if (!res.ok) {
      throw new Error("Invalid credentials")
    }

    const data = await res.json()
    console.log(res.headers)
    token.value = res.headers.get("authorization")
    localStorage.setItem("token", token.value)
    user.value = data.user
    localStorage.setItem("user", JSON.stringify(user.value))
    console.log("useAuth login", user.value, token.value, isAuthenticated.value)
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
