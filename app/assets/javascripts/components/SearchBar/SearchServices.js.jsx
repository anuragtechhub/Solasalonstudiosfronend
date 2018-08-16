var SearchServices = React.createClass({

	getInitialState: function () {
		return {
			activeCategory: 'Barber',
			dropdownOpen: false,
			text: '',
		};
	},

	componentDidUpdate: function (prevProps, prevState) {
		if (prevState.dropdownOpen != this.state.dropdownOpen) {
			if (this.state.dropdownOpen) {
				$(this.refs.dropdown).slideDown('fast');
			} else {
				$(this.refs.dropdown).slideUp('fast');
			}
		}
	},



	/*
	*	Render functions
	*/

	render: function () {
		if (this.state.text && this.state.text != '') {
			
			return (
				<div className="SearchServices">
					<span className="fa fa-search">&nbsp;</span>
					<input ref="input" type="text" placeholder="Haircut" onChange={this.onChange} onFocus={this.onFocus} value={this.state.text} />

					<div className="Dropdown" ref="dropdown">
						<div className="row">
							<div className="col-sm-12">
								Filter by {this.state.text}
							</div>
						</div>
					</div>
				</div>
			);
		} else {
			var categories_and_services = this.renderCategoriesAndServices();

			return (
				<div className="SearchServices">
					<span className="fa fa-search">&nbsp;</span>
					<input ref="input" type="text" placeholder="Haircut" onChange={this.onChange} onFocus={this.onFocus} value={this.state.text} />

					<div className="Dropdown" ref="dropdown">
						<div className="row">
							<div className="col-sm-6">
								{categories_and_services[0]}
							</div>
							<div className="col-sm-6 active">
								{categories_and_services[1]}
							</div>
						</div>
					</div>
				</div>
			);
		}
	},

	renderCategoriesAndServices: function () {
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

		return [categories, services];
	},



	/*
	* Event handlers
	*/

	onChange: function (e) {
		console.log('onChange', e.target.value);
		this.setState({text: e.target.value});
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

});