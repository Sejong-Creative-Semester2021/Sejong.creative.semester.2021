<template>
  <div id="header" class="scroll-y">
    <div v-scroll:#header="onScroll">
      <Menu theme="light" mode="horizontal" @on-select="handleRoute" :active-name="activeMenu" class="oj-menu">  
        <div class="logo"><span>{{'OJ'}}</span></div>
        <div class="menulist">
          <Menu-item name="/" class='list'>
            {{$t('m.Home')}}
          </Menu-item>
          <Menu-item name="/aicontest_general" class='list'>
            {{'AI 대회'}}
          </Menu-item>
          <Menu-item name="/announcement" class='list'>
            {{'공지사항'}}
          </Menu-item>
          <Menu-item name="/FAQ" style="margin-right: 30px" class='list'>
            {{$t('m.FAQ')}}
          </Menu-item>
        <template v-if="!isAuthenticated">
          <div class="btn-menu">
            <Button class="login-btn"
                    type="ghost"
                    ref="loginBtn"
                    shape="circle"
                    @click="handleBtnClick('login')"
                    style="color: #ffffff">로그인
            </Button>
            <Button v-if="website.allow_register"
                    class="register-btn"
                    shape="circle"
                    @click="handleBtnClick('register')"
                    style="margin-left: 15px; border-color: rgb(217, 95, 95); background-color: rgb(217, 95, 95); color: #ffffff">회원가입
            </Button>
          </div>
        </template>
        <template v-else>
          <Dropdown class="drop-menu" @on-click="handleRoute" placement="bottom" trigger="click">
            <Button type="text" class="drop-menu-title">{{ user.username }}
              <Icon type="arrow-down-b"></Icon>
            </Button>
            <Dropdown-menu slot="list">
              <Dropdown-item name="/user-home">마이페이지</Dropdown-item>
              <Dropdown-item name="/setting/profile">{{$t('m.Settings')}}</Dropdown-item>
              <Dropdown-item v-if="isAdminRole" name="/admin">관리</Dropdown-item>
              <Dropdown-item divided name="/logout">로그아웃</Dropdown-item>
            </Dropdown-menu>
          </Dropdown>
        </template>
        </div>
      </Menu>
      <Modal v-model="modalVisible" :width="400">
        <div slot="header" class="modal-title">{{$t('m.Welcome_to')}} {{website.website_name_shortcut}}</div>
        <component :is="modalStatus.mode" v-if="modalVisible"></component>
        <div slot="footer" style="display: none"></div>
      </Modal>
    </div>
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
    data () {
      return {
        offsetTop: 0
      }
    },
    mounted () {
      this.getProfile()
      // $(function() {
      //   var lastScroll = 0
      //   $(window).scroll(function(event) {
      //     var scroll = $(this).scrollTop()
      //     if (scroll > 0) {
      //     //이벤트를 적용시킬 스크롤 높이
      //         $("#header").addClass("add")
      //     }
      //     else {
      //         $("#header").removeClass("add")
      //     }
      //     lastScroll = scroll
      //   })
      // })
      // this.onscroll()
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
      },
      onScroll (e) {
        this.offsetTop = e.target.scrollTop
        console.log(this.offsetTop)
        if (this.offsetTop !== 0) {
          console.log('add')
          document.getElementById('header').className = 'add'
        } else {
          console.log('remove')
          document.getElementById('header').classList.remove('add')
        }
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
  .ivu-menu-horizontal {
    height: 0px;
  }
  .add {
    background-color: white !important;
  }
  #header {
    min-width: 300px;
    position: fixed;
    top: 0;
    left: 0;
    height: auto;
    width: 100%;
    z-index: 1000;
    background-color: white;
  
    li:hover {
      color: white !Important;
      border-bottom-width: 0px !Important;
    }
    .ivu-menu-light.ivu-menu-horizontal .ivu-menu-item:hover {
      border-bottom: 0px;
    }

    .ivu-menu-item-selected {
      color: white !Important;
      border-bottom-width: 0px !Important;
    }

    .oj-menu {
      width: 70%;
      margin-left: 15%;
      background-color: transparent;
    }

    .menulist {
      float: right;
    }

    .sublist {
      color: #000000;
    }
    
    .list {
      color:#cac8c8;
      font-weight: bold;
      font-size: large;
      display:table;
    }

    .logo {
      margin-left: 2%;
      margin-right: 2%;
      font-size: 20px;
      float: left;
      line-height: 60px;
      color: #ffffff;
    }

    .drop-menu {
      color: #ffcc00;
      float: right;
      margin-right: 30px;
      position: absolute;
      right: 10px;
      &-title {
        font-size: 18px;
      }
    }
    .dropdown-menu{
       color: #000000;
    }
    .btn-menu {
      color: #ffcc00;
      font-size: 16px;
      float: right;
      margin-right: 10px;
    }
    .login-btn {
      font-weight: bold;
      border-width: 2px;
      padding-top: 6px;
      padding-bottom: 6px;
      font-size: 14px;
    }
    .register-btn {
      font-weight: bold;
      border-width: 2px;
      padding-top: 6px;
      padding-bottom: 6px;
      font-size: 14px;
    }
    .ivu-btn-ghost:hover {
      background-color: #e3a8a8;
      border-color: #e3a8a8;
    }
  }

  .modal {
    &-title {
      font-size: 18px;
      font-weight: 600;
    }
  }
</style>
