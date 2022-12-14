var BookingModalInfo = React.createClass({

	componentDidMount: function () {
		new Nebo15Mask.MaskedInput(this.refs.phone_number, "(111) 111-1111", {
			eventsToHandle: [],
		});
	},

	render: function () {

		return (
			<div className="BookingModalInfo">
				<div className="Body">
					<h2>{I18n.t('sola_search.your_information')}</h2>
					<form onSubmit={this.props.onSubmit}>
						<div className="InputRow">
							<input type="text" name="your_name" placeholder={I18n.t('sola_search.your_name')} onChange={this.props.onChange} value={this.props.your_name} />
						</div>
						<div className="InputRow">
							<input type="text" name="email_address" placeholder={I18n.t('sola_search.email_address')} onChange={this.props.onChange} value={this.props.email_address} />
						</div>
						<div className="InputRow">
							<input type="text" ref="phone_number" mask="1111 1111 1111 1111" name="phone_number" placeholder={I18n.t('sola_search.phone_number')} onBlur={this.onBlur} onChange={this.props.onChange} value={this.props.phone_number} />
						</div>
						<input type="submit" style={{display: 'none'}} />
					</form>
				</div>
			</div>
		);
	},



	onBlur: function (e) {
		this.props.onChange(e);
	}


});