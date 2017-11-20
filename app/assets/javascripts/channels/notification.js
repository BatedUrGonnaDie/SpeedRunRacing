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
          case "race_entry_removed":
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
          case "race_started":
            $(".btn-join-race").addClass("hidden").removeClass("show");
            $(".btn-part-race").addClass("hidden").removeClass("show");
            $(".btn-ready-race").addClass("hidden").removeClass("show");
            if ($(".btn-unready-race").hasClass("show")) {
              $(".btn-abandon-race").addClass("show").removeClass("hidden");
              $(".btn-done-race").addClass("show").removeClass("hidden");
            }
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
