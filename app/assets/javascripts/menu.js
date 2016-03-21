function menuIsOpen() {
  return document.getElementById("main-menu").classList.contains("open");
}

function toggleMenu(cb) {
  if (menuIsOpen()) {
    closeMenu(cb);
  } else {
    openMenu(cb);
  }
};

function openMenu(cb) {
  var nav = document.getElementById("main-menu");
  nav.classList.add("open");
  var overlay = document.getElementById("overlay");
  overlay.classList.add("open");

  overlay.style.zIndex = "200";
  overlay.onclick = toggleMenu;
  if (typeof cb === "function") cb();
}

function closeMenu(cb) {
  var nav = document.getElementById("main-menu");
  nav.classList.remove("open");
  var overlay = document.getElementById("overlay");
  overlay.classList.remove("open");

  overlay.onclick = null;
  setTimeout(function() {
    overlay.style.zIndex = "0";
    if (typeof cb === "function") cb();
  }, 100);
}

document.addEventListener('turbolinks:before-visit', function(event) {
  document.getElementById('loading-overlay').style.display = "block";
  document.getElementById('loading-overlay').style.opacity = "1";
  document.getElementById('content').style.opacity = "0";
  if (menuIsOpen()) closeMenu();
});

document.addEventListener('turbolinks:visit', function(event) {
  if (menuIsOpen()) closeMenu();
});

document.addEventListener('turbolinks:render', function(event) {
  document.getElementById('loading-overlay').style.opacity = "0";
  setTimeout(function() {
    document.getElementById('loading-overlay').style.display = "none";
  }, 100);
  document.getElementById('content').style.opacity = "1";
});
