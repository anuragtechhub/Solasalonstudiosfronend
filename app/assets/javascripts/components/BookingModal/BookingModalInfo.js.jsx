var BookingModalInfo = React.createClass({

	render: function () {

		return (
			<div className="BookingModalInfo">
				<div className="Body">
					<h2>{I18n.t('sola_search.your_information')}</h2>

					<div className="InputRow">
						<input type="text" name="your_name" placeholder={I18n.t('sola_search.your_name')} onChange={this.props.onChange} value={this.props.your_name} />
					</div>
					<div className="InputRow">
						<input type="text" name="email_address" placeholder={I18n.t('sola_search.email_address')} onChange={this.props.onChange} value={this.props.email_address} />
					</div>
					<div className="InputRow">
						<input type="text" name="phone_number" placeholder={I18n.t('sola_search.phone_number')} onChange={this.props.onChange} value={this.props.phone_number} />
					</div>

				</div>
			</div>
		);
	},



	/**
	* Helper functions 
	*/



});