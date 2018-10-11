var BookingModal = React.createClass({

	getInitialState: function () {
		return {
			email_address: '',
			fullHeight: false,
			fullWidth: false,
			loading: false,
			phone_number: '',
			step: this.props.step || 'review',
			your_name: '',
		}
	},

	componentDidMount: function () {
		var self = this;
		var $window = $(window);

		// handle booking modal sizing
		$window.on('resize.BookingModal', function () {
			var width = $window.width();
			var height = $window.height();
			var fullWidth = width <= 600;
			var fullHeight = height <= 600;

			//console.log('window', width, height, 'BookingModal', b_width, b_height);

			if (fullWidth != self.state.fullWidth || fullHeight != self.state.fullHeight) {
				self.setState({fullHeight: fullHeight, fullWidth: fullWidth});
			}
		}).trigger('resize.BookingModal');
	},

	componentWillReceiveProps: function (nextProps) {
		if (nextProps.step != this.state.step) {
			this.setState({step: nextProps.step});
		}
	},

	componentDidUpdate: function () {
		// disable / enable scrolling
		if (this.props.visible) {
			$('html, body').css({
			    overflow: 'hidden',
			    height: '100%'
			});
		} else {
			$('html, body').css({
			    overflow: 'auto',
			    height: 'auto'
			});
		}
	},



	/**
	* Render functions
	*/

	render: function () {
		//console.log('BookingModal', this.props.step);

		if (this.props.visible) {
			return (
				<div className="BookingModalOverlay HideBookingModal" onClick={this.props.onHideBookingModal}>
					<div className={"BookingModal" + (this.state.fullHeight ? ' FullHeight ' : '') + (this.state.fullWidth ? ' FullWidth ' : '')} ref="BookingModal">
						<BookingModalHeader {...this.props} {...this.state} onBack={this.onBack} />
						<BookingModalBody {...this.props} {...this.state} onChange={this.onChange} />
						<BookingModalFooter {...this.props} {...this.state} onSubmit={this.onSubmit} />
						{this.state.loading ? <div className="loading"><div className="spinner"></div></div> : null}
					</div>
				</div>
			);
		} else {
			return null;
		}
	},



	/**
	* Change handlers
	*/

	onBack: function () {
		if (this.state.step == 'info') {
			this.setState({step: 'review'});
		} else if (this.state.step == 'payment') {
			this.setState({step: 'info'});
		}
	},

	onChange: function (e) {
		if (e && e.target) {
			//console.log('onChange', e.target.name, e.target.value);
			this.state[e.target.name] = e.target.value;
			this.setState(this.state);
		}
	},

	onSubmit: function (e) {
		//console.log('onSubmit!');

		if (e && e.preventDefault && e.stopPropagation) {
			e.preventDefault();
			e.stopPropagation();
		}

		if (this.state.step == 'review') {
			this.setState({step: 'info'});
		} else if (this.state.step == 'info') {
			this.setState({step: 'payment'});
		} else if (this.state.step == 'payment') {
			alert('redirect to payment success screen!');
		}
	},

});