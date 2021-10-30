<template>
  <div class="home">
    <Row type="flex" align="center">
      <b-carousel
          id="carousel-1"
          v-model="slide"
          :interval="3000"
          controls
          indicators
          background="#ababab"
          img-width="1920"
          img-height="320"
          style="position: relative"
          @sliding-start="onSlideStart"
          @sliding-end="onSlideEnd"
      >
          <!-- Slide with blank fluid image to maintain slide aspect ratio -->
        <b-carousel-slide caption="Blank Image 1" img-blank img-alt="Blank image">
          <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eros felis, tincidunt
            a tincidunt eget, convallis vel est. Ut pellentesque ut lacus vel interdum.
          </p>
        </b-carousel-slide>

        <b-carousel-slide caption="Blank Image 2" img-blank img-alt="Blank image">
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
      </b-carousel>
    </Row>
    <AIContestHome class="aicontesthome"></AIContestHome>
  </div>
</template>

<script>
  // import Announcements from './Announcements.vue'
  import AIContestHome from '../aicontest/AIContestHome.vue'
  import api from '@oj/api'
  import time from '@/utils/time'
  import { CONTEST_STATUS } from '@/utils/constants'

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
      }
    }
  }
</script>

<style lang="less" scoped>
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
  .home {
    margin-top: -20px;
  }
  
  .aicontesthome {
    margin-top: 10px;
  }


</style>
