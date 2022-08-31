<template>
  <Layout>
    Powered by Laravel · v{{ version }}
  </Layout>
</template>

<script>
import {computed} from 'vue'
import {usePage} from '@inertiajs/inertia-vue3'

import Layout from '../components/layout/Layout.vue';

export default {
  components: {
    Layout,
  },
  setup() {
    const version = computed(() => usePage().props.value.version)
    return {version}
  }
}
</script>
