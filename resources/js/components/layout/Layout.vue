<template>
  <Header/>

  <div class="mx-6">
    <slot/>
  </div>

  <Footer/>
</template>

<script>
import Footer from './partials/Footer.vue'
import Header from './partials/Header.vue'

export default {
  components: {
    Footer,
    Header,
  }
}
</script>
