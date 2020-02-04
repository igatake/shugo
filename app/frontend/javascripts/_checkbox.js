$(document).on('touchend click', "#list_dropdown", function() {
   event.preventDefault();
    $(".open")
        .not(this)
        .removeClass("open")
        .next()
        .slideUp(300);
      $(this)
        .toggleClass("open")
        .next()
        .slideToggle(300);
})