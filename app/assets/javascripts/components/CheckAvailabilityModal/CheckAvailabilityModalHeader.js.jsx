var CheckAvailabilityModalHeader = React.createClass({

	render: function () {
		return (
			<div className="CheckAvailabilityModalHeader">
				{this.renderBackButton()}
				{this.renderText()}
				<div className="close-x"><span className="fa fa-2x fa-times-thin HideBookingModal" onClick={this.props.onHideBookingModal}></span></div>
			</div>
		);
	},

	renderText: function () {
		if (this.props.step == 'date') {
			return I18n.t('sola_search.select_a_date');
		} else if (this.props.step == 'time') {
			return I18n.t('sola_search.select_a_time');
		} else if (this.props.step == 'services') {
			return I18n.t('sola_search.services');			
		} else {
			return I18n.t('sola_search.book_appointment');
		}
	},

	renderBackButton: function () {
		if (this.props.step == 'info') {
			return <span className="fa fa-chevron-left BackButton" onClick={this.props.onBack}>&nbsp;</span>
		} else if (this.props.step == 'date') {
			return <span className="fa fa-chevron-left BackButton" onClick={this.props.onBack}>&nbsp;</span>	
		} else if (this.props.step == 'time') {
			return <span className="fa fa-chevron-left BackButton" onClick={this.props.onBack}>&nbsp;</span>
		} else if (this.props.step == 'services') {
			return <span className="fa fa-chevron-left BackButton" onClick={this.props.onBack}>&nbsp;</span>			
		} else if (this.props.step == 'payment') {
			return <span className="fa fa-chevron-left BackButton" onClick={this.props.onBack}>&nbsp;</span>
		} else {
			return null;
		}
	},

});