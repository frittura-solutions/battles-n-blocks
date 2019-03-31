import Vue from 'vue'
import Router from 'vue-router'
import BattlesNBlocks from '@/components/battles-n-blocks'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'battles-n-blocks',
      component: BattlesNBlocks
    }
  ]
})
