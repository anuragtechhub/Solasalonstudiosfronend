var RecurringChargeForm = React.createClass({

  getInitialState: function () {
    //console.log('RecurringChargeForm getInitialState', this.props.value);

    return {
      recurring_charge: this.props.value || {}
    };
  },

  render: function () {
    //console.log('RecurringChargeForm render', this.state.recurring_charge);

    return (
      <div className="recurring-charge-form">
        <div className="nested-form-row">
          <label>Start Date</label>
          <Datepicker name="start_date" value={this.state.recurring_charge.end_date} onChange={this.onChange} />
        </div>
        <div className="nested-form-row">
          <label>End Date</label>
          <Datepicker name="end_date" value={this.state.recurring_charge.end_date} onChange={this.onChange} />
        </div>
        <div className="nested-form-row">
          <label>Weekly Fee</label>
          <CurrencyInput name="amount" value={this.state.recurring_charge.amount} onChange={this.onChange} />
        </div>
      </div>
    );
  },

  /******************
  * Change Handlers *
  *******************/

  onChange: function (e) {
    var self = this;
    var recurring_charge = this.state.recurring_charge;
    var target = e.target;
    var value = target.type === 'checkbox' ? target.checked : target.value;
    var name = target.name;

    //console.log('RecurringChargeForm onChange', name, value);      

    recurring_charge[name] = value;
    this.setState({recurring_charge: recurring_charge}, function () {
      if (self.props.onChange) {
        self.props.onChange({
          target: {
            name: self.props.name,
            value: self.state.recurring_charge,
          }
        })
      }
    });
  },  

});