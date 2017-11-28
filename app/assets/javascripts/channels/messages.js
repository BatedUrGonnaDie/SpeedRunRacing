$(document).on("turbolinks:load", function() {
  if (gon.chat_room && gon.current_user_id) {
    App.messages = App.cable.subscriptions.create({channel: "MessagesChannel", room_id: gon.chat_room.id}, {
      connected: function() {
        // Called when the subscription is ready for use on the server
        console.log("We aliv in messages");
      },

      disconnected: function() {
        // Called when the subscription has been terminated by the server
        console.log("We death in messages");
      },

      received: function(data) {
        // Called when there's incoming data on the websocket for this channel
      }
    });
  }
});

$(document).on("page:before-change turbolinks:before-visit", function() {
  if (App.messages !== undefined) {
    App.cable.subscriptions.remove(App.messages);
    delete App.messages;
  }
});
