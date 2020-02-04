$(function() {
  $(".accordion-title").click(function() {
    $(".open")
      .not(this)
      .removeClass("open")
      .prev()
      .slideUp(300);
    $(this)
      .toggleClass("open")
      .prev()
      .slideToggle(300);
  });
});