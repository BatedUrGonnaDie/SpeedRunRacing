App.notification = App.cable.subscriptions.create("NotificationChannel", {
  connected: function() {
    console.log("We aliv in notifications");
  },

  disconnected: function() {
    console.log("We ded in notifications");
  },

  received: function(data) {
     switch (data.update) {
        case "race_create_success":
            turbolinks.visit(data.location);
            break;
        case "race_create_failure":
            console.log("do something about the failure");
            break;
        default:
            console.log("Default case reached for data");
            console.log(data);
            break;
     }
  }
});
