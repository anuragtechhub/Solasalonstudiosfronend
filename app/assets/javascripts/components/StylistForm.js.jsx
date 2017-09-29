var StylistForm = React.createClass({

  getInitialState: function () {
    return {
      stylist: this.props.stylist,
    };
  },

  render: function () {
    return (
      <div className="stylist-form">
        <div className="form-horizontal denser">
          
          {this.renderRow('Location', <LocationSelect location={this.props.stylist.location} onChange={this.onChangeLocation} />)}
          {this.renderRow('Name', <input name="name" value={this.props.stylist.name} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Email Address', <input name="email_address" value={this.props.stylist.email_address} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Phone Number', <input name="phone_number" value={this.props.stylist.phone_number} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Date of Birth', <input name="date_of_birth" value={this.props.stylist.date_of_birth} onChange={this.onChange} maxLength="255" type="text" />, 'You can click the textbox above and use a datepicker or type the date in the format: January 1, 1979')}
          {this.renderRow('Cosmetology License Number', <input name="cosmetology_license_number" value={this.props.stylist.cosmetology_license_number} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Street Address', <input name="street_address" value={this.props.stylist.street_address} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('City', <input name="city" value={this.props.stylist.city} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('State/Province', <input name="state_province" value={this.props.stylist.state_province} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Postal Code', <input name="postal_code" value={this.props.stylist.postal_code} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Country', <input name="country" value={this.props.stylist.country} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Emergency Contact Name', <input name="emergency_contact_name" value={this.props.stylist.emergency_contact_name} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Emergency Contact Relationship', <input name="emergency_contact_relationship" value={this.props.stylist.emergency_contact_relationship} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Emergency Contact Phone Number', <input name="emergency_contact_phone_number" value={this.props.stylist.emergency_contact_phone_number} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Sola Pro Password', <input name="password" value={this.props.stylist.password} onChange={this.onChange} maxLength="255" type="password" />)}
          {this.renderRow('Sola Pro Password Confirmation', <input name="password_confirmation" value={this.props.stylist.password_confirmation} onChange={this.onChange} maxLength="255" type="password" />)}
          {this.renderRow('Rent Manager ID', <input name="rent_manager_id" value={this.props.stylist.emergency_contact_phone_number} onChange={this.onChange} maxLength="255" type="text" />, 'This should be a tenant ID from Rent Manager')}
          {this.renderRow('Status', <input name="status" value={this.props.stylist.phone_number} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Leases', <input name="leases" value={this.props.stylist.leases} onChange={this.onChange} maxLength="255" type="text" />)}

          {this.renderRow('Website Name', <input name="website_name" value={this.props.stylist.website_name} onChange={this.onChange} maxLength="255" type="text" />, 'If you would like a different name listed on the website (other than the name in Account Info), set it here')}
          {this.renderRow('URL Name', <input name="url_name" value={this.props.stylist.url_name} onChange={this.onChange} maxLength="255" type="text" />, 'The URL name should contain only alphanumberic characters (A-Z and 0-9). No spaces or special characters are permitted. Dashes or underscores can be used to separate words (e.g. my-hair-is-awesome)')}
          
          {this.renderRow('Biography', <textarea name="biography" value={this.props.stylist.biography} onChange={this.onChange} />)}
          {this.renderRow('Business Name', <input name="business_name" value={this.props.stylist.business_name} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Studio Number', <input name="studio_number" value={this.props.stylist.studio_number} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Work Hours', <textarea name="work_hours" value={this.props.stylist.work_hours} onChange={this.onChange} />)}
          {this.renderRow('Accepting New Clients', <input name="accepting_new_clients" value={this.props.stylist.accepting_new_clients} onChange={this.onChange} maxLength="255" type="text" />)}

          {this.renderRow('Website Phone Number', <input name="website_phone_number" value={this.props.stylist.website_phone_number} onChange={this.onChange} maxLength="255" type="text" />, 'If you would like a different phone number listed on the website (other than to the phone number in Account Info), set it here')}
          {this.renderRow('Phone Number Display', <input name="phone_number_display" value={this.props.stylist.phone_number_display} onChange={this.onChange} maxLength="255" type="text" />, 'If set to hidden, the phone number will not be displayed anywhere on the Sola website')}
          {this.renderRow('Website Email Address', <input name="website_email_address" value={this.props.stylist.website_email_address} onChange={this.onChange} maxLength="255" type="text" />, 'If you would like stylist "Send a Message" emails to go to a different email address (other than the email address in Account info), set it here')}
          {this.renderRow('Send Message Button', <input name="send_a_message_button" value={this.props.stylist.send_a_message_button} onChange={this.onChange} maxLength="255" type="text" />, 'If set to hidden, the Send a Message button will not be displayed on your salon professional webpage')}

          {this.renderRow('External Website URL', <input name="website_url" value={this.props.stylist.website_url} onChange={this.onChange} maxLength="255" type="text" />, 'It is critical that you include the "http://" portion of the URL. If you do not have a website, leave this blank')}
          {this.renderRow('Booking URL', <input name="booking_url" value={this.props.stylist.booking_url} onChange={this.onChange} maxLength="255" type="text" />, 'It is critical that you include the "http://" portion of the URL. If you do not have online booking, leave this blank')}

          {this.renderRow('Facebook URL', <input name="facebook_url" value={this.props.stylist.facebook_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          {this.renderRow('Google Plus URL', <input name="google_plus_url" value={this.props.stylist.google_plus_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          {this.renderRow('Instagram URL', <input name="instagram_url" value={this.props.stylist.instagram_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          {this.renderRow('LinkedIn URL', <input name="linkedin_url" value={this.props.stylist.linkedin_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          {this.renderRow('Pinterest URL', <input name="pinterest_url" value={this.props.stylist.pinterest_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          {this.renderRow('Twitter URL', <input name="twitter_url" value={this.props.stylist.twitter_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          {this.renderRow('Yelp URL', <input name="yelp_url" value={this.props.stylist.yelp_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}

          {this.renderButtons()}
        </div>
      </div>
    );
  },

  renderButtons: function () {
    return (
      <div className="form-actions">
        <button className="btn btn-primary" data-disable-with="Save" name="_save" type="button" onClick={this.onSave}><i className="icon-white icon-ok"></i> Save </button> 
        <span className="extra_buttons"> 
          <button className="btn btn-info" data-disable-with="Save and add another" name="_add_another" type="button" onClick={this.onSaveAndAddAnother}> Save and add another </button> 
          <button className="btn btn-info" data-disable-with="Save and edit" name="_add_edit" type="button" onClick={this.onSaveAndEdit}> Save and edit </button> 
          <button className="btn" data-disable-with="Cancel" name="_continue" type="button" onClick={this.onCancel}> <i className="icon-remove"></i> Cancel </button> 
        </span>
      </div>
    );
  },

  renderRow: function (name, input, help) {
    return (
      <div className="control-group">
        <label className="control-label">{name}</label>
        <div className="controls">
          {input}
          {help ? <p className="help-block">{help}</p> : null}
        </div>
      </div>
    );
  },

  /******************
  * Change Handlers *
  *******************/

  onChange: function (e) {
    var stylist = this.state.stylist;
    stylist[e.target.name] = e.target.value;
    //console.log('onChange', e.target.name, e.target.value);
    this.setState({stylist: stylist});
  },

  onChangeLocation: function (location) {
    var stylist = this.state.stylist;
    stylist.location = location;
    this.setState({stylist: stylist});
  },

  /******************
  * Button Handlers *
  *******************/

  onCancel: function (e) {
    e.preventDefault();
    e.stopPropagation();
    window.history.back();
  },

  onSaveAndAddAnother: function (e) {
    e.preventDefault();
    e.stopPropagation();
    console.log('onSaveAndAddAnother');
  },  

  onSaveAndEdit: function (e) {
    e.preventDefault();
    e.stopPropagation();
    console.log('onSaveAndEdit');
  },

  onSave: function (e) {
    e.preventDefault();
    e.stopPropagation();
    console.log('onSave');
  },

});