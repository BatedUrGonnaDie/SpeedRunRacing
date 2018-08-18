import moment from "moment"

import { ts } from "./time"

$(document).on("turbolinks:load", function() {
  $(".btn-create-race").each(function() {
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
      App.races.abandon_race();
    });
  }

  if ($(".btn-done-race").length) {
    $(".btn-done-race").click(function() {
      App.races.done(moment(ts.now()).toISOString());
    });
  }

  if ($(".btn-rejoin-race").length) {
    $(".btn-rejoin-race").click(function() {
      App.races.rejoin();
    });
  }
});
