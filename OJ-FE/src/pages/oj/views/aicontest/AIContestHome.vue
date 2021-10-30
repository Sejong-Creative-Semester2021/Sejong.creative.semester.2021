<template>
  <Row type="flex" :gutter="18" align="center">
    <Col :span=15>
    <Panel shadow>
      <div slot="title"><b>{{$t('진행중인 대회')}}</b></div>
      <b-card-group columns id="problem-group">
        <b-card v-for="problem in problemList"
                        :key="problem.title"
                        img-src="https://picsum.photos/1024/480/?image=10"
                        img-top
                        shadow
                        style="max-width: 18rem;"
                        class="mb-2"
                        id="problem-card">
          <b-card-body class="problem-content">
            <b-card-title class="problem-title" @click="goProblem(problem._id)">{{problem.title}}</b-card-title>
            <b-card-sub-title class="problem-subtitle">{{problem.created_by.username}}</b-card-sub-title>
            <b-card-text class="problem-text">
              <p class="content">{{problem.start_time | localtime}}</p> 
              <p class="content">~ {{problem.end_time | localtime}}</p> 
            </b-card-text>
            <b-button block variant="dark" size="sm" @click="goProblem(problem._id)">JOIN</b-button>
          </b-card-body>
        </b-card>
      </b-card-group>
    </Panel>
    </Col>
  </Row>
</template>

<script>
  import {mapGetters} from 'vuex'
  import api from '@oj/api'
  import utils from '@/utils/utils'
  import { ProblemMixin } from '@oj/components/mixins'
  import Pagination from '@oj/components/Pagination'

  export default {
    name: 'AIContestList',
    mixins: [ProblemMixin],
    components: {
      Pagination
    },
    data () {
      return {
        // tagList: [],
        problemTableColumns: [
          {
            title: '#',
            key: '_id',
            width: 80,
            render: (h, params) => {
              return h('Button', {
                props: {
                  type: 'text',
                  size: 'large'
                },
                on: {
                  click: () => {
                    this.$router.push({name: 'aiproblem-details', params: {problemID: params.row._id}})
                  }
                },
                style: {
                  padding: '2px 0'
                }
              }, params.row._id)
            }
          },
          {
            title: this.$i18n.t('m.Title'),
            width: 400,
            render: (h, params) => {
              return h('Button', {
                props: {
                  type: 'text',
                  size: 'large'
                },
                on: {
                  click: () => {
                    this.$router.push({name: 'aiproblem-details', params: {problemID: params.row._id}})
                  }
                },
                style: {
                  padding: '2px 0',
                  overflowX: 'auto',
                  textAlign: 'left',
                  width: '100%'
                }
              }, params.row.title)
            }
          },
          {
            title: this.$i18n.t('m.Level'),
            render: (h, params) => {
              let t = params.row.difficulty
              let color = 'blue'
              if (t === 'Low') color = 'green'
              else if (t === 'High') color = 'yellow'
              return h('Tag', {
                props: {
                  color: color
                }
              }, this.$i18n.t('m.' + params.row.difficulty))
            }
          },
          {
            title: this.$i18n.t('m.Total'),
            key: 'submission_number'
          },
          {
            title: this.$i18n.t('m.AC_Rate'),
            render: (h, params) => {
              return h('span', this.getACRate(params.row.accepted_number, params.row.submission_number))
            }
          }
        ],
        problemList: [],
        limit: 20,
        total: 0,
        loadings: {
          table: true
          // tag: true
        },
        routeName: '',
        query: {
          keyword: '',
          difficulty: '',
          // tag: '',
          page: 1,
          limit: 10
        }
      }
    },
    mounted () {
      this.init()
    },
    methods: {
      init (simulate = false) {
        this.routeName = this.$route.name
        let query = this.$route.query
        this.query.difficulty = query.difficulty || ''
        this.query.keyword = query.keyword || ''
        // this.query.tag = query.tag || ''
        this.query.page = parseInt(query.page) || 1
        if (this.query.page < 1) {
          this.query.page = 1
        }
        this.query.limit = parseInt(query.limit) || 10
        // if (!simulate) {
        //   this.getTagList()
        // }
        this.getProblemList()
      },
      pushRouter () {
        this.$router.push({
          name: 'aiproblem-list',
          query: utils.filterEmptyValue(this.query)
        })
      },
      // 추가 부분
      goProblem (problemID) {
        this.$router.push({name: 'aiproblem-details', params: {problemID: problemID}})
      },
      getProblemList () {
        let offset = (this.query.page - 1) * this.query.limit
        this.loadings.table = true
        api.getAIProblemList(offset, this.limit, this.query).then(res => {
          this.loadings.table = false
          this.total = res.data.data.total
          this.problemList = res.data.data.results
          if (this.isAuthenticated) {
            this.addStatusColumn(this.problemTableColumns, res.data.data.results)
          }
        }, res => {
          this.loadings.table = false
        })
      },
      // getTagList () {
      //   api.getAIProblemTagList().then(res => {
      //     this.tagList = res.data.data
      //     this.loadings.tag = false
      //   }, res => {
      //     this.loadings.tag = false
      //   })
      // },
      // filterByTag (tagName) {
      //   this.query.tag = tagName
      //   this.query.page = 1
      //   this.pushRouter()
      // },
      filterByDifficulty (difficulty) {
        this.query.difficulty = difficulty
        this.query.page = 1
        this.pushRouter()
      },
      filterByKeyword () {
        this.query.page = 1
        this.pushRouter()
      },
      // handleTagsVisible (value) {
      //   if (value) {
      //     this.problemTableColumns.push(
      //       {
      //         title: this.$i18n.t('m.Tags'),
      //         align: 'center',
      //         render: (h, params) => {
      //           let tags = []
      //           params.row.tags.forEach(tag => {
      //             tags.push(h('Tag', {}, tag))
      //           })
      //           return h('div', {
      //             style: {
      //               margin: '8px 0'
      //             }
      //           }, tags)
      //         }
      //       })
      //   } else {
      //     this.problemTableColumns.splice(this.problemTableColumns.length - 1, 1)
      //   }
      // },
      onReset () {
        this.$router.push({name: 'aiproblem-list'})
      },
      pickone () {
        api.pickone().then(res => {
          this.$success('Good Luck')
          this.$router.push({name: 'aiproblem-details', params: {problemID: res.data.data}})
        })
      }
    },
    computed: {
      ...mapGetters(['isAuthenticated'])
    },
    watch: {
      '$route' (newVal, oldVal) {
        if (newVal !== oldVal) {
          this.init(true)
        }
      },
      'isAuthenticated' (newVal) {
        if (newVal === true) {
          this.init()
        }
      }
    }
  }
</script>

<style scoped lang="less">
  .taglist-title {
    margin-left: -10px;
    margin-bottom: -10px;
  }

  .tag-btn {
    margin-right: 5px;
    margin-bottom: 10px;
  }

  #pick-one {
    margin-top: 10px;
  }
  
  #card-deck{
    display: flex;
  }

  #problem-group{
    padding: 20px;
    margin-left: 60px;
    margin-right: 60px;

    .problem-content{
      margin-top: -25px;
      margin-bottom: -25px;
    }
    .problem-title{
      font-size: 18px;
      font-weight: bold;
    }
    .problem-subtitle{
      font-size: 16px;
    }
    .problem-text{
      font-weight: 600;
      color: #686868;
    }
  }

  
  #list {
    margin-bottom: 10px;
    margin-top: 20px;
    ul {
      margin-top: 20px;
      margin-bottom: 20px;
      list-style-type: none;
      li {
        margin-bottom: 1px;
        p {
          display: inline-block;
        }
        p:first-child {
          width: 50px;
        }
        p:last-child {
          float: right;
        }
      }
    }
  }
</style>

