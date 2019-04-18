$(function () {
	
	var $searchForSalon = $('.search-for-a-salon');
	
	$searchForSalon.find('form.search-salon').on('submit', function () {
		var $form = $(this);
		var query = $form.find('input[name=query]').val();
		
		// show spinner
		$searchForSalon.find('.salon-search-results').slideUp('fast');
		$searchForSalon.find('.salon-search-spinner').slideDown('fast');

    $.ajax({
      method: 'POST',
      url: $form.attr('action'),
      data: 'query=' + query
    }).done(function (data) {
      if (data && data.length > 0) {
      	var html = '';
      	var location = null;

      	for (var i = 0, ilen = data.length; i < ilen; i++) {
      		location = data[i];
          //console.log('location', location)
      		html = html + "<div data-href='/locations/" + location.url_name + "' class='salon-search-result'>";

      		html = html + "<div class='names'>";
      		html = html + "<h4 class='location-name'>" + location.name + "</h4>";
          html = html + "<p class='address'>" + location.full_address + "</p>"
      		//html = html + "<p class='general-contact-name'>" + I18n.t('contact_for_leasing_information', {general_contact_name: location.general_contact_name}) + "</p>";
      		html = html + '</div>';
      		
      		//html = html + "<p class='phone-number'><a href='tel:" + location.phone_number + "'>" + I18n.t('phone_result', {phone_number: location.phone_number}) + "</a></p>";
          
      		//html = html + "<p class='email-address'><a href='mailto:" + location.email_address_for_inquiries + "'>" + I18n.t('email_result', {email_address: location.email_address_for_inquiries}) + "</a></p>";
      		html = html + "<div class='chevron-right'><span class='fa fa-chevron-right'>&nbsp;</span></div>";

      		html = html + "</div>";
      	}

      	$searchForSalon.find('.salon-search-results').html(html);
      }

			// hide spinner
			$searchForSalon.find('.salon-search-spinner').slideUp('fast');
			$searchForSalon.find('.salon-search-results').slideDown('fast');
    });

		return false;
	});

	/**
	* .salon-search-result click handler
	*/
	$(document.body).on('click', '.salon-search-result', function () {
		window.location.href = $(this).data('href');
	});

});