<script setup>
import { computed } from "vue"

const props = defineProps({
  pagy: { type: Object, required: true }, // { page, pages, prev, next }
  window: { type: Number, default: 1 },
  perPageOptions: { type: Array, default: () => [5, 10, 15, 20] },
})

const emit = defineEmits(["change", "per-page-change"])

const page = computed(() => Number(props.pagy?.page ?? 1))
const pages = computed(() => Number(props.pagy?.pages ?? 1))
const perPage = computed(() => Number(props.pagy?.limit ?? props.perPageOptions[0]))
const prev = computed(() => props.pagy?.prev ?? null)
const next = computed(() => props.pagy?.next ?? null)

function go(p) {
  const n = Number(p)
  if (!Number.isFinite(n)) return
  if (n < 1 || n > pages.value) return
  if (n === page.value) return
  emit("change", n)
}

const items = computed(() => {
  const total = pages.value
  const current = page.value
  if (total <= 1) return []

  const w = Math.max(0, props.window)
  const set = new Set([1, total])
  for (let p = current - w; p <= current + w; p++) {
    if (p >= 1 && p <= total) set.add(p)
  }
  const sorted = [...set].sort((a, b) => a - b)

  const out = []
  for (let i = 0; i < sorted.length; i++) {
    out.push({ type: "page", value: sorted[i] })
    const a = sorted[i]
    const b = sorted[i + 1]
    if (b && b - a > 1) out.push({ type: "ellipsis" })
  }
  return out
})
</script>

<template>
  <div class="flex items-center justify-between gap-4 mt-4">
    <!-- Per page options -->
     <div>
       <label class="text-gray-400 mr-1">
         Posts / page:
       </label>
       <select
         v-model="perPage"
         @change="emit('per-page-change', Number($event.target.value))"
         class="bg-white/5 border border-white/10 rounded-lg px-2 py-1 text-gray-600"
       >
         <option v-for="n in perPageOptions" :key="n" :value="n">{{ n }}</option>
       </select>
     </div>

    <!-- Pagination buttons -->
     <div  v-if="pages > 1">
       <button
         class="px-2 py-1 mr-1 rounded-lg border border-white/10 bg-white/5 hover:bg-white/10 disabled:opacity-40 disabled:hover:bg-white/5"
         :disabled="!prev"
         @click="go(prev)"
         aria-label="Previous page"
       >
         ‹
       </button>

       <template v-for="(it, idx) in items" :key="idx">
         <span v-if="it.type === 'ellipsis'" class="px-2 text-gray-400">…</span>

         <button
           v-else
           class="min-w-9 px-2 py-1 mr-1 rounded-lg border border-white/10 bg-white/5 hover:bg-white/10"
           :class="it.value === page ? 'bg-white/10 text-white font-semibold' : 'text-gray-200'"
           @click="go(it.value)"
           :aria-current="it.value === page ? 'page' : undefined"
         >
           {{ it.value }}
         </button>
       </template>

       <button
         class="px-2 py-1 mr-1 rounded-lg border border-white/10 bg-white/5 hover:bg-white/10 disabled:opacity-40 disabled:hover:bg-white/5"
         :disabled="!next"
         @click="go(next)"
         aria-label="Next page"
       >
         ›
       </button>
     </div>
  </div>
</template>
