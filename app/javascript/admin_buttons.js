$(document).on("turbolinks:load", function() {
  attach_admin_buttons();
});

const attach_admin_buttons = function() {
  $(".btn-kick-entrant").each(function() {
    $(this).click(function() {
      App.races.kick_entrant($(this).data("entrant-id"));
    });
  });
}

export { attach_admin_buttons }
