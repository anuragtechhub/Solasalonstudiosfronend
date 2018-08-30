var SearchBar = React.createClass({

	getInitialState: function () {
		return {
			date: this.props.date || new Date(),
			error: null,
			fingerprint: this.props.fingerprint,
			gloss_genius_api_key: this.props.gloss_genius_api_key,
			gloss_genius_api_url: this.props.gloss_genius_api_url,
			location: this.props.location || '',
			lat: this.props.lat || '',
			lng: this.props.lng || '',
			query: this.props.query || '',
		};
	},

	componentDidMount: function () {
		// fingerprint browser
		var fingerprint = new Fingerprint().get();
		this.setState({fingerprint: fingerprint});
	},



	/*
	* Render functions
	*/
	
	render: function () {
		return (
			<div className="SearchBar">
				<form method="post" action={this.props.path} onSubmit={this.onSubmit}>
					<SearchServicesAndSuggestions 
						fingerprint={this.state.fingerprint} 
						gloss_genius_api_key={this.state.gloss_genius_api_key} 
						gloss_genius_api_url={this.state.gloss_genius_api_url} 
						query={this.state.query} 
						onChangeQuery={this.onChangeQuery} 
					/>
					<SearchLocation location={this.state.location} onChangeLocation={this.onChangeLocation} />
					<SearchDatePicker date={this.state.date} onChangeDate={this.onChangeDate} />
					<button type="submit" className="primary">Search</button> 
				</form>
				{this.state.error ? <div className="error">{this.state.error}</div> : null}
			</div>
		);
	},



	/*
	* Event Handlers
	*/

	onChangeDate: function (date) {
		this.setState({date: date});
	},

	onChangeLocation: function (location, lat, lng) {
		this.setState({location: location, lat: lat, lng: lng});
	},

	onChangeQuery: function (query) {
		this.setState({query: query});
	},

	onSubmit: function (e) {
		e.preventDefault();

		var hasQuery = this.hasQuery();
		var hasLatLng = this.hasLatLng();
		
		if (hasQuery && hasLatLng) {
			// all good - proceed to search results
			window.location.href = this.props.path + '?' + this.getParams();
		} else {
			// we have errors
			if (!hasQuery && !hasLatLng) {
				this.setState({error: I18n.t('sola_search.please_enter_a_service_and_a_location')});
			} else if (hasQuery && !hasLatLng) {
				this.setState({error: I18n.t('sola_search.please_enter_a_location')});
			} else if (!hasQuery && hasLatLng) {
				this.setState({error: I18n.t('sola_search.please_enter_a_service')});
			}
		}
	},



	/**
	* Helper functions
	*/

	getParams: function () {
		return $.param({
			date: this.state.date,
			fingerprint: this.state.fingerprint,
			lat: this.state.lat,
			lng: this.state.lng,
			query: this.state.query,
		});
	},

	hasQuery: function () {
		return this.state.query && this.state.query != '';
	},

	hasLatLng: function () {
		return this.state.lat && this.state.lat != '' && this.state.lng && this.state.lng != '';
	}

});