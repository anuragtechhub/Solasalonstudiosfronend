var ProfessionalResults = React.createClass({
	
	render: function () {
		var self = this;

		var professionals = this.props.professionals.map(function (professional) {
			return <ProfessionalResult key={professional.booking_page_url} {...professional} availabilities={self.getAvailabilities(professional)} />
		});

		return (
			<div className="ProfessionalResults">
				<div className="SolaSearchBar">
					<SearchBar date={this.props.date} path={this.props.stylist_search_results_path} />
					<div className="SearchResultsCount">{professionals.length} {I18n.t('sola_search.professionals_for_query', {query: this.props.query})}</div>
				</div>
				{professionals}
			</div>
		);
	},

	getAvailabilities: function (professional) {
		//console.log('getAvailabilities', professional.guid, this.props.availabilities);
		for (var i in this.props.availabilities) {
			//console.log('i', i);
			if (i == professional.guid) {
				return this.props.availabilities[i];
			}
		}
	},

});