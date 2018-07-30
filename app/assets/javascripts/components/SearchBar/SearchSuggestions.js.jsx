var SearchSuggestions = React.createClass({

	render: function () {
		return (
			<div className="SearchSuggestions">

			</div>
		);
	},

	renderHeader: function (header) {
		return (
			<h3>{header}</h3>
		);
	},

	renderSuggestion: function (suggestion) {
		return (
			<a key={suggestion.path} href={suggestion.path} className="suggestion">{suggestion.name}</a>
		);
	},

});