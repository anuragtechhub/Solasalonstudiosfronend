var LeaseForm = React.createClass({

  getInitialState: function () {
    return {
      errors: null,
      lease: this.props.lease || {},
      location: this.getInitialLocation(),
      stylist: this.getInitialStylist(),
      success: null
    };
  }, 

  getInitialLocation: function () {
    if (this.props.lease && this.props.lease.location) {
      return this.props.lease.location;
    } else if (this.props.lease && this.props.lease.stylist && this.props.lease.stylist.location) {
      return this.props.lease.stylist.location;
    } else if (this.props.location) {
      return this.props.location;
    } else {
      return null;
    }
  },

  getInitialStylist: function () {
    if (this.props.lease && this.props.lease.stylist) {
      return this.props.lease.stylist;
    } else if (this.props.stylist) {
      return this.props.stylist;
    } else {
      return null;
    }
  },

  componentWillReceiveProps: function (nextProps) {
    if ((this.state.location == null && nextProps.location != null) || (nextProps.location && nextProps.location.id && this.state.location && nextProps.location.id != this.state.location.id)) {
      //console.log('set location in LeaseForm')
      this.setState({location: {id: nextProps.location.id}});
    }

    if ((this.state.stylist == null && nextProps.stylist != null) || (nextProps.stylist && nextProps.stylist.id && this.state.stylist && nextProps.stylist.id != this.state.stylist.id)) {
      //console.log('set stylist in LeaseForm');
      this.setState({stylist: {id: nextProps.stylist.id}});
    }   
  },

  render: function () {
    //console.log('render lease form', this.state.lease, this.state.location, this.state.lease.studio);
    return (
      <div className="lease-form">
        <div className="form-horizontal denser">

          {this.state.errors ? this.renderErrors() : null}
          {this.state.success ? this.renderSuccess() : null}

          {this.props.nested ? null : this.renderRow('Location', <LocationSelect location={this.state.location} onChange={this.onChangeLocation} />)}
          {this.props.nested || this.state.location == null ? null : this.renderRow('Stylist', <StylistSelect location={this.state.location} stylist={this.state.lease.stylist} onChange={this.onChangeStylist} />)}
          {this.state.location && this.state.stylist ? this.renderRow('Studio', <StudioSelect location={this.state.location} studio={this.state.lease.studio} onChange={this.onChangeStudio} />) : null}
          
          {this.renderLeaseFields()}

          {this.props.nested ? null : this.renderButtons()}
        </div>
      </div>
    );
  },

  renderLeaseFields: function () {
    if (this.state.location && this.state.stylist && this.state.lease.studio) {
      return (
        <div>
          {this.renderRow('Move In Date', <Datepicker name="move_in_date" value={this.state.lease.move_in_date} onChange={this.onChange} />, 'You can click the textbox above and use a datepicker or type the date in the format: January 1, 1979')}
          {this.renderRow('Start Date', <Datepicker name="start_date" value={this.state.lease.start_date} onChange={this.onChange} />, 'You can click the textbox above and use a datepicker or type the date in the format: January 1, 1979')}
          {this.renderRow('End Date', <Datepicker name="end_date" value={this.state.lease.end_date} onChange={this.onChange} />, 'You can click the textbox above and use a datepicker or type the date in the format: January 1, 1979')}
          {this.renderRow('License Fee Start Date', <Datepicker name="fee_start_date" value={this.state.lease.fee_start_date} onChange={this.onChange} />, 'You can click the textbox above and use a datepicker or type the date in the format: January 1, 1979')}

          {this.renderRow('Special Terms', <textarea name="special_terms" value={this.state.lease.special_terms} onChange={this.onChange} rows={7} style={{width: '100% !important'}} />)}

          <ExpandCollapseGroup name="Permitted Uses" nested={true} collapsed={false}>
            {this.renderRow('Facials', <Checkbox name="facial_permitted" value={this.state.lease.facial_permitted} onChange={this.onChange} />)}
            {this.renderRow('Hair Styling, Cutting, Coloring', <Checkbox name="hair_styling_permitted" value={this.state.lease.hair_styling_permitted} onChange={this.onChange} />)}
            {this.renderRow('Manicures / Pedicures', <Checkbox name="manicure_pedicure_permitted" value={this.state.lease.manicure_pedicure_permitted} onChange={this.onChange} />)}
            {this.renderRow('Massage', <Checkbox name="massage_permitted" value={this.state.lease.massage_permitted} onChange={this.onChange} />)}
            {this.renderRow('Waxing', <Checkbox name="waxing_permitted" value={this.state.lease.waxing_permitted} onChange={this.onChange} />)}
          </ExpandCollapseGroup>

          {/* Move In Bonus */}
          {this.renderRow('Move In Bonus', <Checkbox name="move_in_bonus_enabled" value={this.state.lease.move_in_bonus_enabled} onChange={this.onChange} />)}
          {!this.state.lease.move_in_bonus_enabled ? null : this.renderRow('Move In Bonus Amount', <CurrencyInput name="move_in_bonus_amount" value={this.state.lease.move_in_bonus_amount} onChange={this.onChange} />)}
          {!this.state.lease.move_in_bonus_enabled ? null : this.renderRow('Move In Bonus Payee', <input type="text" name="move_in_bonus_payee" value={this.state.lease.move_in_bonus_payee} onChange={this.onChange} />)}

          {/* Insurance */}
          {this.renderRow('Insurance', <Checkbox name="insurance_enabled" value={this.state.lease.insurance_enabled} onChange={this.onChange} />)}
          {!this.state.lease.insurance_enabled ? null : this.renderRow('Insurance Frequency', <select name="insurance_frequency" value={this.state.lease.insurance_frequency} onChange={this.onChange} className="form-control">
                                                   <option value="weekly">Weekly</option>
                                                   <option value="monthly">Monthly</option>
                                                   <option value="annually">Annually</option>
                                                 </select>)}
          {!this.state.lease.insurance_enabled ? null : this.renderRow('Insurance Amount', <CurrencyInput name="insurance_amount" value={this.state.lease.insurance_amount} onChange={this.onChange} />)}

          {/* Recurring Weekly Charges */}
          {this.renderRow('Recurring Weekly Charge 1', <RecurringChargeForm name="recurring_charge_1" value={this.state.lease.recurring_charge_1} onChange={this.onChange} />)}
          {this.renderRow('Recurring Weekly Charge 2', <RecurringChargeForm name="recurring_charge_2" value={this.state.lease.recurring_charge_2} onChange={this.onChange} />)}
          {this.renderRow('Recurring Weekly Charge 3', <RecurringChargeForm name="recurring_charge_3" value={this.state.lease.recurring_charge_3} onChange={this.onChange} />)}
          {this.renderRow('Recurring Weekly Charge 4', <RecurringChargeForm name="recurring_charge_4" value={this.state.lease.recurring_charge_4} onChange={this.onChange} />)}

          {this.renderRow('Security Deposit Amount', <CurrencyInput name="damage_deposit_amount" value={this.state.lease.damage_deposit_amount} onChange={this.onChange} />)}

          {this.renderRow('ACH Authorized', <Checkbox name="ach_authorized" value={this.state.lease.ach_authorized} onChange={this.onChange} />)}
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
    var self = this;
    var lease = this.state.lease;
    var target = e.target;
    var value = target.type === 'checkbox' ? target.checked : target.value;
    var name = target.name;

    console.log('onChange', name, value);      

    lease[name] = value;
    this.setState({lease: lease}, function () {
      self.fireOnChange();
    });
  },

  onChangeLocation: function (location) {
    var self = this;
    //this.state.location = location && location.id ? {id: location.id} : null;
    if (location && location.id) {
      this.state.location = {id: location.id};
      this.state.location_id = location.id;
    } else {
      this.state.location = null;
      this.state.location_id = null;
    }
    this.state.lease.stylist = null;
    this.state.lease.studio = null;
    this.setState({location: this.state.location, lease: this.state.lease}, function () {
      self.fireOnChange();
    });
  },

  onChangeStylist: function (stylist) {
    var self = this;
    //this.state.lease.stylist = stylist && stylist.id ? {id: stylist.id} : null;
    if (stylist && stylist.id) {
      this.state.lease.stylist = {id: stylist.id};
      this.state.lease.stylist_id = stylist.id;
    } else {
      this.state.lease.stylist = null;
      this.state.lease.stylist_id = null;
    }
    this.state.lease.studio = null;
    this.setState({lease: this.state.lease}, function () {
      self.fireOnChange();
    });
  },

  onChangeStudio: function (studio) {
    //console.log('onChangeStudio', studio);
    var self = this;
    this.state.lease.studio = studio && studio.id ? {id: studio.id} : null;
    if (studio && studio.id) {
      this.state.lease.studio = {id: studio.id};
      this.state.lease.studio_id = studio.id;
    } else {
      this.state.lease.studio = null;
      this.state.lease.studio_id = null;
    }
    this.setState({lease: this.state.lease}, function () {
      self.fireOnChange();
    });
  },

  fireOnChange: function () {
    if (this.props.onChange) {
      var lease = this.state.lease;
      lease.location = this.state.location;
      lease.stylist = this.state.stylist;
      console.log('firing Lease onChange', lease);
      this.props.onChange(lease);
    }     
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

    //console.log('save lease', this.state.lease);

    this.setState({loading: true});
    
    $.ajax({
      type: 'POST',
      url: '/cms/save-lease',
      data: {
        lease: {
          ach_authorized: this.state.lease.ach_authorized,
          damage_deposit_amount: this.state.lease.damage_deposit_amount,
          end_date: this.state.lease.end_date,
          facial_permitted: this.state.lease.facial_permitted,
          fee_start_date: this.state.lease.fee_start_date,
          hair_styling_permitted: this.state.lease.hair_styling_permitted,
          id: this.state.lease.id,
          location_id: this.state.location ? this.state.location.id : null,
          manicure_pedicure_permitted: this.state.lease.manicure_pedicure_permitted,
          massage_permitted: this.state.lease.massage_permitted,
          move_in_date: this.state.lease.move_in_date,
          special_terms: this.state.lease.special_terms,
          start_date: this.state.lease.start_date,
          studio_id: this.state.lease.studio ? this.state.lease.studio.id : null,
          stylist_id: this.state.stylist ? this.state.stylist.id : null,
          waxing_permitted: this.state.lease.waxing_permitted,
          weekly_fee_year_1: this.state.lease.weekly_fee_year_1,
          weekly_fee_year_2: this.state.lease.weekly_fee_year_2,
        },
      },
    }).done(function (data) {
      //console.log('save lease returned', data);
      
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