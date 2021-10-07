<template>
  <div>
    <header class="masthead">
      <b-container class="px-4 px-lg-5 h-100">
        <b-row class="gx-4 gx-lg-5 h-100 align-items-center justify-content-center text-center">
            <b-col class="lg-8 align-self-end">
              <h1 class="text-black font-weight-bold">AI OJ</h1>
              <p class="text-lead text-black">인공지능 평가시스템</p>
              <template v-if="!isAuthenticated">
                <b-button variant="light"
                @click="handleBtnClick('register')">{{$t('m.Register')}}
                </b-button>
                <b-button variant="dark"
                ref="loginBtn"
                @click="handleBtnClick('login')">{{$t('m.Login')}}
                </b-button>
              </template>
            </b-col>
        </b-row>
      </b-container>
      <div class="separator separator-bottom separator-skew zindex-100">
        <svg x="0" y="0" viewBox="0 0 2560 100" preserveAspectRatio="none" version="1.1"
             xmlns="http://www.w3.org/2000/svg">
          <polygon class="fill-default" points="2560 0 2560 100 0 100"></polygon>
        </svg>
      </div> 
    </header>
  </div>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex'
  import login from '@oj/views/user/Login'
  import register from '@oj/views/user/Register'

  export default {
    components: {
      login,
      register
    },
    mounted () {
      this.getProfile()
    },
    methods: {
      ...mapActions(['getProfile', 'changeModalStatus']),
      handleRoute (route) {
        if (route && route.indexOf('admin') < 0) {
          this.$router.push(route)
        } else {
          window.open('/admin/')
        }
      },
      handleBtnClick (mode) {
        this.changeModalStatus({
          visible: true,
          mode: mode
        })
      }
    },
    computed: {
      ...mapGetters(['website', 'modalStatus', 'user', 'isAuthenticated', 'isAdminRole']),
      // 跟随路由变化
      activeMenu () {
        return '/' + this.$route.path.split('/')[1]
      },
      modalVisible: {
        get () {
          return this.modalStatus.visible
        },
        set (value) {
          this.changeModalStatus({visible: value})
        }
      }
    }
  }
</script>

<style lang="less" scoped>
  .section{
    margin-top: 20px;
    margin-bottom: 10px;
    text-align: center;
  }
</style>