/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

console.log('Hello World from Webpacker')
import "jquery"
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks'
Rails.start()
Turbolinks.start()

import "bootstrap"

import "../cable"
import "../channels/main"
import "../channels/messages"
import "../channels/notification"
import "../channels/races"

import "../admin_buttons"
import "../alerts"
import "../countdown"
import "../place"
import "../race_buttons"
import "../time"
import "../time_updater"
