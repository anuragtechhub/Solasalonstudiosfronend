var BookingModalBody = React.createClass({

	render: function () {
		return (
			<div className="BookingModalBody">
				{this.renderStep()}
			</div>
		);
	},

	renderStep: function () {
		if (this.props.step == 'review') {
			return <BookingModalReview {...this.props} />
		} else if (this.props.step == 'info') {
			return <BookingModalInfo {...this.props} />
		} else if (this.props.step == 'payment') {
			return <BookingModalPayment {...this.props} /> 
		} else { 
			return null;
		}
	},

});