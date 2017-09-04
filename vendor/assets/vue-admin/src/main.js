// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
const INITIAL_ELEMENT = 'files-uploader';

import Vue from 'vue'
import Uploader from './modules/App'
import VueResource from 'vue-resource'
import VueConfig from 'vue-config'

let resourceUrl = document.getElementById(INITIAL_ELEMENT).attributes['data-resource'].value
let token = document.querySelector('meta[name="csrf-token"]')


Vue.use(VueResource)
Vue.use(VueConfig, {
  resource: resourceUrl,
  token: token
})



Vue.config.productionTip = false
Vue.url.options.root = resourceUrl
Vue.http.headers.common['X-CSRF-Token'] = token ? token.content : ''
Vue.http.options.emulateJSON = true

/* eslint-disable no-new */
new Vue({
  el: '#' + INITIAL_ELEMENT,
  components: { Uploader }
})
