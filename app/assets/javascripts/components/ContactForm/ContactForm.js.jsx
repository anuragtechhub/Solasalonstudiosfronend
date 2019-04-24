var ContactForm = React.createClass({

	getInitialState: function () {
		return {
			name: '',
			email: '',
			contact_preference: '',
			phone: '',
			message: '',
			error: null,
			success: null,
			loading: false,
			selected_location: this.props.selected_location,
			selected_location_name: this.props.selected_location_name,
			selected_state: this.props.selected_state,
		};
	},

	componentDidMount: function () {
		$(this.refs.first_input).tooltipster({theme: 'tooltipster-noir', timer: 4000, trigger: 'foo'});
	},

	componentDidUpdate: function (prevProps, prevState) {
		if (this.state.success && prevState.success != this.state.success) {
			$(this.refs.first_input).tooltipster('content', this.state.success).tooltipster('show');
		} else if (this.state.error && prevState.error != this.state.error) {
			$(this.refs.first_input).tooltipster('content', this.state.error).tooltipster('show');
		}
	},



	/**
	* Render functions
	*/

	render: function () {
		//console.log('render ContactForm', this.props);
		
		return (
			<div className={"contact-form " + (this.state.selected_state ? 'full-height' : '')}>
				<h2>{I18n.t('contact_form.contact_a_sola_near_you')}</h2>

				<form onSubmit={this.onSubmit} disabled={!this.state.selected_state || !this.state.selected_location} ref="form">
					<SolaSelect placeholder={I18n.t('contact_form.select_a_state')} options={this.props.all_states} value={this.state.selected_state} onChange={this.onChangeSelectedState} />
					
					{
						this.state.selected_state 
						? 
						<SolaSelect className="location-select" 
												displayName={true} 
												filteredBy={this.state.selected_state}
												placeholder={I18n.t('contact_form.select_a_location')} 
												options={this.props.all_locations} 
												name={this.state.selected_location_name} 
												value={this.state.selected_location} 
												onChange={this.onChangeSelectedLocation} /> 
						: 
						null
					}

					<div className="form-group" ref="first_input">
						<input className="form-control" name="name" value={this.state.name} onChange={this.onChangeInput} type="text" placeholder={I18n.t("contact_form.your_name")} disabled={!this.state.selected_state || !this.state.selected_location} /> 
					</div>
					<div className="form-group">
						<input className="form-control" name="email" value={this.state.email} onChange={this.onChangeInput} type="text" placeholder={I18n.t("contact_form.email_address")} disabled={!this.state.selected_state || !this.state.selected_location} />
					</div>
					<div className="form-group"> 
						<input className="form-control" name="phone" value={this.state.phone} onChange={this.onChangeInput} type="text" placeholder={I18n.t("contact_form.phone_number")} disabled={!this.state.selected_state || !this.state.selected_location} /> 
					</div>
					<div className="form-group">
						<textarea className="form-control" name="message" value={this.state.message} onChange={this.onChangeInput} placeholder={I18n.t("contact_form.leave_a_message")} disabled={!this.state.selected_state || !this.state.selected_location}></textarea> 
					</div>
					<div className={"form-group contact-preference " + (!this.state.selected_state || !this.state.selected_location ? 'disabled' : '')}>
						<label>{I18n.t('contact_form.how_would_you_prefer_to_be_counted')}</label>
						<div className="form-inline">
							<label><input type="radio" className="form-control" name="contact_preference" value="phone" checked={this.state.contact_preference == 'phone'} onChange={this.onChangeInput} disabled={!this.state.selected_state || !this.state.selected_location} /> Phone</label>
							<label><input type="radio" className="form-control" name="contact_preference" value="email" checked={this.state.contact_preference == 'email'} onChange={this.onChangeInput} disabled={!this.state.selected_state || !this.state.selected_location} /> Email</label>
							<label><input type="radio" className="form-control" name="contact_preference" value="text"  checked={this.state.contact_preference == 'text'} onChange={this.onChangeInput} disabled={!this.state.selected_state || !this.state.selected_location} /> Text</label>
						</div>
					</div>
										
					<button className="button block primary" disabled={!this.state.selected_state || !this.state.selected_location}>{I18n.t("contact_form.submit_message")}</button>
					
					{this.state.loading ? <div className="loading"><div className="spinner">&nbsp;</div></div> : null}
				</form>
			</div>
		);
	},



	/**
	* Change handlers
	*/

	onChangeInput: function (e) {
		//console.log('onChangeInput', e.target.name, e.target.value);
		this.state[e.target.name] = e.target.value;
		this.setState(this.state);
	},

	onChangeSelectedLocation: function (value, name) {
		//console.log('onChangeSelectedLocation', value, name);
		this.setState({selected_location: value, selected_location_name: name});
	}, 

	onChangeSelectedState: function (value) {
		//console.log('onChangeSelectedState', value);
		this.setState({selected_state: value, selected_location: null, selected_location_name: null});
	}, 

	onSubmit: function (e) {
		var self = this;

		e.preventDefault();
		e.stopPropagation();

		this.setState({loading: true});

		var form_data = {
    	location_id: this.state.selected_location,
    	name: this.state.name,
    	email: this.state.email,
    	contact_preference: this.state.contact_preference,
    	phone: this.state.phone,
    	message: this.state.message,
    	request_url: this.props.request_url,
		};

		//console.log('form_data', form_data);

		$.ajax({
			method: 'POST',
	    url: this.props.contact_us_path,
	    data: form_data,
		}).complete(function (response) {
			//console.log('onSubmit contact form is done', response.responseJSON);
			if (response.responseJSON && response.responseJSON.error) {
				self.setState({loading: false, error: response.responseJSON.error});
			} else if (response.responseJSON && response.responseJSON.success) {
				self.setState({loading: false, success: response.responseJSON.success, selected_location: null, selected_location_name: null, selected_state: null, name: '', email: '', phone: '', message: ''});
				ga('solasalonstudios.send', 'event', 'Location Contact Form', 'submission', JSON.stringify(form_data));
			} else {
				self.setState({loading: false, error: I18n.t('contact_form.please_try_again')});
			}
		}); 
	},

});