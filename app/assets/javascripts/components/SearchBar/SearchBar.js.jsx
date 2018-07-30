var SearchBar = React.createClass({
	
	render: function () {
		return (
			<div className="SearchBar">
				<form onSubmit={this.onSubmit}>
					<SearchName />
					<SearchLocation />
					<SearchDatePicker />
					<button type="submit" className="primary">Search</button> 
				</form>
			</div>
		);
	},

	onSubmit: function () {
		console.log('submit SearchBar');
	},

})