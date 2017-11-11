$(document).on("turbolinks:load", function() {
  if (gon.race !== undefined) {
    if (App.races === undefined) {
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
            default:
              console.log("Default case shit yo");
              console.log(data);
          }
        },

        join_race: function() {
          this.perform("join_race");
        },

        part_race: function() {
          this.perform("part_race");
        },

        ready_up: function() {
          this.perform("ready");
        },

        unready: function() {
          this.perform("unready");
        },

        done: function() {
          this.perform("done");
        }
      });
    }
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
    console.log(row);
    console.log(e);
    if (row.length){
      row.find(".name-column").html(e.user.display_name);
      var cls;
      if (e.ready)
        cls = "glyphicon glyphicon-ok text-success";
      else
        cls = "glyphicon glyphicon-remove text-danger";
      row.find(".ready-column > i").removeClass().addClass(cls);
      row.find(".time-column .format-time").html = "-";
      row.find(".place-column .format-place").html(e.place ? e.place : '-');
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
    var new_entrants = race.entrants.map(function(i, elem) {return elem.id;});
    var to_remove = current_entrants.filter(function(el) {return new_entrants.indexOf(el) < 0;});
    console.log(to_remove);
    for (i = 0; i < to_remove.length; i++) {
      var selector = "#entrants-list tbody tr#entrant-id-" + to_remove[i];
      console.log($(selector));
      if ($(selector).length)
        $(selector).remove();
    }
  }
};
