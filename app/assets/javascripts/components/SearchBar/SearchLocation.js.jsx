var SearchLocation = React.createClass({

	componentDidMount: function () {
		var self = this;

		var autocomplete = new google.maps.places.Autocomplete(this.refs.input, {
			types: ['(cities)'],
		});

		autocomplete.addListener('place_changed', function() {
    	var place = autocomplete.getPlace();
    	//console.log('place.geometry.location', place.geometry.location.lat(), place.geometry.location.lng());
    	self.props.onChangeLocation(place.formatted_address, place.geometry.location.lat(), place.geometry.location.lng());
    });
	},

	

	/*
	* Render functions
	*/

	render: function () {
		return (
			<div className="SearchLocation">
				<span className="fa fa-map-marker">&nbsp;</span>
				<input ref="input" type="text" placeholder="Current Location" value={this.props.location} onChange={this.onChange} />
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