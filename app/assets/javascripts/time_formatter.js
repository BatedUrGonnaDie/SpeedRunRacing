$(document).on("turbolinks:load", function() {
  $(".format-time").each(function() {
    var time = $(this).html();
    if (time === "-" || isNaN(time))
      return;
    var new_time = format_time(time);
    $(this).html(new_time);
  });
});

var format_time = function(time_string) {
  if (time_string === '-')
    return;
  var seconds = time_string % 60;
  var minutes = ~~(time_string / 60);
  var hours = ~~(minutes / 60);
  var formatted_time = "" + seconds;
  if (seconds < 10)
    formatted_time = "0" + formatted_time;
  formatted_time = minutes + ":" + formatted_time;
  if (minutes < 10 && hours === 0)
    formatted_time = "0" + formatted_time;
  if (hours > 0)
    formatted_time = hours + ":" + formatted_time;
  return formatted_time;
}
