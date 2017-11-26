alertify.defaults.notifier.position = "top-right";
alertify.defaults.notifier.closeButton = true;
alertify.defaults.transition = "slide";
alertify.defaults.theme.ok = "btn btn-primary";
alertify.defaults.theme.cancel = "btn btn-danger";
alertify.defaults.theme.input = "form-control";

var push_alert = function(msg, css_class) {
    alertify.notify(msg, css_class, 5);
};
