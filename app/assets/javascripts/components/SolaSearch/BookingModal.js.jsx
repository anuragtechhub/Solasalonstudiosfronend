var BookingModal = React.createClass({

	render: function () {
		console.log('BookingModal', this.props);

		if (this.props.visible) {
			return (
				<div className="BookingModalOverlay">
					<div className="BookingModal">
						BOOKING MODAL
					</div>
				</div>
			);
		} else {
			return null;
		}
	}

});