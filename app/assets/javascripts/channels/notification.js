$(document).on("turbolinks:load", function() {
  if (gon.current_user_id && App.notification === undefined) {
    App.notification = App.cable.subscriptions.create("NotificationChannel", {
      connected: function() {
        console.log("We aliv in notifications");
      },

      disconnected: function() {
        console.log("We ded in notifications");
      },

      received: function(data) {
        switch (data.status) {
          case "race_create_success":
            Turbolinks.visit(data.location);
            break;
          case "race_create_failure":
            push_alert("Race couldn't be created!<br>" + data.reason, "danger");
            break;

          case "race_join_success":
            $(".btn-join-race").addClass("hidden").removeClass("show");
            $(".btn-part-race").addClass("show").removeClass("hidden");
            $(".btn-ready-race").prop("disabled", false);
            break;
          case "race_join_failure":
            push_alert("Race couldn't be joined!<br>" + data.reason, "danger");
            break;

          case "race_part_success":
            $(".btn-join-race").addClass("show").removeClass("hidden");
            $(".btn-part-race").addClass("hidden").removeClass("show");
            $(".btn-ready-race").addClass("show").removeClass("hidden");
            $(".btn-unready-race").addClass("hidden").removeClass("show");
            $(".btn-ready-race").prop("disabled", true);
            break;
          case "race_part_failure":
            push_alert("Race couldn't be parted!<br>" + data.reason, "danger");
            break;

          case "race_ready_success":
            $(".btn-ready-race").addClass("hidden").removeClass("show");
            $(".btn-unready-race").addClass("show").removeClass("hidden");
            break;
          case "race_ready_failure":
            push_alert("We couldn't record your ready!<br>" + data.reason, "danger");
            break;

          case "race_unready_success":
            $(".btn-ready-race").addClass("show").removeClass("hidden");
            $(".btn-unready-race").addClass("hidden").removeClass("show");
            break;
          case "race_unready_failure":
            push_alert("We couldn't record your unready!<br>" + data.reason, "danger");
            break;

          case "race_done_success":
            $(".btn-done-race").prop("disabled", true);
            $(".btn-rejoin-race").addClass("show").removeClass("hidden");
            $(".btn-abandon-race").addClass("hidden").removeClass("show");
            break;
          case "race_done_failure":
            push_alert("We couldn't record your time!<br>" + data.reason, "danger");
            break;

          case "race_rejoin_success":
            $(".btn-done-race").prop("disabled", false);
            $(".btn-rejoin-race").addClass("hidden").removeClass("show");
            $(".btn-abandon-race").addClass("show").removeClass("hidden");
            break;
          case "race_rejoin_failure":
            push_alert("Race couldn't be rejoined!<br>" + data.reason, "danger");
            break;

          case "race_abandon_success":
            $(".btn-done-race").prop("disabled", true);
            $(".btn-rejoin-race").addClass("show").removeClass("hidden");
            $(".btn-abandon-race").addClass("hidden").removeClass("show");
            break;
          case "race_abandon_failure":
            push_alert("Race couldn't be abandoned!<br>" + data.reason, "danger");
            break;

          case "race_kick_inactive":
            push_alert("You have been kicked by the race creator for inactivity.", "danger")
            break;
          case "race_kick_failure":
            push_alert("Could not kick user!<br>" + data.reason, "danger");
            break;

          case "chat_message_create_failure":
            push_alert("Error creating message!<br>" + data.reason, "danger");
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
