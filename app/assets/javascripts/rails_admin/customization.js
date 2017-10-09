//= require select2
//= require flatpickr
//= require ckeditor/init
//= require jquery-labelauty
//= require classNames
//= require dropzone
//= require xml2json
//= require loadingoverlay

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