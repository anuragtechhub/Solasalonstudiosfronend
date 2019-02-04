var SearchLocation = React.createClass({

	componentDidMount: function () {
		var self = this;

		var autocomplete = new google.maps.places.Autocomplete(this.refs.input, {
			//types: ['(cities)'],
		});

		autocomplete.addListener('place_changed', function() {
    	var place = autocomplete.getPlace();
    	//console.log('place.geometry.location', place.geometry.location.lat(), place.geometry.location.lng());
    	self.props.onChangeLocation(place.formatted_address, place.geometry.location.lat(), place.geometry.location.lng());
    });

		google.maps.event.addDomListener(this.refs.input, 'keydown', function (event) { 
	    if (event.keyCode === 13 && $('.pac-container:visible').length) { 
	    	event.preventDefault(); 
	    }
	  });

    // geolocation functionality
    if ("geolocation" in navigator) {
		  //console.log('geolocation is available');
		  if (!this.props.location) {
		  	//console.log('no location, so lets ask geolocation for current position');
			  navigator.geolocation.getCurrentPosition(function(position) {
			  	//console.log('position', position.coords.latitude, position.coords.longitude);
			    $.ajax({
			      method: 'GET',
			      url: 'https://maps.googleapis.com/maps/api/geocode/json',
			      data: {
			      	latlng: position.coords.latitude + ',' + position.coords.longitude,
			      	key: 'AIzaSyD2Oj3CGe7UCPl_stI1vAIZ1WLVuoJ8WF8'
			      }
			    }).done(function(data) {
			    	//console.log('reverse geocode is complete', data);
			    	if (data && data.results && data.results.length > 0) {
			    		self.props.onChangeLocation(data.results[0].formatted_address, position.coords.latitude, position.coords.longitude);
			    	}
			    });
			  	//https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&sensor=true&key=AIzaSyD2Oj3CGe7UCPl_stI1vAIZ1WLVuoJ8WF8
			  	//self.props.onGetCurrentPosition(position.coords.latitude, position.coords.longitude);
			  });
		  }
		} else {
			//console.log('geolocation IS NOT available');
		}
	},

	

	/*
	* Render functions
	*/

	render: function () {
		return (
			<div className="SearchLocation">
				<span className="fa fa-map-marker">&nbsp;</span>
				<input ref="input" type="text" placeholder={I18n.t('sola_search.location')} value={this.props.location} onChange={this.onChange} />
			</div>
		);
	},



	/**
	* Change handler
	*/

	onChange: function (event) {
		this.props.onChangeLocation(event.target.value);
	},

});