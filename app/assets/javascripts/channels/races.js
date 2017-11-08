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
