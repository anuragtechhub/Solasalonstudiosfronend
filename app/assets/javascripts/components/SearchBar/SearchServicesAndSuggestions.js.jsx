var SearchServicesAndSuggestions = React.createClass({

	getInitialState: function () {
		return {
			activeCategory: 'Barber',
			dropdownOpen: false,
			salons: null,
			tempQuery: this.props.query,
			professionals: null,
		};
	},

	componentDidUpdate: function (prevProps, prevState) {
		var matches = $(this.refs.dropdown).find('.service-match, .professional-match, .business-match').length;

		//console.log('matches', matches);

		// open/close dropdown
		if (prevState.dropdownOpen != this.state.dropdownOpen) {
			if (this.state.dropdownOpen) {
				//console.log('1show dropdown')
				$(this.refs.dropdown).show();//.slideDown('fast');
				$(window).on('click.SearchServicesAndSuggestions', this.close);
			} else {
				//console.log('1hide dropdown')
				this.setState({tempQuery: ''});
				$(this.refs.dropdown).hide();//.slideUp('fast');
				$(window).off('click.SearchServicesAndSuggestions');
			}
		} else {
			if (matches == 0 && this.state.tempQuery != '') {
				//console.log('2hide dropdown')
				$(this.refs.dropdown).hide();
			} else if (matches > 0 && this.state.dropdownOpen) {
				//console.log('2show dropdown')
				$(this.refs.dropdown).show();
			}
		}

		// bold filter text
		if (prevProps.query != this.props.query) {
			//console.log('the query has changed', this.props.query);

			// $(this.refs.dropdown).find('a').wrapInTag({
			//   tag: 'strong',
			//   words: [this.props.query]
			// });

			// only get suggestions when query is at least 2 characters
			if (this.props.query && this.props.query.length >= 2) {
				this.getSuggestions(this.props.query);
			}
		}

		// position services-list
		if (this.refs['categories-list']) {
			// var $dropdown = $(this.refs.dropdown);
			// var $activeCategory = $(this.refs['categories-list']).find('.active');
			// var activeCategoryOffset = $activeCategory.offset();
			// var activeCategoryPosition = $activeCategory.position();
			// console.log('activeCategory offset/position', activeCategoryOffset, activeCategoryPosition);
			// console.log('scrollHeight', this.refs['categories-list'].scrollHeight);
			// console.log('dropdown scrolltop', $(this.refs.dropdown).scrollTop());
			$(this.refs['services-list']).find('.services-list').css({top: $(this.refs.dropdown).scrollTop() + 'px'});
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
				{this.state.tempQuery != '' || this.props.query != '' ? <span className="fa fa-times" onClick={this.clearInput}>&nbsp;</span> : null}
				<div className="Dropdown" ref="dropdown">
					{this.state.tempQuery == '' ? this.renderAllCategoriesAndServices() : this.renderCategoriesAndServicesMatches()}
					{this.renderProfessionalsAndSalons()}
				</div>
			</div>
		);
	},

	renderCategoriesAndServicesMatches: function () {
		var self = this;
		var matches = [];
		var matched_services = [];
		var matchString = this.props.query.toLowerCase();

		for (var k in SolaSearchServices) {
			if (k.toLowerCase().indexOf(matchString) != -1 || k.toLowerCase().replace(/[^a-zA-Z ]/, '').indexOf(matchString) != -1) {
				// category match
				matches.push(
					<a key={k} href="#" data-category={k} className="service-match" onClick={self.onSelectService.bind(null, k)}><HighlightText words={[self.props.query]}>{k}</HighlightText></a>
				);

				// if category matches, then all sub-services match
				for (var j = 0, jlen = SolaSearchServices[k].length; j < jlen; j++) {
					if (matched_services.indexOf(SolaSearchServices[k][j].name) == -1) {
						matched_services.push(SolaSearchServices[k][j].name);
						matches.push(
							<a key={k + '_' + SolaSearchServices[k][j].name} href="#" onClick={self.onSelectService.bind(null, SolaSearchServices[k][j].value || SolaSearchServices[k][j].name)} className="service-match" data-service={SolaSearchServices[k][j].value || SolaSearchServices[k][j].name}><HighlightText words={[self.props.query]}>{SolaSearchServices[k][j].name} ({k})</HighlightText></a>
						);
					}
				}
			} else {
				for (var j = 0, jlen = SolaSearchServices[k].length; j < jlen; j++) {
					if (SolaSearchServices[k][j].name.toLowerCase().indexOf(matchString) != -1 || SolaSearchServices[k][j].name.toLowerCase().replace(/[^a-zA-Z ]/, '').indexOf(matchString) != -1) {
						if (matched_services.indexOf(SolaSearchServices[k][j].name) == -1) {
							matched_services.push(SolaSearchServices[k][j].name);
							matches.push(
								<a key={k + '_' + SolaSearchServices[k][j].name} href="#" onClick={self.onSelectService.bind(null, SolaSearchServices[k][j].value || SolaSearchServices[k][j].name)} className="service-match" data-service={SolaSearchServices[k][j].value || SolaSearchServices[k][j].name}><HighlightText words={[self.props.query]}>{SolaSearchServices[k][j].name}</HighlightText></a>
							);
						}
					}
				}
			}
		}

		return (
			<div className="row" ref="matches" data-matches={matches.length}>
				<div className="col-sm-12">
					{	
						matches.length > 0
						?
						<div>
							<h4>{I18n.t('sola_search.services')}</h4>
							{matches}
						</div>
						:
						<div className="text-center">
							{/*<em style={{fontSize: 15, color: '#AFAFAF', display: 'block', margin: '30px 0'}}>{I18n.t('sola_search.no_results')}</em>*/}
						</div>
					}
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
				<a key={k} href="#" data-category={k} className={this.state.activeCategory == k ? 'active' : ''} onClick={self.onChangeActiveCategory.bind(null, k)}><HighlightText words={[self.props.query]}>{k}</HighlightText></a>
			);

			var category_services = SolaSearchServices[k].map(function (service) {
				return (
					<a key={service.name} href="#" data-service={service.value || service.name} onClick={self.onSelectService.bind(null, service.value || service.name)}><HighlightText words={[self.props.query]}>{service.name}</HighlightText></a>
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
				<div className="col-sm-6" ref="categories-list">
					{categories}
				</div>
				<div className="col-sm-6 services-list-wrapper active" ref="services-list">
					<div className="services-list">
						{services}
					</div>
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
		var self = this;
		if (this.state.professionals && this.state.professionals.length > 0) {
			var professionals = this.state.professionals.map(function (professional) {
				return <a key={professional.booking_page_url} href={'//' + professional.booking_page_url} className="professional-match"><HighlightText words={[self.props.query]}>{professional.full_name}</HighlightText></a>
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
				return <a key={salon.booking_page_url} href={'//' + salon.booking_page_url} className="business-match">{salon.business_name}</a>
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

	clearInput: function () {
		this.setState({tempQuery: ''});
		this.props.onChangeQuery('');
	},

	onChange: function (e) {
		//console.log('onChange', e.target.value);
		this.setState({tempQuery: e.target.value});
		this.props.onChangeQuery(e.target.value)
	},

	onChangeActiveCategory: function (category, e) {
		//console.log('onChangeActiveCategory', category, e.target.dataset.category);
		e.preventDefault();
		e.stopPropagation();
		this.setState({activeCategory: category});
	},

	onFocus: function () {
		if (!this.state.dropdownOpen) {
			// select text
			this.refs.input.select();

			// get sizes for responsiveness
			var $input = $();
			var $window = $(window);
			//console.log('open!', $input.width(), $window.width(), $window.height());
			this.setState({dropdownOpen: true, inputWidth: $input.width(), windowHeight: $window.height(), windowWidth: $window.width()});
		}
	},

	onSelectService: function (service, event) {
		event.preventDefault();
		//console.log('onSelectService', service);
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