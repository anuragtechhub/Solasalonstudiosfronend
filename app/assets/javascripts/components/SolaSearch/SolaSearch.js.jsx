var SolaSearch = React.createClass({

	getInitialState: function () {
		return {
			date: this.props.date ? moment(this.props.date, "YYYY-MM-DD") : moment(),
			error: null,
			fingerprint: this.props.fingerprint,
			gloss_genius_api_key: this.props.gloss_genius_api_key,
			gloss_genius_api_url: this.props.gloss_genius_api_url,
			lat: this.props.lat,
			lng: this.props.lng,
			locations: this.props.locations || [],
			professionals: this.props.professionals || [],
			zoom: this.props.zoom,
		};
	},



	/**
	* Render functions
	*/

	render: function () {
		console.log('render SolaSearch locations', this.state.locations);
		
		return (
			<div className="SolaSearch">
				<ProfessionalResults professionals={this.state.professionals} />
				<LocationsMap lat={this.state.lat} lng={this.state.lng} locations={this.state.locations} zoom={this.state.zoom} />
			</div>
		);
	},



	/**
	* Helper functions
	*/

	getAvailabilities: function (service_guids) {
		var self = this;
		
		$.ajax({
			data: {
				service_guids: service_guids
			},
	    headers: {
	    	"api_key": this.props.gloss_genius_api_key,
	    	"device_id": this.props.fingerprint,
	    },
			method: 'POST',
	    url: this.props.gloss_genius_api_url + 'availabilities',
		}).done(function (response) {
			console.log('getAvailabilities response', response);
		}); 
	},

});