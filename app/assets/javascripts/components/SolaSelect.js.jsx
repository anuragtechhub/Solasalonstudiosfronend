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
			} else {
				$(window).off('click.SolaSelect');
			}
		}
	},



	/**
	* Render functions
	*/

	render: function () {
		var self = this;
		var options = this.props.options.map(function (option) {
			if (!self.props.filteredBy || (self.props.filteredBy && option.filtered_by && self.props.filteredBy.toLowerCase() == option.filtered_by.toLowerCase())) {
				if (option.option_type == 'msa') {
					return <div key={option.value} className="optgroup"><h3>{option.value}</h3></div>
				} else if (option.option_type == 'location' || option.option_type == 'option') {
					return <div key={option.value.id} className="option" onClick={self.onSelectOption.bind(null, option.value.id, option.value.name)}>{option.value.name}</div>
				} else {
					return <div key={option} className="option" onClick={self.onSelectOption.bind(null, option, null)}>{option}</div>
				}
			}
		});

		return (
			<div className={"sola-select-wrapper " + this.props.className || ''}>
				<div className="sola-select no-autobind">
		      <div className="row" onClick={this.onToggle}>
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
		e.preventDefault();
		e.stopPropagation();

		this.setState({visible: this.state.visible ? false : true});
	},

});