//= require franchising/jquery2
//= require jquery_ujs
//= require franchising/jquery.swipebox
//= require franchising/jquery.widget
//= require bootstrap
//= require franchising/modal
//= require franchising/cookie
//= require franchising/wpcp-bottom/lazysizes.min

var init_lightboxes = function () {
  function initModals() {
    $('.bio').modal();
  }
  initModals();

  $(document).on('click', '.leadership-tile', function () {
    var $this = $(this);
    var id = $this.data('rel');
    if (id) {
      var src = $this.find('img').attr('src')
      var name = $this.find('h6').text();
      var title = $this.find('span').text();
      var bio = $this.find('p').html();

      var html = `<div class="modal-header">
        <img src="${src}" />
        <span class="name">${name}</span>
        <span class="company">${title}</span>
        <span class="line">&nbsp;</span>
      </div>
      <div class="text">
 				${bio}
      </div>`

      $('.bio[data-rel=' + id + ']').html(html).data('modal').open();
    }
    return false;
  });

  $(document).on('click', '.modal-header .company a', function () {
    return false;
  });
};

var downloadPDF = function () {
  var req = new XMLHttpRequest();
  req.open("GET", "/pdfs/Sola Salon Studios Franchise Guide.pdf", true);
  req.responseType = "blob";

  req.onload = function (event) {
    var blob = req.response;
    // console.log(blob.size);
    var link = document.createElement('a');
    link.href = window.URL.createObjectURL(blob);
    link.download = "Sola Salon Studios Franchise Guide.pdf";
    link.click();

    setTimeout(function(){
      window.location = '/thank-you'
    },100)
  };

  req.send();
}

var getUrlParameter = function getUrlParameter(sParam) {
  var sPageURL = window.location.search.substring(1),
    sURLVariables = sPageURL.split('&'),
    sParameterName,
    i;

  for (i = 0; i < sURLVariables.length; i++) {
    sParameterName = sURLVariables[i].split('=');

    if (sParameterName[0] === sParam) {
      return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
    }
  }
};


var store_utm_params = function () {

  //window.getUrlParameter = getUrlParameter;

  var utm_params = ['utm_source', 'utm_medium', 'utm_campaign', 'utm_term', 'utm_content'];
  for (var i = 0, ilen = utm_params.length; i < ilen; i++) {
    var utm_param = utm_params[i];
    var param_value = getUrlParameter(utm_param);

    if (param_value) {
      console.log('utm param', utm_param, param_value);
      Cookies.set(utm_param, param_value);
    }
  }

}

var init_franchising_form = function () {
  var resetForm = function () {
    try {
      $('.errors').html('').hide();
      $('#franchising-form')[0].reset();
      $('input[type=checkbox], input[type=radio]').prop('checked', false);
    } catch (e) {
      // shhh...
    }
  }

  resetForm();

  $('.guide .gatekeeper-radio').off('change').on('change', function (e) {
    if (e.target.value === 'franchise') {
      $('#franchising-form').removeClass('disabled').show().find('input, button, select').prop('disabled', false);
      $('.gatekeeper-stylist-link').hide();
    } else {
      $('#franchising-form').addClass('disabled').hide().find('input, button, select').prop('disabled', true);
      $('.gatekeeper-stylist-link').show();
    }
  })

  $('#franchising-form').off('submit').on('submit', function (e) {
    e.preventDefault();
    e.stopPropagation();

    $.ajax({
      method: 'POST',
      url: '/save-franchising-form',
      data: $('#franchising-form').serialize()
    }).done(function(data) {
      if (data && data.errors) {
        var error_html = data.errors.map(function (err) {
          return '<li>' + err + '</li>'
        }).join('');
        $('.errors').html(error_html).show();
        $("html, body").animate({ scrollTop: $('#form-errors').offset().top }, 500);
      } else if (data && data.success) {
        resetForm();
        setTimeout(function () {
          // $("html, body").animate({ scrollTop: $('#get-the-franchise-guide').offset().top }, 500);
          // alert('Thank you! We will get in touch soon');
          downloadPDF();
        }, 100);
      }
    });
  });
}

$(document).ready(function() {
  store_utm_params()

  $('nav').clone().appendTo('.side_bar');

  $('.menu_icon').click(function(){
    $('body').toggleClass('open_menu');
  });

  $(document.body).on('click', '.contact-us-button', function (e) {
    e.preventDefault();

    $("html, body").animate({ scrollTop: $('#get-the-franchise-guide').offset().top }, 1000);
  })

  // $('.play-video').swipebox();
  init_franchising_form();
});

$(window).bind("pageshow", function() {
  init_franchising_form();
  init_lightboxes();
});