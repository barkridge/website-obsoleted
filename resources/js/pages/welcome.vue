<template>
  <p class="m-4">
    Powered by Laravel · v{{ version }}
  </p>
</template>

<script>
import {computed} from 'vue'
import {usePage} from '@inertiajs/inertia-vue3'

export default {
  setup() {
    const version = computed(() => usePage().props.value.version)
    return {version}
  }
}
</script>
