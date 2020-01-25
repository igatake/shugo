window.onresize = function() {
  if (menuSidebar.style.display == "block") {
    if (window.matchMedia("(max-width: 767px)").matches) {
      mapWindow.style.height = "50%";
      mapWindow.style.width = "100%";
    } else {
      mapWindow.style.width = "70%";
      mapWindow.style.height = "100%";
    }
  }
};
