var EnumSelect = React.createClass({

  componentDidMount: function () {
    var self = this;

    //console.log('EnumSelect', this.props.name, this.props.value);

    if (this.refs.select) {
      $(this.refs.select).select2({
        minimumResultsForSearch: Infinity,
        theme: 'classic',
      });

      $(this.refs.select).on('change', function () {
        self.props.onChange({
          target: {
            name: self.props.name,
            value: $(self.refs.select).val(),
          }
        });
      }).val(this.props.value ? this.props.value.toString() : this.props.value).trigger('change');
    }
  },

  render: function () {

    var options = this.props.values.map(function (value) {
      return <option key={value[1]} value={value[1]}>{value[0]}</option>
    });

    return (
      <select ref="select" name={this.props.name}>{options}</select>
    );
  },

});