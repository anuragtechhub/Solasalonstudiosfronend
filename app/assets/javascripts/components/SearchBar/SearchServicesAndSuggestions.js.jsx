var SearchServicesAndSuggestions = React.createClass({

	getInitialState: function () {
		return {
			activeCategory: 'Barber',
			dropdownOpen: false,
			salons: null,
			professionals: null,
		};
	},

	componentDidUpdate: function (prevProps, prevState) {
		// open/close dropdown
		if (prevState.dropdownOpen != this.state.dropdownOpen) {
			if (this.state.dropdownOpen) {
				$(this.refs.dropdown).show();//.slideDown('fast');
				$(window).on('click.SearchServicesAndSuggestions', this.close);
			} else {
				$(this.refs.dropdown).hide();//.slideUp('fast');
				$(window).off('click.SearchServicesAndSuggestions');
			}
		}

		// bold filter text
		if (prevProps.query != this.props.query) {
			//console.log('the query has changed', this.props.query);

			$(this.refs.dropdown).find('a').wrapInTag({
			  tag: 'strong',
			  words: [this.props.query]
			});

			// only get suggestions when query is at least 2 characters
			if (this.props.query && this.props.query.length >= 2) {
				this.getSuggestions(this.props.query);
			}
		}
	},



	/*
	*	Render functions
	*/

	render: function () {
		return (
			<div className="SearchServicesAndSuggestions">
				<span className="fa fa-search">&nbsp;</span>
				<input ref="input" type="text" placeholder={I18n.t('sola_search.services_and_suggestions_placeholder')} onChange={this.onChange} onFocus={this.onFocus} value={this.props.query} />

				<div className="Dropdown" ref="dropdown">
					{this.props.query == '' ? this.renderAllCategoriesAndServices() : this.renderCategoriesAndServicesMatches()}
					{this.renderProfessionalsAndSalons()}
				</div>
			</div>
		);
	},

	renderCategoriesAndServicesMatches: function () {
		var self = this;
		var matches = [];
		var matchString = this.props.query.toLowerCase();

		for (var k in SolaSearchServices) {
			if (k.toLowerCase().indexOf(matchString) != -1) {
				// category match
				matches.push(
					<a key={k} href="#" data-category={k} className="service-match" onClick={self.onSelectService.bind(null, k)}>{k}</a>
				);

				// if category matches, then all sub-services match
				for (var j = 0, jlen = SolaSearchServices[k].length; j < jlen; j++) {
					matches.push(
						<a key={k + '_' + SolaSearchServices[k][j].name} href="#" onClick={self.onSelectService.bind(null, SolaSearchServices[k][j].name)} className="service-match" data-service={SolaSearchServices[k][j].name}>{SolaSearchServices[k][j].name} ({k})</a>
					);
				}
			} else {
				for (var j = 0, jlen = SolaSearchServices[k].length; j < jlen; j++) {
					if (SolaSearchServices[k][j].name.toLowerCase().indexOf(matchString) != -1) {
						matches.push(
							<a key={k + '_' + SolaSearchServices[k][j].name} href="#" onClick={self.onSelectService.bind(null, SolaSearchServices[k][j].name)} className="service-match" data-service={SolaSearchServices[k][j].name}>{SolaSearchServices[k][j].name}</a>
						);
					}
				}
			}
		}

		return (
			<div className="row">
				<div className="col-sm-12">
					<h4>{I18n.t('sola_search.services')}</h4>
					{matches}
				</div>
			</div>
		);
	},

	renderAllCategoriesAndServices: function () {
		//console.log('SearchServices', SolaSearchServices);
		var self = this;
		var categories = [];
		var services = []
		
		for (var k in SolaSearchServices) {
			categories.push(
				<a key={k} href="#" data-category={k} className={this.state.activeCategory == k ? 'active' : ''} onClick={this.onChangeActiveCategory}>{k}</a>
			);

			var category_services = SolaSearchServices[k].map(function (service) {
				return (
					<a key={service.name} href="#" data-service={service.name} onClick={self.onSelectService.bind(null, service.name)}>{service.name}</a>
				);
			});

			services.push(
				<div className={"service " + (this.state.activeCategory == k ? 'active' : '')} key={k} data-category={k}>
					{category_services}
				</div>
			);
		}

		return (
			<div className="row">
				<div className="col-sm-6">
					{categories}
				</div>
				<div className="col-sm-6 active">
					{services}
				</div>
			</div>
		);
	},

	renderProfessionalsAndSalons: function () {
		var professionals = this.renderProfessionals();
		var salons = this.renderSalons();

		if (professionals || salons) {
			return (
				<div className="professional-and-salon-suggestions">{professionals}{salons}</div>
			);
		} else {
			return null;
		}
	},

	renderProfessionals: function () {
		if (this.state.professionals && this.state.professionals.length > 0) {
			var professionals = this.state.professionals.map(function (professional) {
				return <a key={professional.booking_page_url} href={professional.booking_page_url}>{professional.full_name}</a>
			});

			return (
				<div className="row">
					<div className="col-sm-12 dropdown-section">
						<h4>{I18n.t('sola_search.professionals')}</h4>
						{professionals}
					</div>
				</div>
			);
		} else {
			return null;
		}
	},

	renderSalons: function () {
		if (this.state.salons && this.state.salons.length > 0) {
			var salons = this.state.salons.map(function (salon) {
				return <a key={salon.booking_page_url} href={salon.booking_page_url}>{salon.business_name}</a>
			});

			return (
				<div className="row">
					<div className="col-sm-12 dropdown-section">
						<h4>{I18n.t('sola_search.businesses')}</h4>
						{salons}
					</div>
				</div>
			);
		} else {
			return null;
		}
	},



	/*
	* Event handlers
	*/

	onChange: function (e) {
		//console.log('onChange', e.target.value);
		this.props.onChangeQuery(e.target.value)
	},

	onChangeActiveCategory: function (e) {
		//console.log('onChangeActiveCategory', e.target.dataset.category);
		e.preventDefault();
		e.stopPropagation();
		this.setState({activeCategory: e.target.dataset.category});
	},

	onFocus: function () {
		if (!this.state.dropdownOpen) {
			var $input = $(this.refs.input);
			var $window = $(window);
			console.log('open!', $input.width(), $window.width(), $window.height());
			this.setState({dropdownOpen: true, inputWidth: $input.width(), windowHeight: $window.height(), windowWidth: $window.width()});
		}
	},

	onSelectService: function (service, event) {
		event.preventDefault();
		this.setState({dropdownOpen: false});
		this.props.onChangeQuery(service);
	},



	/*
	* Helper functions
	*/

	close: function (e) {
		var $target = $(e.target);
		if (this.state.dropdownOpen && $target.parents('.SearchServicesAndSuggestions').length == 0) {
			this.setState({dropdownOpen: false});
		}
	},

	getSuggestions: function (query) {
		var self = this;

		//console.log('getSuggestions', query);
		
		$.ajax({
	    url: this.props.gloss_genius_api_url + 'suggestions?query=' + query,
	    headers: {
	    	"api_key": this.props.gloss_genius_api_key,
	    	"device_id": this.props.fingerprint,
	    }
		}).done(function (response) {
			var json_response = JSON.parse(response);
			var professionals = json_response.professionals;
			var salons = json_response.salons;
			self.setState({professionals: professionals, salons: salons});
		});
	},

});