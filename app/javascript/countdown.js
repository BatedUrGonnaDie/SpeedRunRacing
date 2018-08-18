import moment from "moment"

import { ts } from "./time"

function Countdown(options) {
  let timer;
  const instance = this;
  const start_time = moment(options.start_time);
  let current_time = moment(ts.now());
  let current_seconds = ~~(start_time.diff(current_time) / 1000);
  const update_status = options.on_update_status || function(args) {};
  const end_status = options.on_end_status || function(args) {};
  const update_args = options.update_args || {};
  const end_args = options.end_args || {};

  const decrement_counter = function() {
    update_status(current_seconds, update_args);
    if (current_seconds <= 0) {
      end_status(end_args);
      instance.stop();
    }
    current_time = moment(ts.now());
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

export { Countdown }
