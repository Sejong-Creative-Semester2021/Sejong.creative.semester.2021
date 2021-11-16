<template>
  <v-app>
    <NavBar class="nav-bar"></NavBar>
    <div class="content-app" id="content">
      <div class="content-scroll" v-scroll:#content="onScroll">
        <transition name="fadeInUp" mode="out-in">
          <router-view></router-view>
        </transition>
        <div class="footer">
          <p v-html="website.website_footer"></p>
          <p>Powered by <a href="https://github.com/QingdaoU/OnlineJudge">OnlineJudge</a>
            <!-- <span v-if="version">&nbsp; Version: {{ version }}</span> -->
          </p>
        </div>
      </div>
    </div>
    <BackTop></BackTop>
  </v-app>
</template>

<script>
  import { mapActions, mapState } from 'vuex'
  import NavBar from '@oj/components/NavBar.vue'

  export default {
    name: 'app',
    components: {
      NavBar
    },
    data () {
      return {
        offsetTop: 0
        // version: process.env.VERSION
      }
    },
    created () {
      try {
        document.body.removeChild(document.getElementById('app-loader'))
      } catch (e) {
      }
    },
    mounted () {
      this.getWebsiteConfig()
    },
    methods: {
      ...mapActions(['getWebsiteConfig', 'changeDomTitle']),
      onScroll (e) {
        this.offsetTop = e.target.scrollTop
        console.log(this.offsetTop)
        if (this.offsetTop !== 0) {
          console.log('add')
          document.getElementsByClassName('nav-bar').className = 'nav-bar-add'
        } else {
          console.log('remove')
          document.getElementsByClassName('nav-bar-add').className = 'nav-bar'
        }
      }
    },
    computed: {
      ...mapState(['website'])
    },
    watch: {
      'website' () {
        this.changeDomTitle()
      },
      '$route' () {
        this.changeDomTitle()
      }
    }
  }
</script>

<style lang="less">

  * {
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
  }

  a {
    text-decoration: none;
    background-color: transparent;
    &:active, &:hover {
      outline-width: 0;
    }
  }
  .content-app {
    min-height: 100%;
  }

  .content-scroll{
    max-height: 100%;
  }

@media screen and (max-width: 1200px) {
  .content-app {
    padding: 0;
  }
}

@media screen and (min-width: 1200px) {
  .content-app {
    background-color: transparent;
    padding: 0;
  }
}

  .footer {
    margin-top: 20px;
    margin-bottom: 10px;
    text-align: center;
    font-size: small;
  }

  .fadeInUp-enter-active {
    animation: fadeInUp .8s;
  }

</style>
