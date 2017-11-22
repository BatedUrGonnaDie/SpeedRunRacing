$(document).on("turbolinks:load", function() {
  $(".format-time").each(function() {
    var new_time = format_time($(this).html());
    $(this).html(new_time);
  });
});

var format_time = function(time_string) {
  if (time_string === '-' || isNaN(time_string))
    return time_string;
  var m = moment.duration(time_string);
  var seconds = m.seconds();
  var minutes = m.minutes();
  var hours = m.hours();
  var formatted_time = "" + seconds;
  if (seconds < 10)
    formatted_time = "0" + formatted_time;
  formatted_time = (minutes % 60) + ":" + formatted_time;
  if (minutes < 10 && hours === 0)
    formatted_time = "0" + formatted_time;
  if (hours > 0)
    formatted_time = hours + ":" + formatted_time;
  return formatted_time;
};
