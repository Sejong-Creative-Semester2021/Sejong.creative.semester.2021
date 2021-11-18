<template>
  <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container">

          <div class="modal-header">
            <slot name="header">
              <strong>비밀번호를 입력하세요</strong>
              <b-button-close @click="$emit('close')"></b-button-close>
            </slot>
          </div>

          <div class="modal-body">
            <slot name="body">
              <Input type="password" v-model="passwordFromUser" placeholder="비밀번호를 입력하세요" size="large">
              <Icon type="ios-locked-outline" slot="prepend"></Icon>
              </Input>
            </slot>
          </div>
          <div class="modal-footer">
            <slot name="footer">
              <b-button
                pill variant="outline-primary"
                class="modal-default-button"
                @click="goProblem (problemID)">
                <b>입장하기</b>
              </b-button>
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
  export default {
    props: ['problemID', 'problemPassword'],
    data () {
      return {
        passwordFromUser: ''
      }
    },
    methods: {
      goProblem (problemID) {
        if (this.passwordFromUser === this.problemPassword) {
          this.$router.push({name: 'aiproblem-class-details', params: {problemID: problemID}})
        }
      }
    }
  }
</script>

<style>
.modal-mask {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, .5);
  display: table;
  transition: opacity .3s ease;
}

.modal-wrapper {
  display: table-cell;
  vertical-align: middle;
}

.modal-container {
  width: 500px;
  margin: 0px auto;
  padding: 20px 30px;
  background-color: #fff;
  border-radius: 20px 20px 20px 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, .33);
  transition: all .3s ease;
  font-family: Helvetica, Arial, sans-serif;
}

.modal-header {
  margin-top: 0;
  color: #3399ff;
  font-size: 18px;
  font-weight: bold;
}

.modal-body {
  margin: 20px 0;
}

.modal-default-button {
  float: right;
}

/*
 * The following styles are auto-applied to elements with
 * transition="modal" when their visibility is toggled
 * by Vue.js.
 *
 * You can easily play with the modal transition by editing
 * these styles.
 */

.modal-enter {
  opacity: 0;
}

.modal-leave-active {
  opacity: 0;
}

.modal-enter .modal-container,
.modal-leave-active .modal-container {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}
</style>