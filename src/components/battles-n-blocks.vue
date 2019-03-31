<template>
    <div>
        <hello-metamask />
        <main-component />
    </div>
</template>
<script>
import HelloMetamask from '@/components/hello-metamask'
import MainComponent from '@/components/main-component'
export default {
    name: 'battles-n-bottles',
    beforeCreate() {
        console.log('registerWeb3 Action dispatched from battles-n-bottles.vue')
        this.$store.dispatch('registerWeb3')
    },
    components: {
        'hello-metamask': HelloMetamask,
        'main-component': MainComponent
    }
}
</script>
<style scoped>
</style>