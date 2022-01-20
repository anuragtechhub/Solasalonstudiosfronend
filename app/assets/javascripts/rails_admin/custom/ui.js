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

$(document).on('rails_admin.dom_ready', function() {

  //$('.dropdown-toggle').dropdown();
  $('#filters').hide().siblings('.dropdown-toggle').hide();
  var $title = $('title');
  try { $title.html($('title').html().replace(/(?:^|\s)\S/g, function(a) { return a.toUpperCase(); })); } catch (e) { }

  //hide testimonial dropdown
  $('select[name^="stylist[testimonial_"]').next('.filtering-select').hide().next('.btn').css('margin-left', '0');

  //$('.currency-input').currencyinput();

});
