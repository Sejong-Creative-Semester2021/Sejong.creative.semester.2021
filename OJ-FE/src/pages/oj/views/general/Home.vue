<template>
  <div class="home">
      <div class = "banner-img">
        <img src="../../../../../static/img/bannerimg2.png" style="width: 100%">
      </div>
      <div class="banner-content">
        <h1 class="font-weight-bold">Seggle</h1>
        <div class="banner-description">
          <span style="font-size: 25px; font-weight: bold; color: gray;">
          세종인을 위한 AI 대회가 시작했어요! <br>
          지금 함께 시작해보실래요?
          </span>
        </div>
        <Button class="btn1" size="large" @click="goAIContest()">시작하기</Button>
      </div>
      <div class="down">
      <button class="btn2" type="button" @click="handledown()"><img src="../../../../../static/img/scroll.png" alt="down" style="width: 30px"></button>
      </div>
      <!-- <b-carousel
          id="carousel-1"
          v-model="slide"
          :interval="3000"
          controls
          indicators
          background="#ababab"
          img-width=1920
          img-height=350
          style="position: relative;"
          @sliding-start="onSlideStart"
          @sliding-end="onSlideEnd"
      >
          Slide with blank fluid image to maintain slide aspect ratio
        <b-carousel-slide img-src='../../../../../static/img/banner1.jpg'>
          <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eros felis, tincidunt
            a tincidunt eget, convallis vel est. Ut pellentesque ut lacus vel interdum.
          </p>
        </b-carousel-slide>

        <b-carousel-slide img-src='../../../../../static/img/banner2.jpg'>
          <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eros felis, tincidunt
            a tincidunt eget, convallis vel est. Ut pellentesque ut lacus vel interdum.
          </p>
        </b-carousel-slide>

        <b-carousel-slide caption="Blank Image 3" img-blank img-alt="Blank image">
          <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eros felis, tincidunt
            a tincidunt eget, convallis vel est. Ut pellentesque ut lacus vel interdum.
          </p>
        </b-carousel-slide>
      </b-carousel> -->
    <AIContestHome class="aicontesthome" id="aicontesthome"></AIContestHome>
  </div>
</template>

<script>
  // import Announcements from './Announcements.vue'
  import AIContestHome from '../aicontest/AIContestHome.vue'
  // import api from '@oj/api'
  // import time from '@/utils/time'
  // import { CONTEST_STATUS } from '@/utils/constants'

  export default {
    name: 'home',
    components: {
      // Announcements,
      AIContestHome
    },
    data () {
      return {
        // contests: [],
        // index: 0,
        // userInput: '',
        // type: false,
        // query: {
        //   keyword: ''
        // },
        // 슬라이드 부분
        slide: 0,
        sliding: null
      }
    },
    // mounted () {
    //   let params = {status: CONTEST_STATUS.NOT_START}
    //   api.getContestList(0, 5, params).then(res => {
    //     this.contests = res.data.data.results
    //   })
    // },
    methods: {
      // Announcements
      // getDuration (startTime, endTime) {
      //   return time.duration(startTime, endTime)
      // },
      // goContest () {
      //   this.$router.push({
      //     name: 'contest-details',
      //     params: {contestID: this.contests[this.index].id}
      //   })
      // },
      // 슬라이드 부분
      onSlideStart (slide) {
        this.sliding = true
      },
      onSlideEnd (slide) {
        this.sliding = false
      },
      handledown () {
        window.location.href = '#aicontesthome'
      },
      goAIContest () {
        this.$router.push('/aicontest_general')
      }
    }
  }
</script>

<style lang="less" scoped>
.home {
    margin-top: -80px !important;
  }
.banner-img {
  position: relative;
}
.banner-content {
  position: relative;
  top: -45rem;
  left: 10%;
  color: black;

  h1 {
    font-size: 5rem !important;
    font-weight: 1000;
  }
  .banner-description{
    margin-top: 10px;
    margin-bottom: 20px;
  }
  .btn1 {
    font-weight: 800;
    border-width: 2px;
    font-size: 25px;
    background: linear-gradient( to right, rgb(48, 33, 184), rgb(119, 67, 214) );
    padding: 1rem 3rem;
    margin-top: 1rem;
    font-size: 1.7rem;
    border-radius: 3rem;
    color: white;
  }
}
.down {
    position: relative;
    top: -20rem;
    left: 60rem;
  }


  // .contest {
  //   &-title {
  //     font-style: italic;
  //     font-size: 21px;
  //   }
  //   &-content {
  //     padding: 0 70px 40px 70px;
  //     &-description {
  //       margin-top: 25px;
  //     }
  //   }
  // }

  // .announcement {
  //   margin-top: 20px;
  //   margin-right: 20px;
  // }
  // .home {
  //   margin-top: -20px;
  // }
  
  .aicontesthome {
    margin-top: -250px;
  }


</style>
