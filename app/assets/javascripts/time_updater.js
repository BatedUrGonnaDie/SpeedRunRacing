var global_time_updater;
$(document).on("turbolinks:load", function() {
  update_time();
  global_time_updater = setInterval(update_time, 1000);
});

var update_time = function() {
  $(".updating-time").each(function() {
    var duration = $(this).data("duration");
    var time = format_time(duration);
    var m = moment.duration(duration, "seconds");
    m.add(1, "seconds");
    $(this).data("duration", m.asSeconds());
    $(this).html(time);
  });
};
