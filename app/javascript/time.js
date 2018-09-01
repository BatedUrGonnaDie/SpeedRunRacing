const timesync = require('timesync/dist/timesync')
import moment from "moment"

const ts = timesync.create({
  server: '/api/v1/timesync',
  interval: 10 * 60 * 1000
});

$(document).on("turbolinks:load race:updated", function() {
  $(".format-time").each(function() {
    const new_time = format_time($(this).html());
    $(this).html(new_time);
  });

  $(".format-past").each(function() {
    const time = format_past($(this).html());
    $(this).html(time);
  });

  $(".chat-timestamp").each(function() {
    $(this).html(format_timestamp($(this).html()));
  });
});

const format_time = function(time_string) {
  if (time_string === '-' || isNaN(time_string))
    return time_string;
  const m = moment.duration(parseInt(time_string), "seconds");
  const seconds = m.seconds();
  const minutes = m.minutes();
  const hours = Math.floor(m.asHours());
  let formatted_time = "" + seconds;
  if (seconds < 0)
    return formatted_time;
  if (seconds < 10)
    formatted_time = `0${formatted_time}`;
  formatted_time = `${(minutes % 60)}:${formatted_time}`;
  if (hours > 0){
    if (minutes < 10) {
      formatted_time = `0${formatted_time}`;
    }
    formatted_time = `${hours}:${formatted_time}`;
  }
  return formatted_time;
};

const format_past = function(date_string) {
  return moment(date_string).fromNow();
};

const format_timestamp = function(date_string) {
  const m = moment(date_string, moment.ISO_8601);
  if (!m.isValid())
    return date_string;
  var formatted_time = `${m.hours()}:`;
  if (m.minutes() < 10)
    formatted_time += "0";
  formatted_time += m.minutes();
  return formatted_time;
};

const get_seconds_from_data_diff = function(date_string) {
  const start = moment(date_string);
  const current = moment(ts.now());
  return (current.diff(start) / 1000);
};

export { ts, format_time, get_seconds_from_data_diff, format_timestamp }
