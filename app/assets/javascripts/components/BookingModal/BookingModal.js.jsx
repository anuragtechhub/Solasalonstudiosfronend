var BookingModal = React.createClass({

	getInitialState: function () {
		return {
			fullHeight: false,
			fullWidth: false,
		}
	},

	componentDidMount: function () {
		var self = this;
		var $window = $(window);

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

	/**
	* Render functions
	*/

	render: function () {
		console.log('BookingModal', this.props);

		if (this.props.visible) {
			return (
				<div className="BookingModalOverlay" onClick={this.props.onHideBookingModal}>
					<div className={"BookingModal" + (this.state.fullHeight ? ' FullHeight ' : '') + (this.state.fullWidth ? ' FullWidth ' : '')} ref="BookingModal">
						{this.renderHeader()}
						{this.renderBody()}
						{this.renderFooter()}
					</div>
				</div>
			);
		} else {
			return null;
		}
	},

	renderBody: function () {
		return (
			<div className="BookingModalBody">
				BODY
			</div>
		);
	},

	renderFooter: function () {
		return (
			<div className="BookingModalFooter">
				FOOTER
			</div>
		);
	},

	renderHeader: function () {
		return (
			<div className="BookingModalHeader">
				{I18n.t('sola_search.book_appointment')}
				<div className="close-x"><span className="fa fa-2x fa-times-thin" onClick={this.props.onHideBookingModal}></span></div>
			</div>
		);
	},

});