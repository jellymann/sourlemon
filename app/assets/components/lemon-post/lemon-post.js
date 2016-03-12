Polymer({
  is: "lemon-post",
  properties: {
    title: String,
    body: String,
    url: String,
    summary: {
      type: Boolean,
      value: false
    }
  },

  ready: function() {
    this.$.titleTag.href = this.url;
  }
});
