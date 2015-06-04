$(document).on('rails_admin.dom_ready', function() {  
  
  $('.dropdown-toggle').dropdown();
  $('#filters').hide().siblings('.dropdown-toggle').hide();
  var $title = $('title');
  try { $title.html($('title').html().replace(/(?:^|\s)\S/g, function(a) { return a.toUpperCase(); })); } catch (e) { }
  
  //hide testimonial dropdown
  $('select[name^="stylist[testimonial_"]').next('.filtering-select').hide().next('.btn').css('margin-left', '0');

});