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
        switch (data.update) {
          case "chat_message_created":
            append_message(data.message.created_at, data.message.user.display_name, data.message.body);
            break;
          default:
            console.log("Default case reached");
            console.log(data);
            break;
        }
      },

      send_message: function(message) {
        this.perform("send_message", {message: message});
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

$(document).on("turbolinks:load", function() {
  if ($("#new-message-form").length) {
    $("#new-message-form").submit(function(e) {
      var message_box = $("#message-input-box");
      var message = message_box.val();
      if ($.trim(message.length) > 1) {
        App.messages.send_message(message);
        message_box.val("");
      }
      e.preventDefault();
      return false;
    });
  }

  var list = $("#message-list");
  if (list.length) {
    list.scrollTop(list.prop("scrollHeight"));
  }
});

var append_message = function(time, name, body) {
  var list = $("#message-list");
  var scroll = list.prop("scrollHeight") - list.scrollTop() == list.height();
  var $new_item = $("<li />").addClass("chat-message");
  $new_item.append($("<span />").addClass("chat-timestamp").text(format_timestamp(time)));
  $new_item.append($("<span />").addClass("chat-name").text(name));
  $new_item.append($("<span />").text(": "));
  $new_item.append($("<span />").addClass("chat-body").text(body));
  list.append($new_item);
  if (scroll)
    list.scrollTop(list.prop("scrollHeight"));
};
