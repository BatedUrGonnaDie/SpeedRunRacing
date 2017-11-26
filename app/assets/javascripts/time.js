var ts = timesync.create({
  server: '/timesync',
  interval: 10 * 60 * 1000
});

$(document).on("turbolinks:load", function() {
  $(".format-time").each(function() {
    var new_time = format_time($(this).html());
    $(this).html(new_time);
  });

  $(".format-past").each(function() {
    var time = format_past($(this).html());
    $(this).html(time);
  });
});

var format_time = function(time_string) {
  if (time_string === '-' || isNaN(time_string))
    return time_string;
  var m = moment.duration(parseInt(time_string), "seconds");
  var seconds = m.seconds();
  var minutes = m.minutes();
  var hours = Math.floor(m.asHours());
  var formatted_time = "" + seconds;
  if (seconds < 10)
    formatted_time = "0" + formatted_time;
  formatted_time = (minutes % 60) + ":" + formatted_time;
  if (hours > 0){
    if (minutes < 10) {
      formatted_time = "0" + formatted_time;
    }
    formatted_time = hours + ":" + formatted_time;
  }
  return formatted_time;
};

var format_past = function(date_string) {
  return moment(date_string).fromNow();
};

var get_seconds_from_data_diff = function(date_string) {
  var start = moment(date_string);
  var current = moment(ts.now());
  return (current.diff(start) / 1000);
};
