var Datepicker = React.createClass({

  componentDidMount: function () {
    var self = this;

    if (this.refs.input) {
      $(this.refs.input).flatpickr({
        allowInput: true,
        dateFormat: 'F j, Y',
        defaultDate: self.parseDate(self.props.value),
        onChange: function (dates) {
          if (dates && dates.length > 0) {
            var date = dates[0];

            self.props.onChange({
              target: {
                name: self.props.name,
                value: date
              }
            });
          }
        }
      });
    }
  },

  render: function () {
    return <input name={this.props.name} ref="input" />
  },

  parseDate: function (date) {
    var datePieces = date.split('-');
    return new Date(datePieces[0], parseInt(datePieces[1]) - 1, datePieces[2]);
  },

});