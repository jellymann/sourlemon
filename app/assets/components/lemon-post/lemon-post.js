Polymer({
  is: "lemon-post",
  properties: {
    post: String,
    summary: {
      type: Boolean,
      value: false
    }
  },

  listeners: {
    'postMaterial.mouseover': 'onMouseover',
    'postMaterial.mouseout': 'onMouseout'
  },

  ready: function() {
    this.post = JSON.parse(this.post);
    if (this.summary) {
      this.$.postMaterial.animated = true;
      this.$.postMaterial.elevation = 1;
    }
  },

  onMouseover: function() {
    if (!this.summary || this.smallScreen) return;
    this.$.postMaterial.elevation = 3;
  },

  onMouseout: function() {
    if (!this.summary || this.smallScreen) return;
    this.$.postMaterial.elevation = 1;
  },

  _computeElevation: function(smallScreen) {
    if (smallScreen) {
      return 0;
    } else if (this.summary) {
      return 1;
    } else {
      return 3;
    }
  }
});
