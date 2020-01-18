window.onload = function() {
   $(".checkbox").on("click.bs.dropdown.data-api", event =>
     event.stopPropagation()
   );
};