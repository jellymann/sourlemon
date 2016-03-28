window.twttr = function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0],
    p = /^http:/.test(d.location) ? 'http' : 'https';
  if (!d.getElementById(id)) {
    js = d.createElement(s);
    js.id = id;
    js.src = p + '://platform.twitter.com/widgets.js';
    fjs.parentNode.insertBefore(js, fjs);
  }
}(document, 'script', 'twitter-wjs');

document.addEventListener('turbolinks:load', function() {
  if (!window.twttr) return;
  var title = document.getElementsByTagName('h1')[0].innerText;
  var button, buttons = document.getElementsByClassName('twitter-share-button');
  for (var i = 0; i < buttons; i++) {
    button = buttons[i];
    if (!button.dataset['data-url']) button[i].setAttribute('data-url', document.location.href);
    if (!button.dataset['data-text']) button[i].setAttribute('data-text', title);
  }
  window.twttr.widgets.load();
});
