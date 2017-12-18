$(document).on("turbolinks:load", function() {
  if (gon.current_user_id && App.main === undefined) {
    App.main = App.cable.subscriptions.create("MainChannel", {
      connected: function() {
        if ($("#disconnect-alert").length)
          $("#disconnect-alert").remove();
      },

      disconnected: function() {
        if ($("#disconnect-alert").length)
          return;
        var msg = "<div id='disconnect-alert' class='alert alert-danger' role='alert'>";
        msg += "Diconnected from the server, race commands will not go through until we reconnect";
        msg += "Race finishes however will be queued and sent upon reconnection.";
        msg += "</div>";
        $("noscript").before(msg);
      },

      create_race: function(cat_id) {
        return this.perform("create_race", {cat_id: cat_id});
      },

      received: function(data) {
        var selector;
        switch (data.status) {
          case "race_created":
            selector = "#active-race-table tbody";
            if ($("#active-race-table").length) {
              $(selector).prepend(data.html);
            } else {
              if (window.location.pathname === "/")
                Turbolinks.visit(window.location.toString(), { action: 'replace' });
            }
            break;
          case "race_entrants_updated":
            selector = "#active-race-table tbody tr#race-id-" + data.race.id;
            if ($(selector).length) {
              $(selector).find(".entrants-column").text(data.race.entrants.length);
            }
            break;
          case "race_completed":
            selector = "#active-race-table tbody tr#race-id-" + data.race.id;
            if ($(selector).length)
              $(selector).remove();
            break;
          case "race_started":
            selector = "#active-race-table tbody tr#race-id-" + data.race.id;
            if ($(selector).length) {
              setTimeout(function() {
                $(selector).find(".duration-column")
                  .html("<div class='updating-time' data-start-time='" + data.race.start_time + "'>0:00</div>");
              }, Math.abs(get_seconds_from_data_diff(data.race.start_time) * 1000));
              $(selector).find(".status-column").addClass("text-warning").removeClass("text-success").text(data.race.status_text);
            }
            break;
          default:
            console.log("Default case shit yo");
            console.log(data);
          break;
        }
      }
    });
  }
});
