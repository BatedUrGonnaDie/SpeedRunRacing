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
        Turbolinks.visit(data.location);
        break;
      case "race_create_failure":
        console.log("do something about the failure");
        break;
      case "race_entry_success":
        $(".btn-join-race").addClass("hidden").removeClass("show");
        $(".btn-part-race").addClass("show").removeClass("hidden");
        break;
      case "race_entry_removed":
        $(".btn-join-race").addClass("show").removeClass("hidden");
        $(".btn-part-race").addClass("hidden").removeClass("show");
        break;
      default:
        console.log("Default case reached for data");
        console.log(data);
        break;
    }
  }
});
