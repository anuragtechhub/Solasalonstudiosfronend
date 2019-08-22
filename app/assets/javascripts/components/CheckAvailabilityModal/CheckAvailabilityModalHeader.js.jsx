var CheckAvailabilityModalHeader = React.createClass({

	render: function () {
		return (
			<div className="CheckAvailabilityModalHeader">
				{I18n.t('sola_search.check_availability')}
				<div className="close-x"><span className="fa fa-2x fa-times-thin HideCheckAvailabilityModal" onClick={this.props.onHideCheckAvailabilityModal}></span></div>
			</div>
		);
	},

});