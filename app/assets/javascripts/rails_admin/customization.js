//= require jquery.widget
//= require autonumeric
//= require currency_input

$(document).on('ready pjax:success', function() {
  $('.currency-input').currencyinput();
});