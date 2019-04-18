var ContactForm = React.createClass({

	getInitialState: function () {
		return {
			selected_location: this.props.selected_location,
			selected_location_name: this.props.selected_location_name,
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

				<form onSubmit={this.onSubmit} disabled={!this.state.selected_state || !this.state.selected_location}>
					<SolaSelect placeholder={I18n.t('contact_form.select_a_state')} options={this.props.all_states} value={this.state.selected_state} onChange={this.onChangeSelectedState} />
					
					{
						this.state.selected_state 
						? 
						<SolaSelect className="location-select" displayName={true} placeholder={I18n.t('contact_form.select_a_location')} options={this.props.all_locations} name={this.state.selected_location_name} value={this.state.selected_location} onChange={this.onChangeSelectedLocation} /> 
						: 
						null
					}

					<div className="form-group">
						<input className="form-control" name="name" type="text" placeholder={I18n.t("contact_form.your_name")} disabled={!this.state.selected_state || !this.state.selected_location} /> 
					</div>
					<div className="form-group">
						<input className="form-control" name="email" type="text" placeholder={I18n.t("contact_form.email_address")} disabled={!this.state.selected_state || !this.state.selected_location} />
					</div>
					<div className="form-group"> 
						<input className="form-control" name="phone" type="text" placeholder={I18n.t("contact_form.phone_number")} disabled={!this.state.selected_state || !this.state.selected_location} /> 
					</div>
					<div className="form-group">
						<textarea className="form-control" name="message" placeholder={I18n.t("contact_form.leave_a_message")} disabled={!this.state.selected_state || !this.state.selected_location}></textarea> 
					</div>
					<button className="button block primary" disabled={!this.state.selected_state || !this.state.selected_location}>{I18n.t("contact_form.submit_message")}</button>
				</form>
			</div>
		);
	},



	/**
	* Change handlers
	*/

	onChangeSelectedLocation: function (value, name) {
		//console.log('onChangeSelectedLocation', value, name);
		this.setState({selected_location: value, selected_location_name: name});
	}, 

	onChangeSelectedState: function (value) {
		//console.log('onChangeSelectedState', value);
		this.setState({selected_state: value});
	}, 

	onSubmit: function (e) {
		e.preventDefault();
		e.stopPropagation();

		console.log('onSubmit yo');
	},

});