var StylistForm = React.createClass({

  getInitialState: function () {
    return {
      errors: null,
      loading: false,
      stylist: this.props.stylist || {},
      success: null,
    };
  },

  componentDidUpdate: function (prevProps, prevState) {
    if (prevState.loading !== this.state.loading) {
      if (this.state.loading) {
        $.LoadingOverlay("show");
      } else {
        $.LoadingOverlay("hide");
      }
    }
  },

  render: function () {
    //console.log('render StylistForm', this.state.stylist);

    return (
      <div className="stylist-form">
        <div className="form-horizontal denser">

          {this.state.errors ? this.renderErrors() : null}
          {this.state.success ? this.renderSuccess() : null}
          
          {this.renderAccountInfo()} 
          {this.renderWebsiteInfo()}  
          {this.renderLeaseInfo()}
          
          {this.renderButtons()}
        </div>
        {/*this.state.loading ? <div className="loading"><div className="spinner"></div></div> : null(*/}
      </div>
    );
  },

  renderAccountInfo: function () {
    return (
      <ExpandCollapseGroup name="Account Info" collapsed={false}>
        {this.renderRow('Location', <LocationSelect location={this.state.stylist.location} onChange={this.onChangeLocation} />)}
        {this.state.stylist.location == null ? null : this.renderRow('Status', <EnumSelect name="status" value={this.state.stylist.status} values={[['Open', 'open'], ['Closed', 'closed']]} onChange={this.onChange} />)}
        {this.state.stylist.location == null ? null : this.renderRow('Name', <input name="name" value={this.state.stylist.name} onChange={this.onChange} maxLength="255" type="text" />)}
        {this.state.stylist.location == null ? null : this.renderRow('Email Address', <input name="email_address" value={this.state.stylist.email_address} onChange={this.onChange} maxLength="255" type="text" />)}
        {this.state.stylist.location == null ? null : this.renderRow('Phone Number', <input name="phone_number" value={this.state.stylist.phone_number} onChange={this.onChange} maxLength="255" type="text" />)}
        {this.state.stylist.location == null ? null : this.renderRow('Date of Birth', <Datepicker name="date_of_birth" value={this.state.stylist.date_of_birth} onChange={this.onChange} />, 'You can click the textbox above and use a datepicker or type the date in the format: January 1, 1979')}
        {this.state.stylist.location == null ? null : this.renderRow('Street Address', <input name="street_address" value={this.state.stylist.street_address} onChange={this.onChange} maxLength="255" type="text" />)}
        {this.state.stylist.locationn == null ? null : this.renderRow('City', <input name="city" value={this.state.stylist.city} onChange={this.onChange} maxLength="255" type="text" />)}
        {this.state.stylist.location == null ? null : this.renderRow('State/Province', <input name="state_province" value={this.state.stylist.state_province} onChange={this.onChange} maxLength="255" type="text" />)}
        {this.state.stylist.location == null ? null : this.renderRow('Postal Code', <input name="postal_code" value={this.state.stylist.postal_code} onChange={this.onChange} maxLength="255" type="text" />)}
        {this.state.stylist.location == null ? null : this.renderRow('Country', <input name="country" value={this.state.stylist.country} onChange={this.onChange} maxLength="255" type="text" />)}
        {this.state.stylist.location == null ? null : this.renderRow('Cosmetology License Number', <input name="cosmetology_license_number" value={this.state.stylist.cosmetology_license_number} onChange={this.onChange} maxLength="255" type="text" />)}
        {this.state.stylist.location == null ? null : this.renderRow('Emergency Contact Name', <input name="emergency_contact_name" value={this.state.stylist.emergency_contact_name} onChange={this.onChange} maxLength="255" type="text" />)}
        {this.state.stylist.location == null ? null : this.renderRow('Emergency Contact Relationship', <input name="emergency_contact_relationship" value={this.state.stylist.emergency_contact_relationship} onChange={this.onChange} maxLength="255" type="text" />)}
        {this.state.stylist.location == null ? null : this.renderRow('Emergency Contact Phone Number', <input name="emergency_contact_phone_number" value={this.state.stylist.emergency_contact_phone_number} onChange={this.onChange} maxLength="255" type="text" />)}
        {this.state.stylist.location == null ? null : this.props.current_admin.franchisee ? null : this.renderRow('Sola Pro Password', <input name="password" value={this.state.stylist.password} onChange={this.onChange} maxLength="255" type="password" />)}
        {this.state.stylist.location == null ? null : this.props.current_admin.franchisee ? null : this.renderRow('Sola Pro Password Confirmation', <input name="password_confirmation" value={this.state.stylist.password_confirmation} onChange={this.onChange} maxLength="255" type="password" />)}
        {/*this.props.current_admin.franchisee ? null : this.renderRow('Rent Manager ID', <input name="rent_manager_id" value={this.state.stylist.emergency_contact_phone_number} onChange={this.onChange} maxLength="255" type="text" />, 'This should be a tenant ID from Rent Manager')*/}          
      </ExpandCollapseGroup>
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

  renderErrors: function () {
    var errors = this.state.errors.map(function (error) {
      return <li key={error}>{error}</li>
    });

    return (
      <div className="errors">
        The following errors prevented this stylist from being saved:
        <ul>{errors}</ul>
      </div>
    );  
  },

  renderLeaseInfo: function () {
    if (this.state.stylist.location) {
      return (
        <ExpandCollapseGroup name="Lease Info" collapsed={true}>
          <LeaseForm lease={this.state.stylist.lease} location={this.state.stylist.location} stylist={this.state.stylist} nested={true} />
        </ExpandCollapseGroup>
      );
    }
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

  renderSuccess: function () {
    return (
      <div className="success">{this.state.success}</div>
    );
  },

  renderWebsiteInfo: function () {
    if (this.state.stylist.location) {
      return (
        <ExpandCollapseGroup name="Website Info" collapsed={true}>
          {this.renderRow('Website Name', <input name="website_name" value={this.state.stylist.website_name} onChange={this.onChange} maxLength="255" type="text" />, 'If you would like a different name listed on the website (other than the name in Account Info), set it here')}
          {this.renderRow('URL Name', <input name="url_name" value={this.state.stylist.url_name} onChange={this.onChange} maxLength="255" type="text" />, 'The URL name should contain only alphanumberic characters (A-Z and 0-9). No spaces or special characters are permitted. Dashes or underscores can be used to separate words (e.g. my-hair-is-awesome)')}
          
          {this.renderRow('Biography', <RichTextEditor name="biography" value={this.state.stylist.biography} onChange={this.onChange} />)}
          {this.renderRow('Business Name', <input name="business_name" value={this.state.stylist.business_name} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Studio Number', <input name="studio_number" value={this.state.stylist.studio_number} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Work Hours', <textarea name="work_hours" value={this.state.stylist.work_hours} onChange={this.onChange} />)}
          {this.renderRow('Accepting New Clients', <EnumSelect name="accepting_new_clients" value={this.state.stylist.accepting_new_clients} values={[['Yes', true], ['No', false]]} onChange={this.onChange} />)}

          {this.renderRow('Website Phone Number', <input name="website_phone_number" value={this.state.stylist.website_phone_number} onChange={this.onChange} maxLength="255" type="text" />, 'If you would like a different phone number listed on the website (other than to the phone number in Account Info), set it here')}
          {this.renderRow('Phone Number Display', <EnumSelect name="phone_number_display" value={this.state.stylist.phone_number_display} values={[['Visible', true], ['Hidden', false]]} onChange={this.onChange} />, 'If set to hidden, the phone number will not be displayed anywhere on the Sola website')}
          {this.renderRow('Website Email Address', <input name="website_email_address" value={this.state.stylist.website_email_address} onChange={this.onChange} maxLength="255" type="text" />, 'If you would like stylist "Send a Message" emails to go to a different email address (other than the email address in Account info), set it here')}
          {this.renderRow('Send Message Button', <EnumSelect name="send_a_message_button" value={this.state.stylist.send_a_message_button} values={[['Visible', true], ['Hidden', false]]} onChange={this.onChange} />, 'If set to hidden, the Send a Message button will not be displayed on your salon professional webpage')}

          {this.renderRow('External Website URL', <input name="website_url" value={this.state.stylist.website_url} onChange={this.onChange} maxLength="255" type="text" />, 'It is critical that you include the "http://" portion of the URL. If you do not have a website, leave this blank')}
          {this.renderRow('Booking URL', <input name="booking_url" value={this.state.stylist.booking_url} onChange={this.onChange} maxLength="255" type="text" />, 'It is critical that you include the "http://" portion of the URL. If you do not have online booking, leave this blank')}

          <ExpandCollapseGroup name="Social URLs" nested={true} collapsed={true}>
            {this.renderRow('Facebook URL', <input name="facebook_url" value={this.state.stylist.facebook_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
            {this.renderRow('Google Plus URL', <input name="google_plus_url" value={this.state.stylist.google_plus_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
            {this.renderRow('Instagram URL', <input name="instagram_url" value={this.state.stylist.instagram_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
            {this.renderRow('LinkedIn URL', <input name="linkedin_url" value={this.state.stylist.linkedin_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
            {this.renderRow('Pinterest URL', <input name="pinterest_url" value={this.state.stylist.pinterest_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
            {this.renderRow('Twitter URL', <input name="twitter_url" value={this.state.stylist.twitter_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
            {this.renderRow('Yelp URL', <input name="yelp_url" value={this.state.stylist.yelp_url} onChange={this.onChange} maxLength="255" type="text" />, 'Please use the full website address, including the "http://" portion of the URL')}
          </ExpandCollapseGroup>

          <ExpandCollapseGroup name="Services" nested={true} collapsed={true}>
            {this.renderRow('Brows', <Checkbox name="brows" value={this.state.stylist.brows} onChange={this.onChange} />)}
            {this.renderRow('Hair', <Checkbox name="hair" value={this.state.stylist.hair} onChange={this.onChange} />)}
            {this.renderRow('Hair Extensions', <Checkbox name="hair_extensions" value={this.state.stylist.hair_extensions} onChange={this.onChange} />)}
            {this.renderRow('Laser Hair Removal', <Checkbox name="laser_hair_removal" value={this.state.stylist.laser_hair_removal} onChange={this.onChange} />)}
            {this.renderRow('Lashes', <Checkbox name="eyelash_extensions" value={this.state.stylist.eyelash_extensions} onChange={this.onChange} />)}
            {this.renderRow('Makeup', <Checkbox name="makeup" value={this.state.stylist.makeup} onChange={this.onChange} />)}
            {this.renderRow('Massage', <Checkbox name="massage" value={this.state.stylist.massage} onChange={this.onChange} />)}
            {this.renderRow('Microblading', <Checkbox name="microblading" value={this.state.stylist.microblading} onChange={this.onChange} />)}
            {this.renderRow('Nails', <Checkbox name="nails" value={this.state.stylist.nails} onChange={this.onChange} />)}
            {this.renderRow('Permanent Makeup', <Checkbox name="permanent_makeup" value={this.state.stylist.permanent_makeup} onChange={this.onChange} />)}
            {this.renderRow('Skincare', <Checkbox name="skin" value={this.state.stylist.skin} onChange={this.onChange} />)}
            {this.renderRow('Tanning', <Checkbox name="tanning" value={this.state.stylist.tanning} onChange={this.onChange} />)}
            {this.renderRow('Teeth Whitening', <Checkbox name="teeth_whitening" value={this.state.stylist.teeth_whitening} onChange={this.onChange} />)}
            {this.renderRow('Threading', <Checkbox name="threading" value={this.state.stylist.threading} onChange={this.onChange} />)}
            {this.renderRow('Waxing', <Checkbox name="waxing" value={this.state.stylist.waxing} onChange={this.onChange} />)}
            {this.renderRow('Other Services', <input name="other_service" value={this.state.stylist.other_service} onChange={this.onChange} maxLength="18" type="text" />)}
          </ExpandCollapseGroup>

          <ExpandCollapseGroup name="Images" nested={true} collapsed={true}>
            {this.renderRow('Image 1', <ImageDropzone name="image_1_url" image_url={this.state.stylist.image_1_url} onChange={this.onChange} />)}
            {this.renderRow('Image 1 Alt Text', <input name="image_1_alt_text" value={this.state.stylist.image_1_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
            {this.renderRow('Image 2', <ImageDropzone name="image_2_url" image_url={this.state.stylist.image_2_url} onChange={this.onChange} />)}
            {this.renderRow('Image 3 Alt Text', <input name="image_2_alt_text" value={this.state.stylist.image_2_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
            {this.renderRow('Image 3', <ImageDropzone name="image_3_url" image_url={this.state.stylist.image_3_url} onChange={this.onChange} />)}
            {this.renderRow('Image 3 Alt Text', <input name="image_3_alt_text" value={this.state.stylist.image_3_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
            {this.renderRow('Image 4', <ImageDropzone name="image_4_url" image_url={this.state.stylist.image_4_url} onChange={this.onChange} />)}
            {this.renderRow('Image 4 Alt Text', <input name="image_4_alt_text" value={this.state.stylist.image_4_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
            {this.renderRow('Image 5', <ImageDropzone name="image_5_url" image_url={this.state.stylist.image_5_url} onChange={this.onChange} />)}
            {this.renderRow('Image 5 Alt Text', <input name="image_5_alt_text" value={this.state.stylist.image_5_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
            {this.renderRow('Image 6', <ImageDropzone name="image_6_url" image_url={this.state.stylist.image_6_url} onChange={this.onChange} />)}
            {this.renderRow('Image 6 Alt Text', <input name="image_6_alt_text" value={this.state.stylist.image_6_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
            {this.renderRow('Image 7', <ImageDropzone name="image_7_url" image_url={this.state.stylist.image_7_url} onChange={this.onChange} />)}
            {this.renderRow('Image 7 Alt Text', <input name="image_7_alt_text" value={this.state.stylist.image_7_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
            {this.renderRow('Image 8', <ImageDropzone name="image_8_url" image_url={this.state.stylist.image_8_url} onChange={this.onChange} />)}
            {this.renderRow('Image 8 Alt Text', <input name="image_8_alt_text" value={this.state.stylist.image_8_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
            {this.renderRow('Image 9', <ImageDropzone name="image_9_url" image_url={this.state.stylist.image_9_url} onChange={this.onChange} />)}
            {this.renderRow('Image 9 Alt Text', <input name="image_9_alt_text" value={this.state.stylist.image_9_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
            {this.renderRow('Image 10', <ImageDropzone name="image_10_url" image_url={this.state.stylist.image_10_url} onChange={this.onChange} />)}
            {this.renderRow('Image 10 Alt Text', <input name="image_10_alt_text" value={this.state.stylist.image_10_alt_text} onChange={this.onChange} maxLength="255" type="text" />, 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)')}
          </ExpandCollapseGroup>

          <ExpandCollapseGroup name="Testimonials" nested={true} collapsed={true}>
            {this.renderRow('Testimonial 1', <TestimonialForm name="testimonial_1" testimonial={this.state.stylist.testimonial_1} onChange={this.onChange} />)}
            {this.renderRow('Testimonial 2', <TestimonialForm name="testimonial_2" testimonial={this.state.stylist.testimonial_2} onChange={this.onChange} />)}
            {this.renderRow('Testimonial 3', <TestimonialForm name="testimonial_3" testimonial={this.state.stylist.testimonial_3} onChange={this.onChange} />)}
            {this.renderRow('Testimonial 4', <TestimonialForm name="testimonial_4" testimonial={this.state.stylist.testimonial_4} onChange={this.onChange} />)}
            {this.renderRow('Testimonial 5', <TestimonialForm name="testimonial_5" testimonial={this.state.stylist.testimonial_5} onChange={this.onChange} />)}
            {this.renderRow('Testimonial 6', <TestimonialForm name="testimonial_6" testimonial={this.state.stylist.testimonial_6} onChange={this.onChange} />)}
            {this.renderRow('Testimonial 7', <TestimonialForm name="testimonial_7" testimonial={this.state.stylist.testimonial_7} onChange={this.onChange} />)}
            {this.renderRow('Testimonial 8', <TestimonialForm name="testimonial_8" testimonial={this.state.stylist.testimonial_8} onChange={this.onChange} />)}
            {this.renderRow('Testimonial 9', <TestimonialForm name="testimonial_9" testimonial={this.state.stylist.testimonial_9} onChange={this.onChange} />)}
            {this.renderRow('Testimonial 10', <TestimonialForm name="testimonial_10" testimonial={this.state.stylist.testimonial_10} onChange={this.onChange} />)}
          </ExpandCollapseGroup>
        </ExpandCollapseGroup>
      );
    }
  },

  /******************
  * Change Handlers *
  *******************/

  onChange: function (e) {
    var stylist = this.state.stylist;
    var target = e.target;
    var value = target.type === 'checkbox' ? target.checked : target.value;
    var name = target.name;

    //console.log('onChange', name, value);      

    stylist[name] = value;
    this.setState({stylist: stylist});
  },

  onChangeLocation: function (location) {
    var stylist = this.state.stylist;
    //stylist.location_id = location && location.id ? location.id : null;
    //stylist.location = location && location.id ? {id: location.id} : null;
    if (location && location.id) {
      stylist.location = {id: location.id};
      stylist.location_id = location.id;
    } else {
      stylist.location = null;
      stylist.location_id = null;
    }
    //console.log('onChangeLocation...',stylist.location,location);
    this.setState({stylist: stylist});
  },

  /******************
  * Button Handlers *
  *******************/

  onCancel: function (e) {
    e.preventDefault();
    e.stopPropagation();

    window.location.href = '/admin/stylist';
  },

  onSaveAndAddAnother: function (e) {
    var self = this;

    e.preventDefault();
    e.stopPropagation();

    this.save().done(function () {
      //self.setState({success: self.state.success + '. Redirecting to new stylist form...'});
      window.location.href = '/admin/stylist/new';
    });
  },  

  onSaveAndEdit: function (e) {
    var self = this;

    e.preventDefault();
    e.stopPropagation();

    this.save();
  },

  onSave: function (e) {
    var self = this;

    e.preventDefault();
    e.stopPropagation();

    this.save().done(function () {
      //self.setState({success: self.state.success + '. Redirecting to stylists...'});
      window.location.href = '/admin/stylist';
    });
  },

  /************
  * Utilities *
  *************/

  save: function () {
    var self = this;
    var deferred = $.Deferred();

    console.log('save stylist', this.state.stylist);

    this.setState({loading: true});
    
    $.ajax({
      type: 'POST',
      url: '/cms/save-stylist',
      data: {
        stylist: self.state.stylist,
      },
    }).done(function (data) {
      console.log('save stylist returned', data);
      
      if (data.errors) {
        self.setState({loading: false, errors: data.errors, success: null});
        deferred.reject();
      } else {
        self.setState({loading: false, errors: null, stylist: data.stylist, success: 'Stylist saved successfully!'});
        deferred.resolve();
      }

      self.scrollToTop();
    }); 

    return deferred; 
  },

  scrollToTop: function () {
    $("html, body").animate({scrollTop: 0}, "normal");
  },

});