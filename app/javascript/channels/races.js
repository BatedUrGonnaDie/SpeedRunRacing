import { push_alert } from "../alerts"
import { attach_admin_buttons } from "../admin_buttons"
import { Countdown } from "../countdown"

$(document).on("turbolinks:load", function() {
  if (gon.race && gon.race.finish_time === null) {
    App.races = App.cable.subscriptions.create({channel: "RacesChannel", race_id: gon.race.id}, {
      connected: function() {
        // Called when the subscription is ready for use on the server
        gon.race_channel_connected = true;
        const name = `race_${gon.race.id}_time`;
        const time = localStorage.getItem(name);
        if (time !== null) {
          localStorage.removeItem(name);
          this.done(time);
        }
      },

      disconnected: function() {
        // Called when the subscription has been terminated by the server
        gon.race_channel_connected = false;
      },

      received: function(data) {
        // Called when there's incoming data on the websocket for this channel
        switch (data.update) {
          case "race_started":
            $("header").after("<div id='race-start-dim'></div>");
            $("header").after("<div id='race-start-text'>RACE STARTING SOON</div>");
            const counter = new Countdown({
              start_time: data.race.start_time,
              on_update_status: function(sec, options) {
                if (sec > 10)
                  return;
                $("#race-start-text").html("RACE STARTING IN: " + sec + " Seconds");
              },
              on_end_status: start_race,
              end_args: {data: data}
            });
            counter.start();
            $("#race-duration").data("start-time", data.race.start_time);
            $("#creator-controls").remove();
            break;
          case "race_entrants_updated":
            break;
          case "race_entrants_html":
            $("#entrants-list").html(data.entrants_html)
            $("#creator-controls").html(data.admin_html)
            attach_admin_buttons();
            $(document).trigger("race:updated");
            break;
          case "race_completed":
            end_race(data.race.status_text);
            break;
          case "race_deletion_queued":
            let msg = "<div id='race-delete-alert' class='alert alert-danger' role='alert'>";
            msg += "This race will be deleted in 15 minutes due to inactivity or all entrants forfeiting."
            msg += "Chat will also be locked at that time.";
            msg += "</div>";
            $("noscript").before(msg)
            end_race(data.race.status_text);
            break;
          case "race_deleted":
            Turbolinks.visit("/", { action: "replace" })
            break;
          default:
            console.log("Default case shit yo");
            console.log(data);
            break;
        }
      },

      join_race: function() {
        this.perform("join_race");
      },

      part_race: function() {
        this.perform("part_race");
      },

      abandon_race: function() {
        this.perform("abandon_race");
      },

      ready_up: function() {
        this.perform("ready");
      },

      unready: function() {
        this.perform("unready");
      },

      kick_entrant: function(entrant_id) {
        this.perform("kick_entrant", {entrant_id: entrant_id});
      },

      done: function(server_time) {
        if (gon.race_channel_connected) {
          this.perform("done", {server_time: server_time});
        } else {
          localStorage.setItem("race_" + gon.race.id + "_time", server_time);
          push_alert("Your finish time has been saved and will be sent as soon as you reconnect.", "success");
        }
      },

      rejoin: function() {
        this.perform("rejoin_race");
      }
    });
  }
});

$(document).on("page:before-change turbolinks:before-visit", function() {
  if (App.races !== undefined) {
    App.races.unready();
    App.cable.subscriptions.remove(App.races);
    delete App.races;
  }
});

const start_race = function(args) {
  const race = args.data.race;
  $(".btn-join-race").addClass("hidden").removeClass("show");
  $(".btn-part-race").addClass("hidden").removeClass("show");
  $(".btn-ready-race").addClass("hidden").removeClass("show");
  if ($(".btn-unready-race").hasClass("show")) {
    $(".btn-abandon-race").addClass("show").removeClass("hidden");
    $(".btn-done-race").addClass("show").removeClass("hidden");
  }
  $(".btn-unready-race").addClass("hidden").removeClass("show");
  $("#race-status-text").addClass("text-warning").removeClass("text-success").html(race.status_text);
  $("#race-duration").addClass("updating-time");
  $("#race-start-text").html("GO GO GO!");
  setTimeout(function() {
    $("#race-start-dim").remove();
    $("#race-start-text").remove();
  }, 10000);
};

const end_race = function(status_text) {
  $(".btn-join-race").addClass("hidden").removeClass("show");
  $(".btn-part-race").addClass("hidden").removeClass("show");
  $(".btn-unready-race").addClass("hidden").removeClass("show");
  $(".btn-rejoin-race").addClass("hidden").removeClass("show");
  $(".btn-abandon-race").addClass("hidden").removeClass("show");
  $(".btn-done-race").addClass("hidden").removeClass("show");
  $("#race-status-text").addClass("text-danger").removeClass("text-warning");
  $("#race-status-text").html(status_text);
  $("#race-duration").removeClass("updating-time");
}
