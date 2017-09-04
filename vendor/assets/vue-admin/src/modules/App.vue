<template>
  <div>
    <draggable class="attachments" v-model="attachments" :options="{group:'people'}" v-on:change="draggableChange">
      <div class="attachment" v-for="attachment in attachments">
        <img :src="attachment.file.thumb.url" class="attachment__item">
        <a class="attachment__delete" type="button" v-on:click.prevent="remove(attachment)">remove</a>
      </div>
    </draggable>

    <dropzone id="file-uploader"
              :url="resourceUrl"
              :maxFileSizeInMB="10"
              :maxNumberOfFiles="20"
              acceptedFileTypes="image/*"
              paramName="product[attachments[extra][file]][]"
              v-on:vdropzone-success="fileUploaded"
              v-on:vdropzone-success-multiple="fileUploaded"
              :useFontAwesome="true"
              :showRemoveLink="false">
      <input type="hidden" name="csrf-token":value="token">
      {{ resourceUri }}
    </dropzone>
  </div>
</template>

<script>
import Dropzone from 'vue2-dropzone'
import Draggable from 'vuedraggable'

export default {
  name: 'file-uploader-app',
  components: {
    Dropzone,
    Draggable
  },
  created: function () {
    this.$http.get().then((r) => {
        this.attachments = r.body
    }, (e) => {
      alert('Attachment files error load')
    })
  },
  data () {
    return {
      attachments: []
    }
  },
  computed: {
    resourceUrl: function() {
      return this.$config.resource
    },
    token: function() {
      return this.$config.token
    }
  },
  methods: {
    fileUploaded: function (file, response) {
      this.attachments = response
    },
    draggableChange: function () {
      this.$http.put('', {sortable: this.attachments.map((r) => r.id)}).then((r) => {
        console.log('Sortable Result', r)
      })
    },
    remove: function (attachment) {
      let resetAttachments = this.attachments;
      this.attachments = this.attachments.filter((a) => a.id != attachment.id)
      this.$http.delete('', {params: {token: attachment.token}}).then((r) => {
      }, (e) => {
        this.attachments = resetAttachments
      })
    }
  }
}
</script>

<style>
  #files-uploader {
    padding: 15px;
  }
  .attachments {
    display: flex;
    flex-direction: initial;
    flex-wrap: wrap;
  }
  .attachment:first-child {
    border: 1px solid #75B300;
  }
  .attachment:first-child::before {
    content: "Default";
    position: absolute;
    text-align: center;
    text-transform: uppercase;
    background: #ddd;
    width: 100%;
    cursor: pointer;
    color: #75B300;
    text-shadow: 0px 1px 0px #fff;
  }
  .attachment {
    position: relative;
    height: 200px;
    width: 200px;
    cursor: move;
    border: 1px solid #ddd;
    margin: 5px;
  }
  .attachment.sortable-chosen {
    box-shadow: 0px 0px 7px orange;
  }
  .attachment:hover .attachment__delete {
    -webkit-transition: opacity 0.3s ease-in-out;
    -moz-transition: opacity 0.3s ease-in-out;
    -ms-transition: opacity 0.3s ease-in-out;
    -o-transition: opacity 0.3s ease-in-out;
    opacity: 1;
  }
  .attachment__delete {
    position: absolute;
    z-index: 2;
    bottom: 0;
    text-align: center;
    text-transform: uppercase;
    background: #ddd;
    width: 100%;
    cursor: pointer;
    color: #eb1919;
    text-shadow: 0px 1px 0px #fff;
    opacity: 0;
  }
  .dropzone {
    position: relative;
    border: 2px dashed #ddd !important;
    margin-top: 15px;
    padding-top: 40px;
  }
  .dropzone.dz-started .dz-message {
    display: block !important;
  }
  .dz-complete {
    display: none !important;
  }
  .dz-message {
    font-size: 2rem;
    position: absolute;
    margin: 0 !important;
    left: 40vw;
    top: 45px;
  }
</style>
