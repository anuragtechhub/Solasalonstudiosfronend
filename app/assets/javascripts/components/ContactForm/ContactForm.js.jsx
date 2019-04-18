var ContactForm = React.createClass({

	getInitialState: function () {
		return {
			selected_state: this.props.selected_state,
		};
	},



	/**
	* Render functions
	*/

	render: function () {
		console.log('render ContactForm', this.props);
		
		return (
			<div className="contact-form">
				<h2>{I18n.t('contact_form.contact_a_sola_near_you')}</h2>

				<form onSubmit={this.onSubmit}>
					<SolaSelect placeholder={I18n.t('contact_form.select_a_state')} options={this.props.all_states} value={this.state.selected_state} onChange={this.onChangeSelectedState} />

					<div className="form-group">
						<input className="form-control" name="name" type="text" placeholder={I18n.t("contact_form.your_name")} /> 
					</div>
					<div className="form-group">
						<input className="form-control" name="email" type="text" placeholder={I18n.t("contact_form.email_address")} />
					</div>
					<div className="form-group"> 
						<input className="form-control" name="phone" type="text" placeholder={I18n.t("contact_form.phone_number")} /> 
					</div>
					<div className="form-group">
						<textarea className="form-control" name="message" placeholder={I18n.t("contact_form.leave_a_message")}></textarea> 
					</div>
					<button className="button block primary">{I18n.t("contact_form.submit_message")}</button>
				</form>
			</div>
		);
	},



	/**
	* Change handlers
	*/

	onChangeSelectedState: function (value) {
		console.log('onChangeSelectedState', value);
		this.setState({selected_state: value});
	}, 

	onSubmit: function (e) {
		e.preventDefault();
		e.stopPropagation();

		console.log('onSubmit yo');
	},

});