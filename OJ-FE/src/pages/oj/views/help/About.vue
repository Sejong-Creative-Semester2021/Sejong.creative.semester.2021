<template>
  <Panel shadow :padding="10" class="panel">
    <div v-if="listVisible" slot="title">
      {{title}}
    </div>
    <div v-else slot="title" class="detailtitle">
      {{title}}
      <div v-if="!listVisible">
        <span class="detailcreator"> {{$t('m.By')}} {{announcement.created_by.username}}</span>
        <span class="detaildate">{{$date(announcement.create_time).format('YYYY-MM-DD')}}</span>
      </div>
    </div>
    <div slot="extra">
      <Input v-if="listVisible"
             v-model="query.keyword"
             @on-enter="filterByKeyword"
             @on-click="filterByKeyword"
             placeholder="검색"
             icon="ios-search-strong"/>
    </div>
    
    <hr v-if="!listVisible">
    <transition-group name="announcement-animate" mode="in-out">
      <template v-if="listVisible">
        <ul class="announcements-container" key="list">
          <li class="bar">
            <div class="flex-container">
              <div class="id">#</div>
              <div class="title2">제목</div>
              <div class="date">작성일</div>
            </div>
          </li>
          <template v-for="announcement in announcements">
            <li v-if="announcement.important" :key="announcement.title" class="bar2">
            <div class="flex-container">
              <div class="id">중요</div>
              <div class="title"><a class="entry" @click="goAnnouncement(announcement)">
                {{announcement.title}}</a></div>
              <div class="date">{{$date(announcement.create_time).format('YYYY-MM-DD')}}</div>
            </div>
          </li>
          </template>
          <li v-if="!announcements.length">
            <div class="no-announcement" key="no-announcement">
              <p>{{$t('m.No_Announcements')}}</p>
            </div>
          </li>
          <template v-for="announcement in announcements" :loading="btnloading">
            <li v-if="!announcement.important" :key="announcement.title">
            <div class="flex-container">
              <div class="id">{{announcement.id}}</div>
              <div class="title"><a class="entry" @click="goAnnouncement(announcement)">
                {{announcement.title}}</a></div>
              <div class="date">{{$date(announcement.create_time).format('YYYY-MM-DD')}}</div>
            </div>
          </li>
          </template>
        </ul>
        <Pagination v-if="!isContest"
                    key="page"
                    :total="total"
                    :page-size.sync="query.limit" 
                    @on-change="pushRouter" 
                    @on-page-size-change="pushRouter" 
                    :current.sync="query.page" 
                    >
        </Pagination>
      </template>
      <template v-else>
        <div v-katex v-html="announcement.content" key="content" class="content-container markdown-body"></div>

      </template>
      
    </transition-group>
    <hr v-if="!listVisible">
    <Button v-if="!listVisible" type="ghost" icon="ios-undo" @click="goBack">{{$t('m.Back')}}</Button>
  </Panel>
</template>

<script>
  import api from '@oj/api'
  import Pagination from '@oj/components/Pagination'
  import utils from '@/utils/utils'

  export default {
    name: 'Announcement',
    components: {
      Pagination
    },
    data () {
      return {
        limit: 10,
        total: 10,
        btnLoading: false,
        announcements: [],
        announcement: '',
        listVisible: true,
        routeName: '',
        query: {
          keyword: '',
          page: 1,
          limit: 10
        }
      }
    },
    created () {
      // detect browser back button
      // window.addEventListener('popstate', this.popstateEventAction)
    },
    mounted () {
      this.init()
      // browser back button
      // window.onpopstate = function (event) {
      //   console.log('check back')
      //   if (!this.listVisible) {
      //     // event stop and show announcementlist visible
      //     // event.preventDefault()
      //     console.log('not list visible')
      //     this.listVisible = true
      //     this.announcement = ''
      //     this.pushRouter()
      //   }
      // }
      window.onpopstate = event => {
        if (!this.listVisible) {
          this.goBack()
          this.$router.push('/announcement') // redirect to home, for example
        }
      }
    },
    methods: {
      init () {
        this.routeName = this.$route.name
        let query = this.$route.query
        this.query.keyword = query.keyword || ''
        this.query.page = parseInt(query.page) || 1
        if (this.query.page < 1) {
          this.query.page = 1
        }
        this.query.limit = parseInt(query.limit) || 10
        if (this.isContest) {
          this.getContestAnnouncementList()
        } else {
          this.getAnnouncementList()
        }
      },
      getAnnouncementList (page = 1) {
        this.btnLoading = true
        api.getAnnouncementList((this.query.page - 1) * this.query.limit, this.limit, this.query).then(res => {
          this.btnLoading = false
          this.announcements = res.data.data.results
          this.total = res.data.data.total
        }, () => {
          this.btnLoading = false
        })
      },
      pushRouter () {
        this.$router.push({
          name: 'announcement',
          query: utils.filterEmptyValue(this.query)
        })
        this.getAnnouncementList()
      },
      pushDetailRouter (announcement) {
        this.announcement = announcement
        this.$router.push({
          name: 'announcement-details',
          paramas: {announcementID: announcement.id}
        })
      },
      getContestAnnouncementList () {
        this.btnLoading = true
        api.getContestAnnouncementList(this.$route.params.contestID).then(res => {
          this.btnLoading = false
          this.announcements = res.data.data
        }, () => {
          this.btnLoading = false
        })
      },
      goAnnouncement (announcement) {
        this.announcement = announcement
        this.listVisible = false
      },
      goBack () {
        this.listVisible = true
        this.announcement = ''
      },
      filterByKeyword () {
        this.query.page = 1
        this.pushRouter()
      }
      // add detect event methods
      // popstateEventAction () {
      //   console.log('activate2')
      //   // if (!this.listVisible) {
      //   //   this.listVisible = true
      //   //   this.announcement = ''
      //   //   this.getAnnouncementList()
      //   //   this.removePopstateEventAction()
      //   // }
      //   this.removePopstateEventAction()
      // },
      // removePopstateEventAction () {
      //   console.log('activate')
      //   window.removeEventListener('popstate', this.popstateEventAction)
      // }
    },
    computed: {
      title () {
        if (this.listVisible) {
          return this.isContest ? this.$i18n.t('m.Contest_Announcements') : '공지사항'
        } else {
          return this.announcement.title
        }
      },
      isContest () {
        return !!this.$route.params.contestID
      }
    }
  }
</script>

<style scoped lang="less">
  .panel{
    margin-left: 15%;
    margin-right: 15%;
  }
  .ivu-btn-ghost:hover {
    border-color: gray !Important;
    color: gray !Important;
  }
  .detailcreator {
    padding-top: 10px;
    font-size: 15px;
    color: gray;
  }
  .detaildate {
    padding-top: 10px;
    padding-right: 20px;
    padding-left: 20px;
    font-size: 15px;
    color: gray;
  }
  .announcements-container {
    margin-top: -10px;
    margin-bottom: 10px;
    .bar {
        padding-top: 10px;
        padding-bottom: 10px;
        font-size: 15px;
        background-color: rgb(233, 233, 233);
      }
      .bar2 {
        padding-top: 15px;
        padding-bottom: 15px;
        font-size: 16px;
        background-color: rgb(233, 233, 233);
      }
    li {
      padding-top: 15px;
      list-style: none;
      padding-bottom: 15px;
      margin-left: 20px;
      font-size: 16px;
      border-bottom: 1px solid rgba(187, 187, 187, 0.5);
      &:last-child {
        border-bottom: none;
      }
      .flex-container {
        .id{
          flex: none;
          width: 75px;
          text-align: center;
        }
        .title {
          flex: 1 1;
          text-align: left;
          padding-left: 20px;
          a.entry {
            color: #495060;
            &:hover {
              color: #2d8cf0;
              border-bottom: 1px solid #2d8cf0;
            }
          }
        }
        .title2 {
          flex: 1 1;
          text-align: center;
          padding-left: 10px;
        }
        .creator {
          flex: none;
          width: 200px;
          text-align: center;
        }
        .date {
          flex: none;
          width: 200px;
          text-align: center;
        }
      }
    }
  }

  .content-container {
    padding: 20px 20px 20px 20px;
  }

  .no-announcement {
    text-align: center;
    font-size: 16px;
  }changeLocale

  .announcement-animate-enter-active {
    animation: fadeIn 1s;
  }
  
  .detailtitle {
    padding-bottom: 0px !Important;
  }
</style>
