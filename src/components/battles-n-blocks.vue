<template>
    <hello-metamask />
</template>
<script>
import HelloMetamask from '@/components/hello-metamask'
export default {
    name: 'battles-n-bottles',
    beforeCreate() {
        console.log('registerWeb3 Action dispatched from battles-n-bottles.vue')
        this.$store.dispatch('registerWeb3')
    },
    components: {
        'hello-metamask': HelloMetamask
    }
}
</script>
<style scoped>
</style>