$(document).on("turbolinks:load", function() {
  if (gon.current_user_id) {
    App.notification = App.cable.subscriptions.create("NotificationChannel", {
      connected: function() {
        console.log("We aliv in notifications");
      },

      disconnected: function() {
        console.log("We ded in notifications");
      },

      received: function(data) {
        switch (data.update) {
          case "race_create_success":
            Turbolinks.visit(data.location);
            break;
          case "race_create_failure":
            console.log("do something about the failure");
            break;
          case "race_entry_success":
            $(".btn-join-race").addClass("hidden").removeClass("show");
            $(".btn-part-race").addClass("show").removeClass("hidden");
            $(".btn-ready-race").prop("disabled", false);
            break;
          case "race_entry_failure":
            alert("Failed To Join Race");
            break;
          case "race_part_success":
            $(".btn-join-race").addClass("show").removeClass("hidden");
            $(".btn-part-race").addClass("hidden").removeClass("show");
            $(".btn-ready-race").addClass("show").removeClass("hidden");
            $(".btn-unready-race").addClass("hidden").removeClass("show");
            $(".btn-ready-race").prop("disabled", true);
            break;
          case "race_entry_ready":
            $(".btn-ready-race").addClass("hidden").removeClass("show");
            $(".btn-unready-race").addClass("show").removeClass("hidden");
            break;
          case "race_entry_unready":
            $(".btn-ready-race").addClass("show").removeClass("hidden");
            $(".btn-unready-race").addClass("hidden").removeClass("show");
            break;
          case "race_done_success":
            $(".btn-done-race").prop("disabled", true);
            $(".btn-rejoin-race").addClass("show").removeClass("hidden");
            $(".btn-abandon-race").addClass("hidden").removeClass("show");
            break;
          case "race_rejoin_success":
            $(".btn-done-race").prop("disabled", false);
            $(".btn-rejoin-race").addClass("hidden").removeClass("show");
            $(".btn-abandon-race").addClass("show").removeClass("hidden");
            break;
          case "race_abandon_success":
            $(".btn-done-race").prop("disabled", true);
            $(".btn-rejoin-race").addClass("show").removeClass("hidden");
            $(".btn-abandon-race").addClass("hidden").removeClass("show");
            break;
          default:
            console.log("Default case reached for notifications");
            console.log(data);
            break;
        }
      }
    });
  }
});
