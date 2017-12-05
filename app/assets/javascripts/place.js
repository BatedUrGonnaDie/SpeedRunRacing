$(document).on("turbolinks:load", function() {
  $(".format-place").each(function() {
    var new_place = format_place($(this).html());
    $(this).html(new_place);
  });
});

var format_place = function(place_string) {
  if (place_string === "-" || isNaN(place_string))
    return place_string;
  if (place_string < 0)
    return "<i class='glyphicon glyphicon-remove text-danger' />";
  var suffix_hash = {1: "st", 2: "nd", 3: "rd"};
  var exceptions = [11, 12, 13];
  var suffix;
  if (exceptions.includes(place_string))
    suffix = "th";
  if (suffix === undefined)
    suffix = suffix_hash[place_string % 10];
  if (suffix === undefined)
    suffix = "th";
  place_string = "" + place_string;
  return place_string.replace(/\s/g, '') + "<sup>" + suffix + "</sup>";
};
