if (gon.race_id !== undefined) {
  App.races = App.cable.subscriptions.create({channel: "RacesChannel", race_id: gon.race_id}, {
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
    }
  });
}

$(document).on("page:before-change turbolinks:before-visit", function() {
  App.races.perform("unsubscribe");
});
