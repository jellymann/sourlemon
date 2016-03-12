Polymer({
  is: "lemon-post",
  properties: {
    title: String,
    url: String,
    summary: {
      type: Boolean,
      value: false
    }
  },

  listeners: {
    'tap': 'onTap'
  },

  ready: function() {
    this.$.titleTag.href = this.url;
    if (this.summary) {
      this.$.postMaterial.animated = true;
      this.$.postMaterial.elevation = 1;
    }
  },

  onTap: function() {
    if (!this.summary) return;
    window.location.href = this.url;
  },

  onMouseover: function() {
    if (!this.summary) return;
    this.$.postMaterial.elevation = 3;
  },

  onMouseout: function() {
    if (!this.summary) return;
    this.$.postMaterial.elevation = 1;
  }
});
