import VueRouter from "vue-router";
import Vue from "vue";
import index from "../views/index.vue"
import login from "../views/login.vue"
import register from "../views/register.vue"
import home from "../views/home.vue"
import not_exist_page from "../views/error/404page.vue"
import user from "../views/user.vue"
import homepage from "@/views/homepage.vue";
import NProgress from "nprogress"
import "nprogress/nprogress.css"
import artworks from "@/views/artworks.vue";
import submit from "@/views/submit.vue";
import search from "@/views/search.vue";
import searchhome from "@/views/searchhome.vue";

Vue.use(VueRouter)
NProgress.configure({showSpinner: false})

const router=new VueRouter({
    routes:[
        {
            path:'*',
            name:'404page',
            component:not_exist_page
        },
        {
            path:'/',
            component:index
        },
        {
            path:'/index',
            component:index
        },
        {
            path:"/login",
            component:login
        },
        {
            path:"/register",
            component:register
        },
        {
            path:"/main",
            component:home,
            children:[
                {
                    path:'/home',
                    component:homepage
                },
                {
                    path:'/user',
                    component:user
                },
                {
                    path:'/artworks',
                    component:artworks,
                },
                {
                    path:'/submit',
                    component:submit
                },
                {
                    path:'/search',
                    component:search
                },
                {
                    path:'/searchHome',
                    component:searchhome
                }
            ]
        }
    ],
    mode:"history"
})

router.beforeEach((to, from, next) => {
    NProgress.start();
    const token = localStorage.getItem('token');
    const allowedRoutes = ['/login', '/index', '/register','/'];
    if (to.name==='404page'){
        next(false);
        NProgress.done();
    }else {
        next();
        NProgress.done();
    }
    if (!allowedRoutes.includes(to.path) && !token) {
        next({
            path:"/login",
            query:{msg:'brq'}
        });
        NProgress.done();
    } else {
        next();
        NProgress.done();
    }
});

export default router