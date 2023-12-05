import VueRouter from "vue-router";
import "nprogress/nprogress.css"
import Vue from "vue";
import index from "../views/index.vue"
import login from "../views/login.vue"
import register from "../views/register.vue"
import home from "../views/home.vue"
import not_exist_page from "../views/error/404page.vue"
import user from "../views/user.vue"
import homepage from "@/views/home_page.vue";
import NProgress from "nprogress"
import artworks from "@/views/artworks.vue";
import search from "@/views/search.vue";
import searchhome from "@/views/search_home.vue";
import history from "@/views/history.vue";
import ideacenter from "@/views/idea_center.vue";
import ideahome from "@/views/idea/home.vue"
import submit from "@/views/idea/submit.vue";
import artwork_manage from "@/views/idea/artwork_manage.vue";
import fans_manage from "@/views/idea/fans_manage.vue";
import artwork_data from "@/views/idea/artwork_data.vue";
import fans_data from "@/views/idea/fans_data.vue";
import message_center from "@/views/message_center.vue";
import message_home from '@/views/message/home.vue'
import message_window from "@/views/message/message_window.vue";


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
                    path:'/search',
                    component:search
                },
                {
                    path:'/searchHome',
                    component:searchhome
                },
                {
                    path:'/history',
                    component:history
                },
                {
                    path:'/message',
                    component:message_center,
                    children:[
                        {
                            path: '/message_home',
                            component: message_home
                        },
                        {
                            path: '/letter',
                            component: message_window
                        }
                    ]
                },
                {
                    path:'/idea',
                    component:ideacenter,
                    children:[
                        {
                            path:'/ideahome',
                            component:ideahome
                        },
                        {
                            path:'/submit',
                            component:submit
                        },
                        {
                            path:'/artwork_manage',
                            component:artwork_manage
                        },
                        {
                          path:'/fans_manage',
                          component:fans_manage
                        },
                        {
                            path:'/artwork_data',
                            component:artwork_data
                        },
                        {
                            path:'/fans_data',
                            component:fans_data
                        }
                    ]
                },
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

const originalPush = VueRouter.prototype.push
VueRouter.prototype.push = function push(location, onResolve, onReject) {
    if (onResolve || onReject) return originalPush.call(this, location, onResolve, onReject)
    return originalPush.call(this, location).catch(err => err)
}


export default router