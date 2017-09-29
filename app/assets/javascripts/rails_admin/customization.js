//= require select2
//= require react
//= require react_ujs
//= require components

//= require jquery.widget
//= require autonumeric
//= require currency_input

// $(document).on('ready pjax:success', function() {
//   $('.currency-input').currencyinput();
// });

$(document).on('ready pjax:success', function() {
  ReactRailsUJS.mountComponents();
});