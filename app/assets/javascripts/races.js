// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on("turbolinks:load", function() {
    $(".table > tbody > tr").click(function() {
        Turbolinks.visit($(this).data("href"));
    });
});
