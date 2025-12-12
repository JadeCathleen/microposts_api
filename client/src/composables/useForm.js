import { ref, computed } from "vue"

export function useForm(maxTitle = 50, maxBody = 140) {
  const title = ref("")
  const body = ref("")
  const titleTouched = ref(false)
  const bodyTouched = ref(false)

  // --- Validation ---
  const titleError = computed(() => {
    if (!title.value) return "Title is required."
    if (title.value.length > maxTitle) return `Title must be <= ${maxTitle} characters.`
    return null
  })

  const bodyError = computed(() => {
    if (!body.value) return "Body is required."
    if (body.value.length > maxBody) return `Body must be <= ${maxBody} characters.`
    return null
  })

  const isDisabled = computed(() => titleError.value || bodyError.value)

  const markTitleTouched = () => (titleTouched.value = true)
  const markBodyTouched = () => (bodyTouched.value = true)

  // Reset form
  const reset = () => {
    title.value = ""
    body.value = ""
    titleTouched.value = false
    bodyTouched.value = false
  }

  return {
    title,
    body,
    titleTouched,
    bodyTouched,
    titleError,
    bodyError,
    isDisabled,
    markTitleTouched,
    markBodyTouched,
    reset
  }
}
