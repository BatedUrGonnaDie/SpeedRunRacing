App.races = App.cable.subscriptions.create("RacesChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
    console.log("We are live bois");
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
    console.log("We dead now bois");
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data);
  }
});
