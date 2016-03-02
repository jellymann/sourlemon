$(function() {
  $('.post--short').mouseenter(function(e) {
    this.elevation = 3;
  });

  $('.post--short').mouseleave(function(e) {
    this.elevation = 1;
  });
});
