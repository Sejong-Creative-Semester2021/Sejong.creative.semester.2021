<template>
  <Row type="flex" :gutter="18" align="center">
    <Col :span=15>
    <Panel shadow>
      <div slot="title"><b>{{$t('진행중인 대회')}}</b></div>
      <b-card-group columns id="problem-group">
        <div v-for="problem in problemList" :key="problem.title" >
          <b-card :img-src='`https://picsum.photos/1024/480/?image=${problem.id}`'
                  img-top
                  style="min-width: 10rem; max-width: 18rem; border-radius: 20px; box-shadow: 0 4px 5px rgba(0, 0, 0, 0.1);"
                  class="mb-1"
                  id="problem-card"
                  @click="goProblem(problem._id)">
            <b-card-body class="problem-content">
              <b-card-title class="problem-title" @click="goProblem(problem._id)">{{problem.title}}</b-card-title>
              <b-card-sub-title class="problem-subtitle">{{problem.created_by.username}}</b-card-sub-title>
              <b-card-text class="problem-text">
                <p class="content">START : {{$date(problem.start_time).format('YYYY-MM-DD')}}</p> 
                <p class="content">  END : {{$date(problem.end_time).format('YYYY-MM-DD')}}</p> 
              </b-card-text>
              <!-- <b-button block variant="dark" size="sm" @click="goProblem(problem._id)">JOIN</b-button> -->
            </b-card-body>
          </b-card>
        </div>
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
        imgpath: '',
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
        generalProblemList: [],
        limit: 20,
        total: 0,
        loadings: {
          table: true
        },
        routeName: '',
        query: {
          keyword: '',
          difficulty: '',
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
        this.query.page = parseInt(query.page) || 1
        if (this.query.page < 1) {
          this.query.page = 1
        }
        this.query.limit = parseInt(query.limit) || 10
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
        api.getGeneralAIProblemList(offset, this.limit, this.query).then(res => {
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
      filterByDifficulty (difficulty) {
        this.query.difficulty = difficulty
        this.query.page = 1
        this.pushRouter()
      },
      filterByKeyword () {
        this.query.page = 1
        this.pushRouter()
      },
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

    img {
      border-radius: 20px 20px 0 0;
    }

    .problem-content{
      margin-top: -25px;
      margin-bottom: -25px;
    }
    .problem-title{
      font-size: 17px;
      font-weight: bold;
    }
    .problem-subtitle{
      font-size: 16px;
    }
    .problem-text{
      margin-top: 10px;
      font-weight: 600;
      color: #686868;
    }
  }

</style>

