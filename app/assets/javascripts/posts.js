$(function() {
  $('.post--short').mouseenter(function(e) {
    this.elevation = 3;
  });

  $('.post--short').mouseleave(function(e) {
    this.elevation = 1;
  });

  $('.post--short').click(function(e) {
    window.location.href = $(this).data('slug');
  });

  setTimeout(function() {
    var toasts = document.getElementsByTagName('paper-toast');
    for (var i = 0; i < toasts.length; i++) { toasts[i].show(); }
  }, 100);
});
