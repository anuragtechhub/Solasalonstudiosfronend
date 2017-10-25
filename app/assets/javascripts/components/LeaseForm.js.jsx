var LeaseForm = React.createClass({

  getInitialState: function () {
    return {
      errors: null,
      lease: this.props.lease || {},
      location: this.props.lease && this.props.lease.location ? this.props.lease.location : null,
      success: null
    };
  }, 

  componentWillReceiveProps: function (nextProps) {
    if (nextProps.location && nextProps.location.id && nextProps.location.id != this.state.location.id) {
      //console.log('lease location_id changed');
      this.setState({location: {id: nextProps.location.id}});
    }
  },

  render: function () {
    //console.log('render lease form', this.state.lease, this.state.location);
    return (
      <div className="lease-form">
        <div className="form-horizontal denser">

          {this.state.errors ? this.renderErrors() : null}
          {this.state.success ? this.renderSuccess() : null}

          {this.props.nested ? null : this.renderRow('Location', <LocationSelect location={this.state.location} onChange={this.onChangeLocation} />)}
          {this.props.nested || this.state.location == null ? null : this.renderRow('Stylist', <StylistSelect location={this.state.location} stylist={this.state.lease.stylist} onChange={this.onChangeStylist} />)}
          {this.state.location && this.state.lease.stylist ? this.renderRow('Studio', <StudioSelect location={this.state.location} studio={this.state.lease.studio} onChange={this.onChangeStudio} />) : null}
          
          {this.renderLeaseFields()}

          {this.props.nested ? null : this.renderButtons()}
        </div>
      </div>
    );
  },

  renderLeaseFields: function () {
    if (this.state.location && this.state.lease.stylist && this.state.lease.studio) {
      return (
        <div>
          {this.renderRow('Start Date', <Datepicker name="start_date" value={this.state.lease.start_date} onChange={this.onChange} />, 'You can click the textbox above and use a datepicker or type the date in the format: January 1, 1979')}
          {this.renderRow('End Date', <Datepicker name="end_date" value={this.state.lease.end_date} onChange={this.onChange} />, 'You can click the textbox above and use a datepicker or type the date in the format: January 1, 1979')}
          {this.renderRow('Move In Date', <Datepicker name="move_in_date" value={this.state.lease.move_in_date} onChange={this.onChange} />, 'You can click the textbox above and use a datepicker or type the date in the format: January 1, 1979')}
          {this.renderRow('Fee Start Date', <Datepicker name="fee_start_date" value={this.state.lease.fee_start_date} onChange={this.onChange} />, 'You can click the textbox above and use a datepicker or type the date in the format: January 1, 1979')}

          {this.renderRow('Weekly Fee Year 1', <CurrencyInput name="weekly_fee_year_1" value={this.state.lease.weekly_fee_year_1} onChange={this.onChange} />)}
          {this.renderRow('Weekly Fee Year 2', <CurrencyInput name="weekly_fee_year_2" value={this.state.lease.weekly_fee_year_2} onChange={this.onChange} />)}
          {this.renderRow('Damage Deposit Amount', <CurrencyInput name="damage_deposit_amount" value={this.state.lease.damage_deposit_amount} onChange={this.onChange} />)}

          {/*
          {this.renderRow('Product Bonus Amount', <CurrencyInput name="product_bonus_amount" value={this.state.lease.product_bonus_amount} onChange={this.onChange} />)}
          {this.renderRow('Product Bonus Distributor', <input name="product_bonus_distributor" value={this.state.lease.product_bonus_distributor} onChange={this.onChange} maxLength="255" type="text" />)}

          
          {this.renderRow('Sola Provided Insurance', <EnumSelect name="sola_provided_insurance" value={this.state.lease.sola_provided_insurance} values={[['Yes', true], ['No', false]]} onChange={this.onChange} />)}
          {this.renderRow('Sola Provided Insurance Frequency', <input name="sola_provided_insurance_frequency" value={this.state.lease.sola_provided_insurance_frequency} onChange={this.onChange} maxLength="255" type="text" />)}
          */}

          {this.renderRow('ACH Authorized', <Checkbox name="ach_authorized" value={this.state.lease.ach_authorized} onChange={this.onChange} />)}
          {this.renderRow('Special Terms', <textarea name="special_terms" value={this.state.lease.special_terms} onChange={this.onChange} rows={5} />)}
  
          <ExpandCollapseGroup name="Permitted Uses" nested={true} collapsed={true}>
            {this.renderRow('Facials', <Checkbox name="facial_permitted" value={this.state.lease.facial_permitted} onChange={this.onChange} />)}
            {this.renderRow('Hair Styling, Cutting, Coloring', <Checkbox name="hair_styling_permitted" value={this.state.lease.hair_styling_permitted} onChange={this.onChange} />)}
            {this.renderRow('Manicures / Pedicures', <Checkbox name="manicure_pedicure_permitted" value={this.state.lease.manicure_pedicure_permitted} onChange={this.onChange} />)}
            {this.renderRow('Massage', <Checkbox name="massage_permitted" value={this.state.lease.massage_permitted} onChange={this.onChange} />)}
            {this.renderRow('Waxing', <Checkbox name="waxing_permitted" value={this.state.lease.waxing_permitted} onChange={this.onChange} />)}
          </ExpandCollapseGroup>
        </div>
      );
    }
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

  /******************
  * Change Handlers *
  *******************/

  onChange: function (e) {
    var lease = this.state.lease;
    var target = e.target;
    var value = target.type === 'checkbox' ? target.checked : target.value;
    var name = target.name;

    //console.log('onChange', name, value);      

    lease[name] = value;
    this.setState({lease: lease});
  },

  onChangeLocation: function (location) {
    this.state.location = location && location.id ? {id: location.id} : null;
    this.state.lease.stylist = null;
    this.state.lease.studio = null;
    this.setState({location: this.state.location, lease: this.state.lease});
  },

  onChangeStylist: function (stylist) {
    this.state.lease.stylist = stylist && stylist.id ? {id: stylist.id} : null;
    this.state.lease.studio = null;
    this.setState({lease: this.state.lease});
  },

  onChangeStudio: function (studio) {
    this.state.lease.studio = studio && studio.id ? {id: studio.id} : null;
    this.setState({lease: this.state.lease});
  },

  /******************
  * Button Handlers *
  *******************/

  onCancel: function (e) {
    e.preventDefault();
    e.stopPropagation();

    window.location.href = '/admin/lease';
  },

  onSaveAndAddAnother: function (e) {
    var self = this;

    e.preventDefault();
    e.stopPropagation();

    this.save().done(function () {
      //self.setState({success: self.state.success + '. Redirecting to new lease form...'});
      window.location.href = '/admin/lease/new';
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
      //self.setState({success: self.state.success + '. Redirecting to leases...'});
      window.location.href = '/admin/lease';
    });
  },

  /************
  * Utilities *
  *************/

  save: function () {
    var self = this;
    var deferred = $.Deferred();

    console.log('save lease', this.state.lease);

    this.setState({loading: true});
    
    $.ajax({
      type: 'POST',
      url: '/cms/save-lease',
      data: {
        lease: self.state.lease,
      },
    }).done(function (data) {
      console.log('save lease returned', data);
      
      if (data.errors) {
        self.setState({loading: false, errors: data.errors, success: null});
        deferred.reject();
      } else {
        self.setState({loading: false, errors: null, lease: data.lease, success: 'Lease saved successfully!'});
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