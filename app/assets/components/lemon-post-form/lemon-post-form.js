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
    var tag, tags = [], tag_input, tag_inputs = this.querySelectorAll('.tag_field');
    for (var i = 0; i < tag_inputs.length; i++) {
      tag_input = tag_inputs[i];
      tag = tag_input.value;
      if (tags.indexOf(tag) === -1) tags.push(tag);
      tag_input.remove();
    }
    this.$.lemon_post_tags.tags = tags;
  },

  submitForm: function() {
    this._post_title.value = this.$.lemon_post_title.value;
    this._post_body.value = this.$.lemon_post_body.value;

    var tags = this.$.lemon_post_tags.tags;
    for (var i = 0; i < tags.length; i++) {
      this.form.querySelector('.hidden-form').appendChild(this._createInputTag(tags[i]));
    }

    this.form.submit();
  },

  _createInputTag: function(tag) {
    var input = document.createElement('input');
    input.name = "post[tags][]";
    input.value = tag;
    return input;
  },

  _computeElevation: function(smallScreen) {
    return smallScreen ? 0 : 3;
  }
});
