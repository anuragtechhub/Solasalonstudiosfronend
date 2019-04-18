var ContactForm = React.createClass({



	/**
	* Render functions
	*/

	render: function () {
		return (
			<div className="contact-form">
				<form onSubmit={this.onSubmit}>
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
	onSubmit: function (e) {
		e.preventDefault();
		e.stopPropagation();

		console.log('onSubmit yo');
	},

});