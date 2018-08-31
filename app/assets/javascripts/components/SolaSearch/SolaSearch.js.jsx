var SolaSearch = React.createClass({

	getInitialState: function () {
		return {
			professionals: this.props.professionals || []
		};
	},



	/**
	* Render functions
	*/

	render: function () {
		console.log('render SolaSearch', this.state.professionals);
		
		return (
			<div className="SolaSearch">
				<ProfessionalResults professionals={this.state.professionals} />
				<LocationMap />
			</div>
		);
	},



	/**
	* Helper functions
	*/

	getAvailabilities: function () {
		var self = this;

		//console.log('getSuggestions', query);
		
		$.ajax({
	    url: this.props.gloss_genius_api_url + 'suggestions?query=' + query,
	    headers: {
	    	"api_key": this.props.gloss_genius_api_key,
	    	"device_id": this.props.fingerprint,
	    }
		}).done(function (response) {
			var json_response = JSON.parse(response);
			var professionals = json_response.professionals;
			var salons = json_response.salons;
			self.setState({professionals: professionals, salons: salons});
		});
	},

});