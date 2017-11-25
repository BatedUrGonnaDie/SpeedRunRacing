function Countdown(options) {
  var timer;
  var instance = this;
  var start_time = moment(options.start_time);
  var current_time = moment(ts.now());
  var current_seconds = ~~(start_time.diff(current_time) / 1000),
      previous_seconds = current_seconds;
  var update_status = options.on_update_status || function(args) {};
  var end_status = options.on_end_status || function(args) {};
  var update_args = options.update_args || {};
  var end_args = options.end_args || {};

  var decrement_counter = function() {
    update_status(current_seconds, update_args);
    if (current_seconds <= 0) {
      end_status(end_args);
      instance.stop();
    }
    current_time = moment(ts.now());
    previous_seconds = current_seconds;
    current_seconds = Math.round(start_time.diff(current_time) / 1000);
  };

  this.start = function() {
    clearInterval(timer);
    timer = 0;
    timer = setInterval(decrement_counter, 200);
  };

  this.stop = function() {
    clearInterval(timer);
  };
}
