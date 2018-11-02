var ProfessionalResults = React.createClass({
	
	render: function () {
		var self = this;

		var professionals = this.props.professionals.map(function (professional) {
			return <ProfessionalResult key={professional.booking_page_url} {...professional} availabilities={self.getAvailabilities(professional)} onShowBookingModal={self.props.onShowBookingModal} professional={professional} />
		});

		return (
			<div className="ProfessionalResults">
				<div className="SolaSearchBar">
					{
						this.props.location_id && this.props.location_name 
						?
						<div>
							<div className="BackButton" onClick={this.onGoBack}>
								<div className="fa fa-chevron-left">&nbsp;</div> <div className="back">{I18n.t('sola_search.back')}</div>
							</div>
							<div className="LocationName">{this.props.location_name}</div> 
						</div>
						:
						<SearchBar 
							date={this.props.date}
							lat={this.props.lat}
							lng={this.props.lng}
							location={this.props.location} 
							location_id={this.props.location_id}
							path={this.props.stylist_search_results_path} 
							query={this.props.query} 
						/>
					}
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
				// if (i == '15797e93f8') {
				// 	console.log('kimmie', professional, this.props.availabilities[i]);
				// }
				return this.props.availabilities[i];
			}
		}
	},

	onGoBack: function () {
		window.history.back();
	},

});