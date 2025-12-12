import { ref } from 'vue'
import { useApi } from './useApi'
import { useForm } from './useForm'

export function usePosts(baseURL = "http://localhost:3000") {

  const { errors: fetchErrors, flash, request } = useApi(baseURL)
  const {
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
  } = useForm()

  // Local state
  const posts = ref([])
  const isEditing = ref(false)
  const postId = ref(null)
  const errors = ref([])
  const flashMessage = ref("")

  const setFlash = (msg, timeout = 2500) => {
    flashMessage.value = msg
    setTimeout(() => (flashMessage.value = ""), timeout)
  }

  /* ---- FETCH ---- */
  const fetchPosts = async () => {
    const { ok, data } = await request("/microposts")

    if (!ok) {
      errors.value.push(...fetchErrors.value)
      return
    }

    posts.value = data.microposts || []
  }

  /* ---- CREATE ---- */
  const createPost = async () => {
    if (isDisabled.value) return

    const { ok, data } = await request("/microposts", {
      method: "POST",
      body: { micropost: { title: title.value, body: body.value }}
    })

    if (!ok) return

    posts.value.push(data.micropost)
    setFlash(data.flash?.notice || "Created")
    resetValues()
  }

  /* ---- UPDATE ---- */
  const updatePost = async () => {
    if (isDisabled.value) return

    const { ok, data } = await request(`/microposts/${postId.value}`, {
      method: "PATCH",
      body: { micropost: { title: title.value, body: body.value }}
    })

    if (!ok) return

    const idx = posts.value.findIndex(p => p.id === postId.value)
    if (idx !== -1) posts.value[idx] = data.micropost

    setFlash(data.flash?.notice || "Updated")
    resetValues()
    isEditing.value = false
  }

  /* ---- DELETE ---- */
  const deletePost = async (id) => {
    const { ok } = await request(`/microposts/${id}`, { method: "DELETE" })

    if (!ok) return

    posts.value = posts.value.filter(p => p.id !== id)
    setFlash("Deleted")
  }

  /* ---- EDIT MODE ---- */
  const editPost = (post) => {
    isEditing.value = true
    title.value = post.title
    body.value = post.body
    postId.value = post.id

    if (window.scrollY > 200) {
      window.scrollTo({ top: 0, behavior: "smooth" })
    }
  }

  const cancelEdit = () => {
    isEditing.value = false
    resetValues()
  }

  const resetValues = () => {
    reset()
    postId.value = null
    errors.value = []
  }

  return {
    posts,
    errors,
    flashMessage,
    isEditing,
    title,
    body,
    titleError,
    bodyError,
    titleTouched,
    bodyTouched,
    markTitleTouched,
    markBodyTouched,
    isDisabled,

    fetchPosts,
    createPost,
    updatePost,
    deletePost,
    editPost,
    cancelEdit
  }
}
