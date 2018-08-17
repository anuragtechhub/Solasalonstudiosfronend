var SearchServices = React.createClass({

	getInitialState: function () {
		return {
			activeCategory: 'Barber',
			dropdownOpen: false,
		};
	},

	componentDidUpdate: function (prevProps, prevState) {
		// open/close dropdown
		if (prevState.dropdownOpen != this.state.dropdownOpen) {
			if (this.state.dropdownOpen) {
				$(this.refs.dropdown).show();//.slideDown('fast');
				$(window).on('click.SearchServices', this.close);
			} else {
				$(this.refs.dropdown).hide();//.slideUp('fast');
				$(window).off('click.SearchServices');
			}
		}

		// bold filter text
		if (prevProps.query != this.props.query) {
			$(this.refs.dropdown).find('a').wrapInTag({
			  tag: 'strong',
			  words: [this.props.query]
			});
		}
	},



	/*
	*	Render functions
	*/

	render: function () {
		return (
			<div className="SearchServices">
				<span className="fa fa-search">&nbsp;</span>
				<input ref="input" type="text" placeholder="Haircut, salon name, stylist name" onChange={this.onChange} onFocus={this.onFocus} value={this.props.query} />

				<div className="Dropdown" ref="dropdown">
					{this.props.query == '' ? this.renderAllCategoriesAndServices() : this.renderCategoriesAndServicesMatches()}
				</div>
			</div>
		);
	},

	renderCategoriesAndServicesMatches: function () {
		var matches = [];
		var matchString = this.props.query.toLowerCase();

		for (var k in SolaSearchServices) {
			if (k.toLowerCase().indexOf(matchString) != -1) {
				// category match
				matches.push(
					<a key={k} href="#" data-category={k} className={this.state.activeCategory == k ? 'active' : ''} onClick={this.onChangeActiveCategory}>{k}</a>
				);

				// if category matches, then all sub-services match
				for (var j = 0, jlen = SolaSearchServices[k].length; j < jlen; j++) {
					matches.push(
						<a key={SolaSearchServices[k][j].name} href="#" data-service={SolaSearchServices[k][j].name}>{SolaSearchServices[k][j].name} ({k})</a>
					);
				}
			} else {
				for (var j = 0, jlen = SolaSearchServices[k].length; j < jlen; j++) {
					if (SolaSearchServices[k][j].name.toLowerCase().indexOf(matchString) != -1) {
						matches.push(
							<a key={SolaSearchServices[k][j].name} href="#" data-service={SolaSearchServices[k][j].name}>{SolaSearchServices[k][j].name}</a>
						);
					}
				}
			}
		}

		return (
			<div className="row">
				<div className="col-sm-12">
					{matches}
				</div>
			</div>
		);
	},

	renderAllCategoriesAndServices: function () {
		//console.log('SearchServices', SolaSearchServices);
		var categories = [];
		var services = []
		
		for (var k in SolaSearchServices) {
			categories.push(
				<a key={k} href="#" data-category={k} className={this.state.activeCategory == k ? 'active' : ''} onClick={this.onChangeActiveCategory}>{k}</a>
			);

			var category_services = SolaSearchServices[k].map(function (service) {
				return (
					<a key={service.name} href="#" data-service={service.name}>{service.name}</a>
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



	/*
	* Event handlers
	*/

	onChange: function (e) {
		this.props.onChangeQuery(e.target.value)
	},

	onChangeActiveCategory: function (e) {
		e.preventDefault();
		e.stopPropagation();
		this.setState({activeCategory: e.target.dataset.category});
	},

	onFocus: function () {
		if (!this.state.dropdownOpen) {
			this.setState({dropdownOpen: true});
		}
	},



	/*
	* Helper functions
	*/

	close: function (e) {
		var $target = $(e.target);
		if (this.state.dropdownOpen && $target.parents('.SearchServices').length == 0) {
			this.setState({dropdownOpen: false});
		}
	},


});