var global_time_updater;

$(document).on("turbolinks:load", function() {
  if (!global_time_updater) {
    update_time();
    global_time_updater = setInterval(update_time, 200);
  }
});

var update_time = function() {
  $(".updating-time").each(function() {
    var start = $(this).data("start-time");
    var time = get_seconds_from_data_diff(start);
    $(this).html(format_time(time));
  });
};
