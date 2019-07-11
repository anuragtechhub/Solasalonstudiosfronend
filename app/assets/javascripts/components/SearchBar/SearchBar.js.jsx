var SearchBar = React.createClass({

	getInitialState: function () {
		return {
			date: this.props.date ? moment(this.props.date, "YYYY-MM-DD") : moment(),
			error: this.props.error,
			fingerprint: this.props.fingerprint,
			gloss_genius_api_key: this.props.gloss_genius_api_key,
			gloss_genius_api_url: this.props.gloss_genius_api_url,
			loading: false,
			location: this.props.location || '',
			location_id: this.props.location_id,
			lat: this.props.lat || '',
			lng: this.props.lng || '',
			query: this.props.query || '',
		};
	},

	componentWillReceiveProps: function (nextProps) {
		if (nextProps.location_id != this.state.location_id) {
			this.setState({location_id: nextProps.location_id});
		}
	},

	componentDidUpdate: function (prevProps, prevState) {
		if (prevState.location_id != this.state.location_id) {
			this.onSubmit();
		}
	},

	componentDidMount: function () {
		var self = this;
		// fingerprint browser
		var fingerprint = new Fingerprint().get();
		this.setState({fingerprint: fingerprint});

		window.addEventListener("pageshow", function (event) {
		  var historyTraversal = event.persisted || (typeof window.performance != "undefined" && window.performance.navigation.type === 2);
		  
		  if (historyTraversal) {
		    self.setState({loading: false});
		  }
		});		
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
				{this.state.loading ? <div className="loading"><div className="spinner"></div></div> : null}
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
		//console.log('onChangeLocation', location, lat, lng);
		this.setState({location: location, lat: lat, lng: lng});
	},

	onChangeQuery: function (query) {
		this.setState({query: query});
	},

	onSubmit: function (e) {
		//console.log('submit', $('.pac-container').is(':visible'));

		if (e && typeof e.preventDefault == 'function') {
			e.preventDefault();
		}
		

		var hasQuery = this.hasQuery();
		var hasLatLng = this.state.location && this.state.location != '';//this.hasLatLng();

		if (hasQuery && hasLatLng && this.state.date) {
			// all good - proceed to search results
			this.setState({error: null, loading: true});
			window.location.href = this.props.path + '?' + this.getParams();
		} else {
			// we have errors
			if (!hasQuery && !hasLatLng) {
				this.setState({error: I18n.t('sola_search.please_enter_a_service_and_a_location')});
			} else if (hasQuery && !hasLatLng) {
				this.setState({error: I18n.t('sola_search.please_enter_your_location')});
			} else if (!hasQuery && hasLatLng) {
				this.setState({error: I18n.t('sola_search.please_enter_a_service')});
			} else if (!this.state.date || this.state.date == '') {
				this.setState({error: I18n.t('sola_search.please_enter_a_date')});
			}
		}
	},



	/**
	* Helper functions
	*/

	getParams: function () {
		return $.param({
			date: this.state.date.format('YYYY-MM-DD'),
			fingerprint: this.state.fingerprint,
			lat: this.state.lat,
			lng: this.state.lng,
			location_id: this.state.location_id,
			location: this.state.location,
			query: this.state.query,
			referring_url: this.props.referring_url
		});
	},

	hasQuery: function () {
		return this.state.query && this.state.query != '';
	},

	hasLatLng: function () {
		return this.state.lat && this.state.lat != '' && this.state.lng && this.state.lng != '';
	}

});