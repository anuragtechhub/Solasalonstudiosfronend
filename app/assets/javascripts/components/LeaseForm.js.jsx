var LeaseForm = React.createClass({

  getInitialState: function () {
    return {
      lease: this.props.lease || {},
    };
  },

  render: function () {
    return (
      <div className="lease-form">
        <div className="form-horizontal denser">

          {this.renderRow('Location', <LocationSelect location={this.state.lease.location} onChange={this.onChangeLocation} />)}
          {this.renderRow('Stylist', <StylistSelect location={this.state.lease.location} stylist={this.state.lease.stylist} onChange={this.onChangeStylist} />)}
          {this.renderRow('Studio', <StudioSelect location={this.state.lease.location} studio={this.state.lease.studio} onChange={this.onChangeStudio} />)}
        
          {/*}
          {this.renderRow('Status', <EnumSelect name="status" value={this.state.stylist.status} values={[['Open', 'open'], ['Closed', 'closed']]} onChange={this.onChange} />)}
          {this.renderRow('Name', <input name="name" value={this.state.stylist.name} onChange={this.onChange} maxLength="255" type="text" />)}
          {this.renderRow('Date of Birth', <Datepicker name="date_of_birth" value={this.state.stylist.date_of_birth} onChange={this.onChange} />, 'You can click the textbox above and use a datepicker or type the date in the format: January 1, 1979')}
          */}
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

    console.log('onChange', name, value);      

    lease[name] = value;
    this.setState({lease: lease});
  },

  onChangeLocation: function (location) {
    var lease = this.state.lease;
    lease.location_id = location.id;
    this.setState({lease: lease});
  },

  onChangeStylist: function (stylist) {
    var lease = this.state.lease;
    lease.stylist_id = stylist.id;
    this.setState({lease: lease});
  },

  onChangeStudio: function (studio) {
    var lease = this.state.lease;
    lease.studio_id = studio.id;
    this.setState({lease: lease});
  },

});