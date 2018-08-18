import { format_time, get_seconds_from_data_diff } from "./time"

let global_time_updater;

$(document).on("turbolinks:load", function() {
  if (!global_time_updater) {
    update_time();
    global_time_updater = setInterval(update_time, 200);
  }
});

const update_time = function() {
  $(".updating-time").each(function() {
    const start = $(this).data("start-time");
    const time = get_seconds_from_data_diff(start);
    $(this).html(format_time(time));
  });
};
