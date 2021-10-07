<template>
  <div class="faq view">
    <Panel :title="$t('m.FAQ')">
      <div class="list">
        <el-table
          v-loading="loading"
          element-loading-text="loading"
          ref="table"
          :data="faqList"
          style="width: 100%">
          <el-table-column
            width="100"
            prop="id"
            label="ID">
          </el-table-column>
          <el-table-column
            prop="question"
            label="Question">
          </el-table-column>
          <el-table-column
            prop="create_time"
            label="CreateTime">
            <template slot-scope="scope">
              {{ scope.row.create_time | localtime }}
            </template>
          </el-table-column>
          <el-table-column
            prop="last_update_time"
            label="LastUpdateTime">
            <template slot-scope="scope">
              {{scope.row.last_update_time | localtime }}
            </template>
          </el-table-column>
          <el-table-column
            prop="created_by.username"
            label="Author">
          </el-table-column>
          <el-table-column
            width="100"
            prop="visible"
            label="Visible">
            <template slot-scope="scope">
              <el-switch v-model="scope.row.visible"
                         active-text=""
                         inactive-text=""
                         @change="handleVisibleSwitch(scope.row)">
              </el-switch>
            </template>
          </el-table-column>
          <el-table-column
            fixed="right"
            label="Option"
            width="200">
            <div slot-scope="scope">
              <icon-btn name="Edit" icon="edit" @click.native="openFAQDialog(scope.row.id)"></icon-btn>
              <icon-btn name="Delete" icon="trash" @click.native="deleteFAQ(scope.row.id)"></icon-btn>
            </div>
          </el-table-column>
        </el-table>
        <div class="panel-options">
          <el-button type="primary" size="small" @click="openFAQDialog(null)" icon="el-icon-plus">Create</el-button>
          <el-pagination
            class="page"
            layout="prev, pager, next"
            @current-change="currentChange"
            :page-size="pageSize"
            :total="total">
          </el-pagination>
        </div>
      </div>
    </Panel>
    <!--对话框-->
    <el-dialog :title="faqDialogTitle" :visible.sync="showEditFAQDialog"
               @open="onOpenEditDialog" :close-on-click-modal="false">
      <el-form label-position="top">

        <el-form-item :label="$t('m.FAQ_Question')" required>
          <el-input
            v-model="faq.question"
            :placeholder="$t('m.FAQ_Question')" class="title-input">
          </el-input>
        </el-form-item>

        <el-form-item :label="$t('m.FAQ_Answer')" required>
          <Simditor v-model="faq.answer"></Simditor>
        </el-form-item>

        <div class="visible-box">
          <span>{{$t('m.FAQ_visible')}}</span>
          <el-switch
            v-model="faq.visible"
            active-text=""
            inactive-text="">
          </el-switch>
        </div>
      </el-form>
      <span slot="footer" class="dialog-footer">
          <cancel @click.native="showEditFAQDialog = false"></cancel>
          <save type="primary" @click.native="submitFAQ"></save>
        </span>
    </el-dialog>
  </div>
</template>

<script>
  import Simditor from '../../components/Simditor.vue'
  import api from '../../api.js'

  export default {
    name: 'FAQ',
    components: {
      Simditor
    },
    data () {
      return {
        // 显示编辑公告对话框
        showEditFAQDialog: false,
        // 公告列表
        faqList: [],
        // 一页显示的公告数
        pageSize: 15,
        // 总公告数
        total: 0,
        // 当前公告id
        currentFAQId: null,
        mode: 'create',
        // 公告 (new | edit) model
        faq: {
          question: '',
          visible: true,
          answer: ''
        },
        // 对话框标题
        faqDialogTitle: 'Edit FAQ',
        // 是否显示loading
        loading: true,
        // 当前页码
        currentPage: 0
      }
    },
    mounted () {
      this.init()
    },
    methods: {
      init () {
        this.getFAQList(1)
      },
      // 切换页码回调
      currentChange (page) {
        this.currentPage = page
        this.getFAQList(page)
      },
      getFAQList (page) {
        this.loading = true
        api.getFAQList((page - 1) * this.pageSize, this.pageSize).then(res => {
          this.loading = false
          this.total = res.data.data.total
          this.faqList = res.data.data.results
        }, res => {
          this.loading = false
        })
      },
      // 打开编辑对话框的回调
      onOpenEditDialog () {
        // todo 优化
        // 暂时解决 文本编辑器显示异常bug
        setTimeout(() => {
          if (document.createEvent) {
            let event = document.createEvent('HTMLEvents')
            event.initEvent('resize', true, true)
            window.dispatchEvent(event)
          } else if (document.createEventObject) {
            window.fireEvent('onresize')
          }
        }, 0)
      },
      // 提交编辑
      // 默认传入MouseEvent
      submitFAQ (data = undefined) {
        let funcName = ''
        if (!data.question) {
          data = {
            id: this.currentFAQId,
            question: this.faq.question,
            answer: this.faq.answer,
            visible: this.faq.visible
          }
        }
        funcName = this.mode === 'edit' ? 'updateFAQ' : 'createFAQ'
        api[funcName](data).then(res => {
          this.showEditFAQDialog = false
          this.init()
        }).catch()
      },
      // 删除公告
      deleteFAQ (faqId) {
        this.$confirm('Are you sure you want to delete this FAQ?', 'Warning', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: 'warning'
        }).then(() => {
          // then 为确定
          this.loading = true
          let funcName = 'deleteFAQ'
          api[funcName](faqId).then(res => {
            this.loading = true
            this.init()
          })
        }).catch(() => {
          // catch 为取消
          this.loading = false
        })
      },
      openFAQDialog (id) {
        this.showEditFAQDialog = true
        if (id !== null) {
          this.currentFAQId = id
          this.faqDialogTitle = 'Edit FAQ'
          this.faqList.find(item => {
            if (item.id === this.currentFAQId) {
              this.faq.question = item.question
              this.faq.visible = item.visible
              this.faq.answer = item.answer
              this.mode = 'edit'
            }
          })
        } else {
          this.faqDialogTitle = 'Create FAQ'
          this.faq.question = ''
          this.faq.visible = true
          this.faq.answer = ''
          this.mode = 'create'
        }
      },
      handleVisibleSwitch (row) {
        this.mode = 'edit'
        this.submitFAQ({
          id: row.id,
          question: row.question,
          answer: row.answer,
          visible: row.visible
        })
      }
    },
    watch: {
      $route () {
        this.init()
      }
    }
  }
</script>

<style lang="less" scoped>
  .title-input {
    margin-bottom: 20px;
  }

  .visible-box {
    margin-top: 10px;
    width: 205px;
    float: left;
  }
</style>
