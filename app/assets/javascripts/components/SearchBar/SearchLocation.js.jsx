var SearchLocation = React.createClass({

	componentDidMount: function () {
		var autocomplete = new google.maps.places.Autocomplete(this.refs.input, {
			types: ['(cities)'],
		});
		
		autocomplete.addListener('place_changed', function() {
    	var place = autocomplete.getPlace();
    	console.log('place', place.formatted_address);
    });
	},

	render: function () {
		return (
			<div className="SearchLocation">
				<span className="fa fa-map-marker">&nbsp;</span>
				<input ref="input" type="text" placeholder="Current Location" />
			</div>
		);
	}

});