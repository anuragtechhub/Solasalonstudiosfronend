var ProfessionalResults = React.createClass({
	
	render: function () {
		var self = this;

		var professionals = this.props.professionals.map(function (professional) {
			var availabilities = self.getAvailabilities(professional);
			if (availabilities && availabilities.length) {
				return <ProfessionalResult 
								key={professional.booking_page_url} 
								{...professional} 
								availabilities={availabilities} 
								date={self.props.date}
								fingerprint={self.props.fingerprint}
								gloss_genius_api_key={self.props.gloss_genius_api_key}
								gloss_genius_api_url={self.props.gloss_genius_api_url}
								onShowBookingModal={self.props.onShowBookingModal} 
								professional={professional} />
			}
		});

		var professionals_with_no_availability = this.props.professionals.map(function (professional) {
			var availabilities = self.getAvailabilities(professional);
			if (availabilities && availabilities.length == 0) {
				return <ProfessionalResult 
								key={professional.booking_page_url} 
								{...professional} 
								availabilities={availabilities} 
								date={self.props.date}
								fingerprint={self.props.fingerprint}
								gloss_genius_api_key={self.props.gloss_genius_api_key}
								gloss_genius_api_url={self.props.gloss_genius_api_url}
								onShowBookingModal={self.props.onShowBookingModal} 
								professional={professional} />
			}
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
							gloss_genius_api_key={this.props.gloss_genius_api_key}
							gloss_genius_api_url={this.props.gloss_genius_api_url}
							lat={this.props.lat}
							lng={this.props.lng}
							location={this.props.location} 
							location_id={this.props.location_id}
							path={this.props.results_path} 
							query={this.props.query} 
						/>
					}
					<div className="SearchResultsCount" style={{display: 'none'}}>{professionals.length} {I18n.t('sola_search.professionals_for_query', {query: this.props.query})}</div>
				</div>
				{professionals}
				{professionals_with_no_availability}
				{this.renderPagination()}
			</div>
		);
	},

	renderPagination: function () {
		if (this.props.end_of_results && this.props.professionals.length > 0) {
			//console.log('renderPagination END OF RESULTS');
			return (
				<div className="SearchPagination text-center">
					<em style={{fontSize: 15, color: '#AFAFAF', display: 'block', margin: '30px 0'}}>{I18n.t('sola_search.end_of_results')}</em>
				</div>
			);
		} else if (this.props.professionals.length == 0) {
			return (
				<div className="SearchPagination text-center">
					<div className="no-results">
						<img className="no-results-icon" src="//solasalonstudios.s3.amazonaws.com/book_now_no_results.png" />
						<h2>{I18n.t('sola_search.please_try_your_search_again')}</h2>
						<h3>{I18n.t('sola_search.unable_to_find_results')}</h3>
						<div>
							<a href={this.props.booknow_search_path} className="btn">{I18n.t('sola_search.search_again')}</a>
						</div>						
						<p className="first" dangerouslySetInnerHTML={{__html: I18n.t('sola_search.no_results_note_1')}}></p>
						<p><a href={this.props.find_a_salon_pro_path}>{I18n.t('sola_search.browse_all_sola_beauty_professionals')}</a></p>
					</div>
				</div>
			);
		} else {
			//console.log('renderPagination RENDER SEARCH PAGINATION');
			return (
				<div className="SearchPagination">
					<button type="button" className="button primary ga-et" data-gcategory="BookNow" data-gaction="Load More" data-glabel={JSON.stringify({
						date: this.props.date.format('YYYY-MM-DD'),
						lat: this.props.lat,
						lng: this.props.lng,
						location_id: this.props.location_id,
						location: this.props.location,
						query: this.props.query,
						search_after: this.props.professionals[this.props.professionals.length - 1].cursor,
						fingerprint: this.props.fingerprint,
					})} onClick={this.props.onLoadMoreProfessionals}>{I18n.t('sola_search.load_more_professionals')}</button>
					{this.props.loading ? <div className="loading"><div className="spinner spinner-sm"></div></div> : null}
				</div>
			);
		}
	},

	getAvailabilities: function (professional) {
		//console.log('getAvailabilities', professional.guid, this.props.availabilities);
		for (var i in this.props.availabilities) {
			//console.log('i', i);
			if (i == professional.guid) {
				// if (i == '15797e93f8') {
				// 	console.log('kimmie', professional, this.props.availabilities[i]);
				// }
				//console.log('availabilities', this.props.availabilities[i]);
				return this.props.availabilities[i];
			}
		}
	},

	onGoBack: function () {
		window.history.back();
	},

});