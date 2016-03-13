Polymer({
  is: "lemon-post-form",

  listeners: {
    'lemon_submit_post.click': 'submitForm'
  },

  ready: function() {
    this.form = this.querySelector('form');
    this._post_title = this.form.querySelector('#post_title');
    this._post_body = this.form.querySelector('#post_body');

    this.$.lemon_post_title.value = this._post_title.value;
    this.$.lemon_post_body.value = this._post_body.value;
  },

  submitForm: function() {
    this._post_title.value = this.$.lemon_post_title.value;
    this._post_body.value = this.$.lemon_post_body.value;
    this.form.submit();
  },

  _computeElevation: function(smallScreen) {
    return smallScreen ? 0 : 3;
  }
});
