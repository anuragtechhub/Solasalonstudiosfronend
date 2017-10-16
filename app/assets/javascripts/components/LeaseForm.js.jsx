var LeaseForm = React.createClass({

  getInitialState: function () {
    return {
      lease: this.props.lease || {},
      location: this.props.lease && this.props.lease.location ? this.props.lease.location : {}
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

          {this.props.nested ? null : this.renderRow('Location', <LocationSelect location={this.state.lease.location} onChange={this.onChangeLocation} />)}
          {this.props.nested ? null : this.renderRow('Stylist', <StylistSelect location={this.state.lease.location} stylist={this.state.lease.stylist} onChange={this.onChangeStylist} />)}
          {this.renderRow('Studio', <StudioSelect location={this.state.lease.location} studio={this.state.lease.studio} onChange={this.onChangeStudio} />)}
          
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

          {this.renderRow('ACH Authorized', <EnumSelect name="ach_authorized" value={this.state.lease.ach_authorized} values={[['Yes', true], ['No', false]]} onChange={this.onChange} />)}
          {this.renderRow('Special Terms', <textarea name="special_terms" value={this.state.lease.special_terms} onChange={this.onChange} rows={5} />)}
  
          <ExpandCollapseGroup name="Permitted Uses" nested={true} collapsed={true}>
            {this.renderRow('Facials', <Checkbox name="facial_permitted" value={this.state.lease.facial_permitted} onChange={this.onChange} />)}
            {this.renderRow('Hair Styling, Cutting, Coloring', <Checkbox name="hair_styling_permitted" value={this.state.lease.hair_styling_permitted} onChange={this.onChange} />)}
            {this.renderRow('Manicures / Pedicures', <Checkbox name="manicure_pedicure_permitted" value={this.state.lease.manicure_pedicure_permitted} onChange={this.onChange} />)}
            {this.renderRow('Massage', <Checkbox name="massage_permitted" value={this.state.lease.massage_permitted} onChange={this.onChange} />)}
            {this.renderRow('Waxing', <Checkbox name="waxing_permitted" value={this.state.lease.waxing_permitted} onChange={this.onChange} />)}
          </ExpandCollapseGroup>
        </div>
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
    var lease = this.state.lease;
    var target = e.target;
    var value = target.type === 'checkbox' ? target.checked : target.value;
    var name = target.name;

    //console.log('onChange', name, value);      

    lease[name] = value;
    this.setState({lease: lease});
  },

  onChangeLocation: function (location) {
    var location = this.state.location;
    location = location && location.id ? {id: location.id} : {};
    this.setState({location: location});
  },

  onChangeStylist: function (stylist) {
    var lease = this.state.lease;
    lease.stylist = stylist && stylist.id ? {id: stylist.id} : null;
    this.setState({lease: lease});
  },

  onChangeStudio: function (studio) {
    var lease = this.state.lease;
    lease.studio = studio && studio.id ? {id: studio.id} : null;
    this.setState({lease: lease});
  },

});