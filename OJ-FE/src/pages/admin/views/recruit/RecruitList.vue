<template>
  <div class="recruit view">
    <Panel :title="$t('m.Recruit_List')">
      <div class="list">
        <el-table
          v-loading="loading"
          element-loading-text="loading"
          ref="table"
          :data="recruitList"
          style="width: 100%">
          <el-table-column
            width="100"
            prop="id"
            label="ID">
          </el-table-column>
          <el-table-column
            prop="C_name"
            label="CompanyName">
          </el-table-column>
          <el-table-column
            prop="title"
            label="Title">
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
              <icon-btn name="Edit" icon="edit" @click.native="openRecruitDialog(scope.row.id)"></icon-btn>
              <icon-btn name="Delete" icon="trash" @click.native="deleteRecruit(scope.row.id)"></icon-btn>
            </div>
          </el-table-column>
        </el-table>
        <div class="panel-options">
          <el-button type="primary" size="small" @click="openRecruitDialog(null)" icon="el-icon-plus">Create</el-button>
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
    <el-dialog :title="recruitDialogTitle" :visible.sync="showEditRecruitDialog"
               @open="onOpenEditDialog" :close-on-click-modal="false">
      <el-form label-position="top">

        <el-form-item :label="$t('m.Recruit_Company_Name')" required>
          <el-input
            v-model="recruit.C_name"
            :placeholder="$t('m.Recruit_Company_Name')" class="title-input">
          </el-input>
        </el-form-item>

        <el-form-item :label="$t('m.Recruit_Title')" required>
          <el-input
            v-model="recruit.title"
            :placeholder="$t('m.Recruit_Title')" class="title-input">
          </el-input>
        </el-form-item>

        <div class="visible-box">
          <span>{{$t('m.Announcement_visible')}}</span>
          <el-switch
            v-model="recruit.visible"
            active-text=""
            inactive-text="">
          </el-switch>
        </div>
      </el-form>
      <span slot="footer" class="dialog-footer">
          <cancel @click.native="showEditRecruitDialog = false"></cancel>
          <save type="primary" @click.native="submitRecruit"></save>
        </span>
    </el-dialog>
  </div>
</template>

<script>
  import Simditor from '../../components/Simditor.vue'
  import api from '../../api.js'

  export default {
    name: 'Recruit',
    components: {
      Simditor
    },
    data () {
      return {
        // 显示编辑公告对话框
        showEditRecruitDialog: false,
        // 公告列表
        recruitList: [],
        // 一页显示的公告数
        pageSize: 15,
        // 总公告数
        total: 0,
        // 当前公告id
        currentRecruitId: null,
        mode: 'create',
        // 公告 (new | edit) model
        recruit: {
          title: '',
          visible: true,
          C_name: ''
        },
        // 对话框标题
        recruitDialogTitle: 'Edit Recruit',
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
        this.getRecruitList(1)
      },
      // 切换页码回调
      currentChange (page) {
        this.currentPage = page
        this.getRecruitList(page)
      },
      getRecruitList (page) {
        this.loading = true
        api.getRecruitList((page - 1) * this.pageSize, this.pageSize).then(res => {
          this.loading = false
          this.total = res.data.data.total
          this.recruitList = res.data.data.results
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
      submitRecruit (data = undefined) {
        let funcName = ''
        if (!data.title) {
          data = {
            id: this.currentRecruitId,
            title: this.recruit.title,
            C_name: this.recruit.C_name,
            content: this.recruit.content,
            visible: this.recruit.visible
          }
        }
        funcName = this.mode === 'edit' ? 'updateRecruit' : 'createRecruit'
        api[funcName](data).then(res => {
          this.showEditRecruitDialog = false
          this.init()
        }).catch()
      },
      // 删除公告
      deleteRecruit (recruitId) {
        this.$confirm('Are you sure you want to delete this recruitment', 'Warning', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: 'warning'
        }).then(() => {
          // then 为确定
          this.loading = true
          let funcName = 'deleteRecruit'
          api[funcName](recruitId).then(res => {
            this.loading = true
            this.init()
          })
        }).catch(() => {
          // catch 为取消
          this.loading = false
        })
      },
      openRecruitDialog (id) {
        this.showEditRecruitDialog = true
        if (id !== null) {
          this.currentRecruitId = id
          this.recruitDialogTitle = 'Edit Recruit'
          this.recruitList.find(item => {
            if (item.id === this.currentRecruitId) {
              this.recruit.title = item.title
              this.recruit.visible = item.visible
              this.recruit.C_name = item.C_name
              this.mode = 'edit'
            }
          })
        } else {
          this.recruitDialogTitle = 'Create Recruit'
          this.recruit.title = ''
          this.recruit.visible = true
          this.recruit.C_name = ''
          this.mode = 'create'
        }
      },
      handleVisibleSwitch (row) {
        this.mode = 'edit'
        this.submitRecruit({
          id: row.id,
          title: row.title,
          C_name: row.C_name,
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
