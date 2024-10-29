// https://vitepress.dev/guide/custom-theme
import {h} from 'vue'
import Theme from 'vitepress/theme'
import './style.css'
 import MyLayout from "./MyLayout.vue";



export default {
    ...Theme,
     Layout: MyLayout,
    async enhanceApp({app, router, siteData}) {

    }
}
