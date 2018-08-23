var SearchLocation = React.createClass({

	componentDidMount: function () {
		var self = this;

		var autocomplete = new google.maps.places.Autocomplete(this.refs.input, {
			types: ['(cities)'],
		});

		autocomplete.addListener('place_changed', function() {
    	var place = autocomplete.getPlace();
    	self.props.onChangeLocation(place.formatted_address);
    });
	},

	

	/*
	* Render functions
	*/

	render: function () {
		return (
			<div className="SearchLocation">
				<span className="fa fa-map-marker">&nbsp;</span>
				<input ref="input" type="text" placeholder="Current Location" value={this.props.location} />
			</div>
		);
	},



});