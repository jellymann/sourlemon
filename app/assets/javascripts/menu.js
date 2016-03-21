function toggleMenu() {
  var nav = document.getElementById("main-menu");
  nav.classList.toggle("open");

  var overlay = document.getElementById("overlay");
  overlay.classList.toggle("open");

  var isOpening = overlay.classList.contains("open");

  if (isOpening) {
    overlay.style.zIndex = "200";
    overlay.onclick = toggleMenu;
  } else {
    overlay.onclick = null;
    setTimeout(function() {
      overlay.style.zIndex = "0";
    }, 230);
  }
};
