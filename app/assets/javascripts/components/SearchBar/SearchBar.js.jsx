var SearchBar = React.createClass({

	getInitialState: function () {
		return {
			date: this.props.date || new Date(),
		}
	},
	
	render: function () {
		return (
			<div className="SearchBar">
				<form method="post" action={this.props.path} onSubmit={this.onSubmit}>
					<SearchServices />
					<SearchLocation />
					{/*<SearchDatePicker date={this.state.date} onChangeDate={this.onChangeDate} />*/}
					<button type="submit" className="primary">Search</button> 
				</form>
			</div>
		);
	},


	/*
	* Event Handlers
	*/

	onChangeDate: function (date) {
		console.log("onChangeDate", date);
		this.setState({date: date});
	},

	onSubmit: function (e) {
		console.log('submit SearchBar');

		//e.preventDefault();
	},

})