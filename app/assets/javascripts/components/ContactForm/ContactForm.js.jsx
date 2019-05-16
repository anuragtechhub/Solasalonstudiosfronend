var ContactForm = React.createClass({

	getInitialState: function () {
		return {
			name: '',
			email: '',
			contact_preference: 'phone',
			phone: '',
			message: '',
			error: null,
			success: null,
			newsletter: true,
			loading: false,
			dont_see_your_location: false,
			how_can_we_help_you: I18n.t('contact_form.request_leasing_information'),
			i_would_like_to_be_contacted: true,
			selected_location: this.props.selected_location,
			selected_location_name: this.props.selected_location_name,
			selected_state: this.props.selected_state,
			selected_services: [],
		};
	},

	componentDidMount: function () {
		$(this.refs.first_input).tooltipster({theme: 'tooltipster-noir', timer: 4000, trigger: 'foo'});
	},

	componentDidUpdate: function (prevProps, prevState) {
		var self = this;

		if (this.state.success && prevState.success != this.state.success) {
			//console.log('success!')
			$(this.refs.first_input).tooltipster('content', this.state.success).tooltipster('show');
			setTimeout(function () {
				self.setState({success: null});
			}, 1000);
		} else if (this.state.error && prevState.error != this.state.error) {
			//console.log('error!')
			$(this.refs.first_input).tooltipster('content', this.state.error).tooltipster('show');
			setTimeout(function () {
				self.setState({error: null});
			}, 1000);
		}

		// Why Sola page
		var $why_sola = $('.why-sola .search-for-a-salon');
		if ($why_sola && $why_sola.length) {
			if (!this.state.selected_state) {
				$why_sola.removeClass('max-height')
			} else {
				$why_sola.addClass('max-height')
			}
		}
	},



	/**
	* Render functions
	*/

	render: function () {
		//console.log('render ContactForm', this.props);
		
		return (
			<div className={"contact-form max-height " + (this.state.selected_state ? 'full-height ' : '')}>
				<h2>{this.props.title}</h2>

				<form onSubmit={this.onSubmit} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)} ref="form">
					{/*<input autoComplete="false" name="hidden" type="text" style={{display: 'none'}} />*/}
					<SolaSelect className="state-select" placeholder={I18n.t('contact_form.select_a_state')} options={this.props.all_states} value={this.state.selected_state} onChange={this.onChangeSelectedState} />
					
					{
						this.state.selected_state 
						?
						<div className="row">
							<div className="six columns"> 
								<SolaSelect className="location-select" 
												displayName={true} 
												filteredBy={this.state.selected_state}
												placeholder={I18n.t('contact_form.select_a_location')} 
												options={this.props.all_locations} 
												name={this.state.selected_location_name} 
												value={this.state.selected_location} 
												onChange={this.onChangeSelectedLocation} /> 
							</div>
							<div className="six columns">
								<div className="dont-see-your-location">
									<label><input type="checkbox" className="form-control" name="dont_see_your_location" checked={this.state.dont_see_your_location} onChange={this.onChangeInput} disabled={!this.state.selected_state} /> {I18n.t('contact_form.dont_see_your_location')}</label>
								</div>
							</div>
						</div>
						: 
						null
					}



					<div className="form-group" ref="first_input">
						<input className="form-control" name="name" value={this.state.name} onChange={this.onChangeInput} type="text" placeholder={I18n.t("contact_form.your_name")} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)} /> 
					</div>
					<div className="form-group">
						<input className="form-control" name="email" value={this.state.email} onChange={this.onChangeInput} type="text" placeholder={I18n.t("contact_form.email_address")} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)} />
					</div>
					<div className="form-group"> 
						<input className="form-control" name="phone" value={this.state.phone} onChange={this.onChangeInput} type="text" placeholder={I18n.t("contact_form.phone_number")} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)} /> 
					</div>

					{
						this.props.display_service_checkboxes
						?
						<div className={"service-checkboxes " + (!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location) ? 'disabled' : '')}>
							{this.renderServiceCheckboxes()}
							<div className="clearfix">&nbsp;</div>
						</div>
						: 
						null
					}

					{
						this.props.display_i_would_like_to
						?
						<div className={"form-group how-can-we-help-you " + (!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location) ? 'disabled' : '')}>
							<label>{I18n.t('contact_form.i_would_like_to')}</label>
							<div className="form-inline-rows">
								<div className="form-inline">
									<label><input type="radio" className="form-control" name="how_can_we_help_you" value={I18n.t('contact_form.request_leasing_information')} checked={this.state.how_can_we_help_you == I18n.t('contact_form.request_leasing_information')} onChange={this.onChangeInput} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)} /> {I18n.t('contact_form.request_leasing_information')}</label>
								</div>
								<div className="form-inline">
									<label><input type="radio" className="form-control" name="how_can_we_help_you" value={I18n.t('contact_form.book_an_appointment')} checked={this.state.how_can_we_help_you == I18n.t('contact_form.book_an_appointment')} onChange={this.onChangeInput} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)} /> {I18n.t('contact_form.book_an_appointment')}</label>
								</div>
								<div className="form-inline">
									<label><input type="radio" className="form-control" name="how_can_we_help_you" value={I18n.t('contact_form.other')} checked={this.state.how_can_we_help_you == I18n.t('contact_form.other')} onChange={this.onChangeInput} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)} /> {I18n.t('contact_form.other')}</label>
								</div>
							</div>
							{/*<SolaSelect className="how_can_we_help_you-select" 
													placeholder={I18n.t('contact_form.how_can_we_help_you')} 
													options={[
														{	option_type: 'option',
															value: {
															id: I18n.t('contact_form.request_leasing_information'),
															name: I18n.t('contact_form.request_leasing_information')
														}},
														{ option_type: 'option',
															value: {
															id: I18n.t('contact_form.book_an_appointment'),
															name: I18n.t('contact_form.book_an_appointment')
														}},
														{ option_type: 'option',
															value: {
															id: I18n.t('contact_form.other'),
															name: I18n.t('contact_form.other')
														}},
													]} 
													name="how_can_we_help_you" 
													value={this.state.how_can_we_help_you}
													onChange={this.onChangeHowCanWeHelpYou}
													tabIndex={0} />*/}
			
							{/*<select name="how_can_we_help_you" value={this.state.how_can_we_help_you} onChange={this.onChangeInput} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)}>
								<option value="request_leasing_information">{I18n.t('contact_form.request_leasing_information')}</option>
								<option value="book_an_appointment">{I18n.t('contact_form.book_an_appointment')}</option>
								<option value="other">{I18n.t('contact_form.other')}</option>
							</select>*/}
						</div>
						:
						null
					}

					<div className={"form-group " + (!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location) ? 'disabled' : '')}>
						<textarea className="form-control" name="message" value={this.state.message} onChange={this.onChangeInput} placeholder={I18n.t("contact_form.leave_a_message")} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)}></textarea> 
					</div>

					{this.props.display_i_would_like_to_be_contacted ? null : this.renderContactPreference()}

					<button className="button block primary" disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)}>{this.props.submit_button_text}</button>
					
					{
						this.props.display_i_would_like_to_be_contacted 
						?
						<div className={"form-group newsletter " + (!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location) ? 'disabled' : '')} style={{marginBottom: '-8px', marginTop: '10px'}}>
							<label>
								<input type="checkbox" name="i_would_like_to_be_contacted" checked={this.state.i_would_like_to_be_contacted} onChange={this.onChangeInput} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)} /> 
								<span className="text">{I18n.t('contact_form.i_would_like_to_be_contacted')}</span>
								<div className="clearfix">&nbsp;</div>
							</label>
						</div>
						:
						null
					}

					{this.props.display_i_would_like_to_be_contacted && this.state.i_would_like_to_be_contacted ? <div className="contact-preference-bottom">{this.renderContactPreference()}</div> : null}

					<div className={"form-group newsletter " + (!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location) ? 'disabled' : '')}>
						<label>
							<input type="checkbox" name="newsletter" checked={this.state.newsletter} onChange={this.onChangeInput} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)} /> 
							<span className="text">{I18n.t('contact_form.subscribe_to_newsletter')}</span>
							<div className="clearfix">&nbsp;</div>
						</label>
					</div>

					{this.state.loading ? <div className="loading"><div className="spinner">&nbsp;</div></div> : null}
				</form>
			</div>
		);
	},

	renderContactPreference: function () {
		return (
			<div className={"form-group contact-preference " + (!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location) ? 'disabled' : '')}>
				<label className="label">{I18n.t('contact_form.how_would_you_prefer_to_be_counted')}</label>
				<div className="form-inline">
					<label><input type="radio" className="form-control" name="contact_preference" value="phone" checked={this.state.contact_preference == 'phone'} onChange={this.onChangeInput} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)} /> Phone</label>
					<label><input type="radio" className="form-control" name="contact_preference" value="email" checked={this.state.contact_preference == 'email'} onChange={this.onChangeInput} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)} /> Email</label>
					<label><input type="radio" className="form-control" name="contact_preference" value="text"  checked={this.state.contact_preference == 'text'} onChange={this.onChangeInput} disabled={!this.state.selected_state || (!this.state.selected_location && !this.state.dont_see_your_location)} /> Text</label>
				</div>
			</div>
		);
	},

	renderServiceCheckboxes: function () {
		var self = this;
		var services = ['Hair', 'Skincare', 'Makeup', 'Massage', 'Nails', 'Other (please specify with open form field)'];

		var servicesRendered = services.map(function (service) {
			return (
				<label key={service}>
					<input type="checkbox" name="selected_services" value={service} checked={self.state.selected_services.indexOf(service) != -1} onChange={self.onChangeInput} disabled={!self.state.selected_state || (!self.state.selected_location && !self.state.dont_see_your_location)} /> 
					<span className="text">{service}</span>
				</label>
			);
		});

		return (
			<div className="services">{servicesRendered}</div>
		);
	},



	/**
	* Change handlers
	*/

	onChangeInput: function (e) {
		//console.log('onChangeInput', e.target.name, e.target.value);
		var value = e.target.type == 'checkbox' ? e.target.checked : e.target.value;
		

		if (e.target.name == 'dont_see_your_location' && value == true) {
			this.state.selected_location = null;
			this.state.selected_location_name = null;
			this.state[e.target.name] = value;
		} else if (e.target.name == 'selected_services') {
			if (value == true && this.state.selected_services.indexOf(e.target.value) == -1) {
				this.state.selected_services.push(e.target.value);
			} else if (value == false) {
				this.state.selected_services.splice(this.state.selected_services.indexOf(e.target.value), 1);
			}
		} else {
			this.state[e.target.name] = value;
		}

		//console.log('this.state.selected_services', this.state.selected_services);

		this.setState(this.state);
	},

	onChangeHowCanWeHelpYou: function (value, name) {
		//console.log('onChangeHowCanWeHelpYou', value, name);
		this.setState({how_can_we_help_you: name});
	},

	onChangeSelectedLocation: function (value, name) {
		//console.log('onChangeSelectedLocation', value, name);
		this.setState({selected_location: value, selected_location_name: name, dont_see_your_location: false});
	}, 

	onChangeSelectedState: function (value) {
		//console.log('onChangeSelectedState', value);
		this.setState({selected_state: value, selected_location: null, selected_location_name: null, dont_see_your_location: false});
	}, 

	onSubmit: function (e) {
		var self = this;

		e.preventDefault();
		e.stopPropagation();

		this.setState({loading: true});

		// handle message
		//console.log('handle message', this.state.how_can_we_help_you);
		// var message = this.capitalize(I18n.t('contact_form.request_leasing_information')); //default
		// if (this.state.how_can_we_help_you == 'request_leasing_information') {
		// 	message = this.capitalize(I18n.t('contact_form.request_leasing_information'));
		// } else if (this.state.how_can_we_help_you == 'book_an_appointment') {
		// 	message = this.capitalize(I18n.t('contact_form.book_an_appointment'));
		// } else if (this.state.how_can_we_help_you == 'other') {
		// 	message = this.state.message && this.state.message != '' ? this.state.message : this.capitalize(I18n.t('contact_form.other'));
		// }
		//console.log('message', message);

		var form_data = {
    	location_id: this.state.selected_location,
    	name: this.state.name,
    	email: this.state.email,
    	contact_preference: this.capitalize(this.state.contact_preference),
    	dont_see_your_location: this.state.dont_see_your_location,
    	how_can_we_help_you: this.state.how_can_we_help_you,
    	i_would_like_to_be_contacted: this.state.i_would_like_to_be_contacted,
    	phone: this.state.phone,
    	message: this.state.message,
    	request_url: this.props.request_url,
    	services: this.state.selected_services.join(', ')
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
				self.setState({loading: false, success: response.responseJSON.success, selected_services: [], selected_location: null, selected_location_name: null, selected_state: null, dont_see_your_location: false, contact_preference: 'phone', how_can_we_help_you: I18n.t('contact_form.request_leasing_information'), name: '', email: '', phone: '', message: ''});
				ga('solasalonstudios.send', 'event', 'Location Contact Form', 'submission', JSON.stringify(form_data));
			} else {
				self.setState({loading: false, error: I18n.t('contact_form.please_try_again')});
			}
		}); 
	},




	/**
	* Helper functions
	*/
	capitalize: function (s) {
  	if (typeof s !== 'string') {
  		return '';
  	}
  	return s.charAt(0).toUpperCase() + s.slice(1);
	},


});