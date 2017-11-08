$(document).on("turbolinks:load", function() {
  $(".btn-create-race").each(function(index) {
    $(this).click(function() {
      App.main.create_race($(this).data("category"));
    });
  });
});

App.main = App.cable.subscriptions.create("MainChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
    console.log("We are live bois");
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
    console.log("We dead now bois");
  },

  create_race: function(cat_id) {
    return this.perform("create_race", {cat_id: cat_id});
  },

  received: function(data) {
    switch (data.update) {
        case "race_created":
            console.log(data);
            break;
        case "race_completed":
            console.log(data);
            break;
        default:
            console.log("Default case shit yo");
            console.log(data);
            break;
    }
  }
});
