//= require jquery.widget
//= require autonumeric
//= require currency_input

// $(function () {
//   $('.currency-input').currencyinput();
// });

$(document).on('ready pjax:success', function() {
  $('.currency-input').currencyinput();
});

// $(document).on('turbolinks:load', function() {
//   $('.currency-input').currencyinput();
// });