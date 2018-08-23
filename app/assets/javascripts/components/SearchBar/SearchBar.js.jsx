var SearchBar = React.createClass({

	getInitialState: function () {
		return {
			date: this.props.date || new Date(),
			fingerprint: this.props.fingerprint,
			gloss_genius_api_key: this.props.gloss_genius_api_key,
			gloss_genius_api_url: this.props.gloss_genius_api_url,
			location: this.props.location || '',
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
			</div>
		);
	},



	/*
	* Event Handlers
	*/

	onChangeDate: function (date) {
		//console.log("onChangeDate", date);
		this.setState({date: date});
	},

	onChangeLocation: function (location) {
		console.log('onChangeLocation', location);
		this.setState({location: location});
	},

	onChangeQuery: function (query) {
		//console.log('onChangeQuery', query);
		this.setState({query: query});
	},

	onSubmit: function (e) {
		console.log('submit SearchBar');
		//e.preventDefault();
	},

});