import { ref } from 'vue'
import { useApi } from './useApi'
import { useForm } from './useForm'

export function usePosts() {

  const { errors: fetchErrors, flash, request } = useApi()
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
  const pagy = ref({ page: 1, pages: 1, prev: null, next: null, limit: 5, count: 0 })
  const isEditing = ref(false)
  const postId = ref(null)
  const errors = ref([])
  const flashMessage = ref("")

  const setFlash = (msg, timeout = 2500) => {
    flashMessage.value = msg
    setTimeout(() => (flashMessage.value = ""), timeout)
  }

  const filters = ref({
    q: "",
    sort: "created_at_desc",
    user_id: null,
  })

  const buildQuery = (page) => {
    const params = new URLSearchParams()

    params.set("page", String(page))
    params.set("per_page", String(pagy.value.limit ?? 5))
    params.set("sort", filters.value.sort)

    if (filters.value.q?.trim()) params.set("q", filters.value.q.trim())
    if (filters.value.user_id) params.set("user_id", String(filters.value.user_id))

    return `/microposts?${params.toString()}`
  }

  /* ---- FETCH ---- */
  const fetchPosts = async (page = 1) => {
    const { ok, data } = await request(buildQuery(page))

    if (!ok) {
      errors.value.push(...fetchErrors.value)
      return
    }

    posts.value = data.microposts || []
    pagy.value = data.pagy || pagy.value
  }

  /* ---- CREATE ---- */
  const createPost = async () => {
    if (isDisabled.value) return

    const { ok, data } = await request("/microposts", {
      method: "POST",
      body: { micropost: { title: title.value, body: body.value }}
    })

    if (!ok) return

    await fetchPosts(1)
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

    await fetchPosts(pagy.value.page)
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

  const setPerPage = async (perPage) => {
    const n = Number(perPage)
    if (![5, 10, 15, 20].includes(n)) return

    pagy.value = { ...pagy.value, limit: n }
    await fetchPosts(1)
  }

  const setSort = async (sort) => {
    const allowedSort = ["created_at_asc", "created_at_desc", "title_asc", "title_desc"]

    if (!allowedSort.includes(sort)) return
    console.log(sort)
    filters.value.sort = sort
    await fetchPosts(1)
  }

  const setQuery = async (q) => {
    filters.value.q = q
    await fetchPosts(1)
  }

  return {
    posts,
    pagy,
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
    cancelEdit,
    setPerPage,
    setSort,
    setQuery,
  }
}
