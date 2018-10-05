var BookingModal = React.createClass({

	getInitialState: function () {
		return {
			fullHeight: false,
			fullWidth: false,
			step: 'review',
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
		});
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
		console.log('BookingModal', this.props);

		if (this.props.visible) {
			return (
				<div className="BookingModalOverlay" onClick={this.props.onHideBookingModal}>
					<div className={"BookingModal" + (this.state.fullHeight ? ' FullHeight ' : '') + (this.state.fullWidth ? ' FullWidth ' : '')} ref="BookingModal">
						<BookingModalHeader {...this.props} {...this.state} />
						<BookingModalBody {...this.props} {...this.state} />
						<BookingModalFooter {...this.props} {...this.state} />
					</div>
				</div>
			);
		} else {
			return null;
		}
	},

});