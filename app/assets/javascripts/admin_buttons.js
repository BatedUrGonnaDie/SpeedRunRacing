$(document).on("turbolinks:load", function() {
  attach_admin_buttons();
});

var attach_admin_buttons = function() {
  $(".btn-kick-entrant").each(function() {
    $(this).click(function() {
      App.races.kick_entrant($(this).data("entrant-id"));
    });
  });
}
