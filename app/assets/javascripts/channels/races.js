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
              for (var i = 0; i < data.race.entrants.length; i++) {
                var e = data.race.entrants[i];
                var row = $("tr#entrant-id-" + e.id);
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
                  // TODO: create the column instead of modifying
                }
              }
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
