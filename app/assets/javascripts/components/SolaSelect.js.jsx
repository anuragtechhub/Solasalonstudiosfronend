var SolaSelect = React.createClass({

	getInitialState: function () {
		return {
			//value: this.props.value,
			visible: this.props.visible,
		};
	},

	componentDidUpdate: function (prevProps, prevState) {
		var self = this;

		// window click handler
		if (prevState.visible != this.state.visible) {
			if (this.state.visible) {
				$(window).on('click.SolaSelect', function () {
					self.setState({visible: false});
				});
				// $(window).on('keydown.SolaSelect', function (e) {
				// 	if (e.keyCode == 40) {
				// 		e.preventDefault();
				// 		e.stopPropagation();
				// 		console.log('down');
				// 	} else if (e.keyCode == 38) {
				// 		e.preventDefault();
				// 		e.stopPropagation();
				// 		console.log('up');
				// 	}
				// });
			} else {
				$(window).off('click.SolaSelect');
				//$(window).off('keydown.SolaSelect');
			}
		}
	},



	/**
	* Render functions
	*/

	render: function () {
		var self = this;
		var options = this.props.options.map(function (option) {
			//console.log('filteredBy', self.props.filteredBy, option);
			if (!self.props.filteredBy || (self.props.filteredBy && option.filtered_by && self.props.filteredBy.trim().toLowerCase() == option.filtered_by.trim().toLowerCase())) {
				//console.log('match')
				if (option.option_type == 'msa') {
					return <div key={option.value} className="optgroup"><h3>{option.value}</h3></div>
				} else if (option.option_type == 'location' || option.option_type == 'option') {
					return <div key={option.value.id} className="option" onClick={self.onSelectOption.bind(null, option.value.id, option.value.name)}>{option.value.name}</div>
				} else {
					return <div key={option} className="option" onClick={self.onSelectOption.bind(null, option, null)}>{option}</div>
				}
			} else {
				//console.log('no match', self.props.filteredBy.trim().toLowerCase(), option.filtered_by.trim().toLowerCase(), self.props.filteredBy.trim().toLowerCase() == option.filtered_by.trim().toLowerCase())
			}
		}).filter(function (el) {
		  return el != null;
		});

		//console.log('options', options);

		return (
			<div className={"sola-select-wrapper " + this.props.className || ''} style={{display: options.length > 0 ? 'block' : 'none'}}>
				<div className="sola-select no-autobind">
		      <div className="row" onClick={this.onToggle} tabIndex={typeof this.props.tabIndex != 'undefined' ? this.props.tabIndex : ''}>
		        <div className="option-placeholder"><h3>{this.props.displayName && this.props.name ? this.props.name : (this.props.value || this.props.placeholder)}</h3></div>
		        <div className="arrow"><span className="ss-dropdown"></span></div>
		      </div>
		      <div className="options" style={{display: this.state.visible ? 'block' : 'none'}}>
		      	{options}
		      </div>
		    </div>
	    </div>
		);
	},



	/**
	* Change handlers
	*/

	onSelectOption: function (value, name, e) {
		e.preventDefault();
		e.stopPropagation();
		
		if (typeof this.props.onChange == 'function') {
			this.props.onChange(value, name);
			this.setState({visible: false});
		}
	},

	onToggle: function (e) {
		var self = this;

		e.preventDefault();
		e.stopPropagation();

		//console.log('ontoggle');
		if (!this.state.visible) {
			$(window).trigger('click.SolaSelect');
		}

		this.setState({visible: this.state.visible ? false : true}, function () {
		});
	},

});