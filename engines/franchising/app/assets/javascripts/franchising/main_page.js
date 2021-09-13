//= require franchising/wpcp-bottom/wpfront-notification-bar/wpfront-notification-bar.min
// require wpcp-bottom/generatepress/classList.min
//= require franchising/wpcp-bottom/generatepress/main.min
//= require franchising/wpcp-bottom/premium-addons-pro/multiscroll.min
//= require franchising/wpcp-bottom/premium-addons-pro/premium-addons.min
//= require franchising/wpcp-bottom/elementor/assets/lib/jquery-numerator/jquery-numerator.min
//= require franchising/wpcp-bottom/elementor-pro/assets/lib/smartmenus/jquery.smartmenus.min
//= require franchising/wpcp-bottom/elementor/assets/js/frontend-modules.min
//= require franchising/wpcp-bottom/elementor-pro/assets/js/frontend.min
//= require franchising/wpcp-bottom/elementor/assets/lib/dialog/dialog.min
//= require franchising/wpcp-bottom/elementor/assets/lib/waypoints/waypoints.min
//= require franchising/wpcp-bottom/elementor/assets/lib/swiper/swiper.min
//= require franchising/wpcp-bottom/elementor/assets/js/frontend.min
//= require franchising/jquery.magnific-popup.min.js

jQuery('input[type=radio][name=input_8]').change(function() {
  if (this.value == 'franchise') {
    jQuery('#gform_fields_2').addClass('hidded');
    jQuery('#gform_fields_3').removeClass('hidded');
  } else {
    jQuery('#gform_fields_2').removeClass('hidded');
    jQuery('#gform_fields_3').addClass('hidded');
  }
});
jQuery('form').submit(function(){
  $(this).find('input[type=submit]').prop('disabled', true);
});


$(document).ready(function() {
  $('#headerVideoLink').magnificPopup({
    type:'inline',
    midClick: true,
    callbacks: {
      close: function () {
        setTimeout(() => { $('.yt_player_iframe').each(function(){
          this.contentWindow.postMessage('{"event":"command","func":"stopVideo","args":""}', '*')
        }); }, 1000);

      }
    }
  });
});
