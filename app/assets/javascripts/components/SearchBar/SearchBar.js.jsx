var SearchBar = React.createClass({

	getInitialState: function () {
		return {
			date: this.props.date || new Date(),
			query: this.props.query || '',
		}
	},
	
	render: function () {
		return (
			<div className="SearchBar">
				<form method="post" action={this.props.path} onSubmit={this.onSubmit}>
					<SearchServices query={this.state.query} onChangeQuery={this.onChangeQuery} />
					<SearchLocation />
					<SearchDatePicker date={this.state.date} onChangeDate={this.onChangeDate} />
					<button type="submit" className="primary">Search</button> 
				</form>
			</div>
		);
	},


	/*
	* Event Handlers
	*/

	onChangeQuery: function (query) {
		console.log('onChangeQuery', query);
		this.setState({query: query});
	},

	onChangeDate: function (date) {
		console.log("onChangeDate", date);
		this.setState({date: date});
	},

	onSubmit: function (e) {
		console.log('submit SearchBar');

		//e.preventDefault();
	},

})