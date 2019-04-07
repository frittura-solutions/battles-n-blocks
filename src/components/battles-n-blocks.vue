<template>
    <div>
        <hello-metamask />
        <main-component />
    </div>
</template>
<script>
import HelloMetamask from '@/components/hello-metamask'
import MainComponent from '@/components/main-component'
import pollWeb3 from '../util/pollWeb3'
export default {
    name: 'battles-n-bottles',
    beforeCreate() {
        console.log('registerWeb3 Action dispatched from battles-n-bottles.vue')
        this.$store.dispatch('registerWeb3')
        console.log('dispatching getContractInstance')
        this.$store.dispatch('getContractInstance')
        pollWeb3()
    },
    components: {
        'hello-metamask': HelloMetamask,
        'main-component': MainComponent
    }
}
</script>
<style scoped>
</style>