import Vue from 'vue'
import App from './App.vue'
import ElementUI from 'element-ui'
import elFromSchema from '@kummy/el-form-schema'
import 'element-ui/lib/theme-chalk/index.css'
import axios from 'axios'
import router from "./router/router";
import store from "./store/index"
import 'default-passive-events'

export const eventBus = new Vue();
Vue.use(ElementUI)
Vue.use(elFromSchema)
Vue.prototype.axios=axios;
new Vue({
  render: h => h(App),
  router:router,
  store
}).$mount('#app')
