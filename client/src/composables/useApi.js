import { ref } from "vue"
import { useAuth } from "./useAuth";
import apiBaseURL from "./useApiBase";

export function useApi(baseURL = apiBaseURL) {
  const loading = ref(false)
  const errors = ref([])
  const flash = ref("")

  const { token } = useAuth();

  const request = async (url, { method = "GET", body = null } = {}) => {
    loading.value = true
    errors.value = []
    flash.value = ""

    const headers = {}

    if (token.value) {
      headers["Authorization"] = token.value
    }

    if (body) {
      headers["Content-Type"] = "application/json"
    }

    const options = {
      method,
      headers,
      body: body ? JSON.stringify(body) : null
    }

    try {
      const res = await fetch(baseURL + url, options)
      const data = await res.json().catch(() => ({}))

      if (!res.ok) {
        if (data.errors) errors.value = data.errors
        if (data.flash?.alert) errors.value.push(data.flash.alert)
        return { ok: false, data }
      }

      if (data.flash?.notice) flash.value = data.flash.notice

      return { ok: true, data }

    } catch (err) {
      errors.value.push(err.message)
      return { ok: false, data: null }

    } finally {
      loading.value = false
    }
  }

  return {
    loading,
    errors,
    flash,
    request
  }
}
