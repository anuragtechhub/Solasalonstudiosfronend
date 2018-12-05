var BookingModalBody = React.createClass({

	render: function () {
		return (
			<div className="BookingModalBody">
				{this.props.error ? <div className="error">{this.props.error}</div> : null}
				{this.renderStep()}
			</div>
		);
	},

	renderStep: function () {
		if (this.props.step == 'review') {
			return <BookingModalReview {...this.props} />
		} else if (this.props.step == 'date') {
			return <BookingModalDate {...this.props} />		
		} else if (this.props.step == 'time') {
			return <BookingModalTime {...this.props} />	
		} else if (this.props.step == 'services') {
			return <BookingModalServices {...this.props} />								
		} else if (this.props.step == 'info') {
			return <BookingModalInfo {...this.props} />
		} else if (this.props.step == 'payment') {
			return <BookingModalPayment {...this.props} /> 
		} else { 
			return null;
		}
	},

});