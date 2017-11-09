// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on("turbolinks:load", function() {
  $(".btn-create-race").each(function(index) {
    $(this).click(function() {
      App.main.create_race($(this).data("category"));
    });
  });

  if ($(".btn-join-race").length) {
    $(".btn-join-race").click(function() {
      App.races.join_race();
    });
  }

  if ($(".btn-part-race").length) {
    $(".btn-part-race").click(function() {
      App.races.part_race();
    });
  }

  if ($(".btn-ready-race").length) {
    $(".btn-ready-race").click(function() {
      App.races.ready_up();
    });
  }

  if ($(".btn-unready-race").length) {
    $(".btn-unready-race").click(function() {
      App.races.unready();
    });
  }

  if ($(".btn-abandon-race").length) {
    $(".btn-abandon-race").click(function() {
      App.races.part_race();
    });
  }

  if ($(".btn-done-race").length) {
    $(".btn-done-race").click(function() {
      App.races.done();
    });
  }
});
