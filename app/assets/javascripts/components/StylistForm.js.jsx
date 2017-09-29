var StylistForm = React.createClass({

  getInitialState: function () {
    return {
      stylist: this.props.stylist,
    };
  },

  render: function () {
    //console.log('render StylistForm', this.props.stylist);

    return (
      <div className="stylist-form">
        <div className="form-horizontal denser">
          
          {this.renderRow('Location', <LocationSelect location={this.props.stylist.location} onChange={this.onChangeLocation} />)}
          {this.renderRow('Name', <input name="name" value={this.props.stylist.name} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Email Address', <input name="email_address" value={this.props.stylist.email_address} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Phone Number', <input name="phone_number" value={this.props.stylist.phone_number} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Date of Birth', <Datepicker name="date_of_birth" value="1981-10-16" onChange={this.onChange} />, 'You can click the textbox above and use a datepicker or type the date in the format: January 1, 1979')}
          {this.renderRow('Cosmetology License Number', <input name="cosmetology_license_number" value={this.props.stylist.cosmetology_license_number} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Street Address', <input name="street_address" value={this.props.stylist.street_address} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('City', <input name="city" value={this.props.stylist.city} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('State/Province', <input name="state_province" value={this.props.stylist.state_province} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Postal Code', <input name="postal_code" value={this.props.stylist.postal_code} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Country', <input name="country" value={this.props.stylist.country} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Emergency Contact Name', <input name="emergency_contact_name" value={this.props.stylist.emergency_contact_name} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Emergency Contact Relationship', <input name="emergency_contact_relationship" value={this.props.stylist.emergency_contact_relationship} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Emergency Contact Phone Number', <input name="emergency_contact_phone_number" value={this.props.stylist.emergency_contact_phone_number} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.props.current_admin.franchisee ? null : this.renderRow('Sola Pro Password', <input name="password" value={this.props.stylist.password} onChange={this.onChange} maxLength="255" type="password" />)}
          {this.props.current_admin.franchisee ? null : this.renderRow('Sola Pro Password Confirmation', <input name="password_confirmation" value={this.props.stylist.password_confirmation} onChange={this.onChange} maxLength="255" type="password" />)}
          {this.props.current_admin.franchisee ? null : this.renderRow('Rent Manager ID', <input name="rent_manager_id" value={this.props.stylist.emergency_contact_phone_number} onChange={this.onChange} maxLength="255" type="text" />, 'This should be a tenant ID from Rent Manager')}
          {this.renderRow('Status', <EnumSelect name="status" value={this.props.stylist.status} values={[['Open', 'open'], ['Closed', 'closed']]} onChange={this.onChange} />)}
          {this.renderRow('Leases', <input name="leases" value={this.props.stylist.leases} onChange={this.onChange} maxLength="255" type="text" />)}

          {this.renderRow('Website Name', <input name="website_name" value={this.props.stylist.website_name} onChange={this.onChange} maxLength="255" type="text" />, 'If you would like a different name listed on the website (other than the name in Account Info), set it here')}
          {this.renderRow('URL Name', <input name="url_name" value={this.props.stylist.url_name} onChange={this.onChange} maxLength="255" type="text" />, 'The URL name should contain only alphanumberic characters (A-Z and 0-9). No spaces or special characters are permitted. Dashes or underscores can be used to separate words (e.g. my-hair-is-awesome)')}
          
          {this.renderRow('Biography', <textarea name="biography" value={this.props.stylist.biography} onChange={this.onChange} />)}
          {this.renderRow('Business Name', <input name="business_name" value={this.props.stylist.business_name} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Studio Number', <input name="studio_number" value={this.props.stylist.studio_number} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Work Hours', <textarea name="work_hours" value={this.props.stylist.work_hours} onChange={this.onChange} />)}
          {this.renderRow('Accepting New Clients', <input name="accepting_new_clients" value={this.props.stylist.accepting_new_clients} onChange={this.onChange} maxLength="255" type="text" />)}

          {this.renderRow('Website Phone Number', <input name="website_phone_number" value={this.props.stylist.website_phone_number} onChange={this.onChange} maxLength="255" type="text" />, 'If you would like a different phone number listed on the website (other than to the phone number in Account Info), set it here')}
          {this.renderRow('Phone Number Display', <EnumSelect name="phone_number_display" value={this.props.stylist.phone_number_display} values={[['Visible', true], ['Hidden', false]]} onChange={this.onChange} />, 'If set to hidden, the phone number will not be displayed anywhere on the Sola website')}
          {this.renderRow('Website Email Address', <input name="website_email_address" value={this.props.stylist.website_email_address} onChange={this.onChange} maxLength="255" type="text" />, 'If you would like stylist "Send a Message" emails to go to a different email address (other than the email address in Account info), set it here')}
          {this.renderRow('Send Message Button', <EnumSelect name="send_a_message_button" value={this.props.stylist.send_a_message_button} values={[['Visible', true], ['Hidden', false]]} onChange={this.onChange} />, 'If set to hidden, the Send a Message button will not be displayed on your salon professional webpage')}

          {this.renderRow('External Website URL', <input name="website_url" value={this.props.stylist.website_url} onChange={this.onChange} maxLength="255" type="text" />, 'It is critical that you include the "http://" portion of the URL. If you do not have a website, leave this blank')}
          {this.renderRow('Booking URL', <input name="booking_url" value={this.props.stylist.booking_url} onChange={this.onChange} maxLength="255" type="text" />, 'It is critical that you include the "http://" portion of the URL. If you do not have online booking, leave this blank')}

          {this.renderRow('Facebook URL', <input name="facebook_url" value={this.props.stylist.facebook_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          {this.renderRow('Google Plus URL', <input name="google_plus_url" value={this.props.stylist.google_plus_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          {this.renderRow('Instagram URL', <input name="instagram_url" value={this.props.stylist.instagram_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          {this.renderRow('LinkedIn URL', <input name="linkedin_url" value={this.props.stylist.linkedin_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          {this.renderRow('Pinterest URL', <input name="pinterest_url" value={this.props.stylist.pinterest_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          {this.renderRow('Twitter URL', <input name="twitter_url" value={this.props.stylist.twitter_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          {this.renderRow('Yelp URL', <input name="yelp_url" value={this.props.stylist.yelp_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}

          {this.renderRow('Brows', <input name="brows" value={this.props.stylist.brows} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Hair', <input name="hair" value={this.props.stylist.hair} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Hair Extensions', <input name="hair_extensions" value={this.props.stylist.hair_extensions} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Laser Hair Removal', <input name="laser_hair_removal" value={this.props.stylist.laser_hair_removal} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Lashes', <input name="eyelash_extensions" value={this.props.stylist.eyelash_extensions} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Makeup', <input name="makeup" value={this.props.stylist.makeup} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Massage', <input name="massage" value={this.props.stylist.massage} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Microblading', <input name="microblading" value={this.props.stylist.microblading} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Nails', <input name="nails" value={this.props.stylist.nails} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Permanent Makeup', <input name="permanent_makeup" value={this.props.stylist.permanent_makeup} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Skincare', <input name="skin" value={this.props.stylist.skin} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Tanning', <input name="tanning" value={this.props.stylist.tanning} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Teeth Whitening', <input name="teeth_whitening" value={this.props.stylist.teeth_whitening} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Threading', <input name="threading" value={this.props.stylist.threading} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Waxing', <input name="waxing" value={this.props.stylist.waxing} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Other Services', <input name="other_service" value={this.props.stylist.other_service} onChange={this.onChange} maxLength="18" type="text" />)}

          {this.renderRow('Image 1', <input name="image_1" value={this.props.stylist.image_1} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Image 1 Alt Text', <input name="image_1_alt_text" value={this.props.stylist.image_1_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
          {this.renderRow('Image 2', <input name="image_2" value={this.props.stylist.image_2} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Image 3 Alt Text', <input name="image_2_alt_text" value={this.props.stylist.image_2_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
          {this.renderRow('Image 3', <input name="image_3" value={this.props.stylist.image_3} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Image 3 Alt Text', <input name="image_3_alt_text" value={this.props.stylist.image_3_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
          {this.renderRow('Image 4', <input name="image_4" value={this.props.stylist.image_4} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Image 4 Alt Text', <input name="image_4_alt_text" value={this.props.stylist.image_4_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
          {this.renderRow('Image 5', <input name="image_5" value={this.props.stylist.image_5} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Image 5 Alt Text', <input name="image_5_alt_text" value={this.props.stylist.image_5_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
          {this.renderRow('Image 6', <input name="image_6" value={this.props.stylist.image_6} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Image 6 Alt Text', <input name="image_6_alt_text" value={this.props.stylist.image_6_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
          {this.renderRow('Image 7', <input name="image_7" value={this.props.stylist.image_7} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Image 7 Alt Text', <input name="image_7_alt_text" value={this.props.stylist.image_7_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
          {this.renderRow('Image 8', <input name="image_8" value={this.props.stylist.image_8} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Image 8 Alt Text', <input name="image_8_alt_text" value={this.props.stylist.image_8_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
          {this.renderRow('Image 9', <input name="image_9" value={this.props.stylist.image_9} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Image 9 Alt Text', <input name="image_9_alt_text" value={this.props.stylist.image_9_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
          {this.renderRow('Image 10', <input name="image_10" value={this.props.stylist.image_10} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Image 10 Alt Text', <input name="image_10_alt_text" value={this.props.stylist.image_10_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}

          {this.renderRow('Testimonial 1', <input name="testimonial_1" value={this.props.stylist.testimonial_1} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Testimonial 2', <input name="testimonial_2" value={this.props.stylist.testimonial_2} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Testimonial 3', <input name="testimonial_3" value={this.props.stylist.testimonial_3} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Testimonial 4', <input name="testimonial_4" value={this.props.stylist.testimonial_4} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Testimonial 5', <input name="testimonial_5" value={this.props.stylist.testimonial_5} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Testimonial 6', <input name="testimonial_6" value={this.props.stylist.testimonial_6} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Testimonial 7', <input name="testimonial_7" value={this.props.stylist.testimonial_7} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Testimonial 8', <input name="testimonial_8" value={this.props.stylist.testimonial_8} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Testimonial 9', <input name="testimonial_9" value={this.props.stylist.testimonial_9} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Testimonial 10', <input name="testimonial_10" value={this.props.stylist.testimonial_10} onChange={this.onChange} maxLength="255" type="text" />)}

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
    console.log('onChange', e.target.name, e.target.value);
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