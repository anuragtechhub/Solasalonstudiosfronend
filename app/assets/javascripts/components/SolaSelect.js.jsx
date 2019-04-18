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
			return <div key={option} className="option" data-value={option} onClick={self.onSelectOption.bind(null, option)}>{option}</div>
		});

		return (
			<div className="sola-select no-autobind select-a-state form">
	      <div className="row" onClick={this.onToggle}>
	        <div className="option-placeholder"><h3>{this.props.value || this.props.placeholder}</h3></div>
	        <div className="arrow"><span className="ss-dropdown"></span></div>
	      </div>
	      <div className="options" style={{display: this.state.visible ? 'block' : 'none'}}>
	      	{options}
	      </div>
	    </div>
		);
	},



	/**
	* Change handlers
	*/

	onSelectOption: function (option, e) {
		e.preventDefault();
		e.stopPropagation();

		console.log('onSelectOption', option);
		
		if (typeof this.props.onChange == 'function') {
			this.props.onChange(option);
			this.setState({visible: false});
		}
	},

	onToggle: function (e) {
		e.preventDefault();
		e.stopPropagation();

		this.setState({visible: this.state.visible ? false : true});
	},

});