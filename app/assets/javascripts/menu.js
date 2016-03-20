function toggleMenu() {
  var nav = document.getElementsByTagName("nav")[0];
  nav.classList.toggle("open");

  var overlay = document.getElementsByClassName("overlay")[0];
  overlay.classList.toggle("open");

  var isOpening = overlay.classList.contains("open");

  if (isOpening) {
    overlay.style.zIndex = "1000";
  } else {
    setTimeout(function() {
      overlay.style.zIndex = "0";
    }, 230);
  }
};
