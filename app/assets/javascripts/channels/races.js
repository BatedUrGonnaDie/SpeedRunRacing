$(document).on("turbolinks:load", function() {
  if (gon.race && gon.current_user_id) {
    App.races = App.cable.subscriptions.create({channel: "RacesChannel", race_id: gon.race.id}, {
      connected: function() {
        // Called when the subscription is ready for use on the server
        console.log("We are live in races bois");
      },

      disconnected: function() {
        // Called when the subscription has been terminated by the server
        console.log("We dead now in races bois");
      },

      received: function(data) {
        // Called when there's incoming data on the websocket for this channel
        console.log("Races received");
        console.log(data);
        switch (data.update) {
          case "race_entrants_updated":
            update_entrant_tables(data.race);
            break;
          case "race_started":
            $(".btn-join-race").addClass("hidden").removeClass("show");
            $(".btn-part-race").addClass("hidden").removeClass("show");
            $(".btn-ready-race").addClass("hidden").removeClass("show");
            if ($(".btn-unready-race").hasClass("show")) {
              $(".btn-abandon-race").addClass("show").removeClass("hidden");
              $(".btn-done-race").addClass("show").removeClass("hidden");
            }
            $(".btn-unready-race").addClass("hidden").removeClass("show");
            $("#race-status-text").addClass("text-warning").removeClass("text-success");
            $("#race-status-text").html(data.race.status_text);
            $("#race-duration").addClass("updating-time");
            break;
          case "race_completed":
            $(".btn-join-race").addClass("hidden").removeClass("show");
            $(".btn-part-race").addClass("hidden").removeClass("show");
            $(".btn-unready-race").addClass("hidden").removeClass("show");
            $(".btn-rejoin-race").addClass("hidden").removeClass("show");
            $(".btn-abandon-race").addClass("hidden").removeClass("show");
            $(".btn-done-race").addClass("hidden").removeClass("show");
            $("#race-status-text").addClass("text-danger").removeClass("text-warning");
            $("#race-status-text").html(data.race.status_text);
            $("#race-duration").removeClass("updating-time");
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

      done: function() {
        this.perform("done");
      },

      rejoin: function() {
        this.perform("rejoin_race");
      }
    });
  }
});

$(document).on("page:before-change turbolinks:before-visit", function() {
  if (App.races !== undefined) {
    App.races.perform("unsubscribed");
    delete App.races;
  }
});

var update_entrant_tables = function(race) {
  for (var i = 0; i < race.entrants.length; i++) {
    var e = race.entrants[i];
    var row = $("tr#entrant-id-" + e.id);
    if (row.length){
      row.find(".name-column").html(e.user.display_name);
      var cls;
      if (e.ready)
        cls = "glyphicon glyphicon-ok text-success";
      else
        cls = "glyphicon glyphicon-remove text-danger";
      row.find(".ready-column > i").removeClass().addClass(cls);
      row.find(".time-column .format-time").html(format_time(e.duration || "-"));
      row.find(".place-column .format-place").html(format_place(e.place || "-"));
    } else {
      var new_row = "";
      new_row += "<tr id='entrant-id-" + e.id + "' data-entrant-id='" + e.id + "'>";
      new_row += "<td class='name-column'>" + e.user.display_name + "</td>";
      new_row += "<td class='ready-column'><i class='glyphicon glyphicon-remove text-danger' /></td>";
      new_row += "<td class='time-column'>-</td>";
      new_row += "<td class='place-column'>-</td>";
      new_row += "</tr>";
      $("#entrants-list tbody").append(new_row);
    }
  }
  if (race.entrants.length < $("#entrants-list tbody tr").length) {
    var current_entrants = $.map($("#entrants-list tbody tr"), function(val, i) {
      return val.dataset.entrantId;
    });
    var new_entrants = race.entrants.map(function(elem, i) {return "" + elem.id;});
    var to_remove = $(current_entrants).not(new_entrants).get();
    for (i = 0; i < to_remove.length; i++) {
      var selector = "#entrants-list tbody tr#entrant-id-" + to_remove[i];
      if ($(selector).length)
        $(selector).remove();
    }
  }
};
