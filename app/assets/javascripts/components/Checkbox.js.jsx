var Checkbox = React.createClass({

  componentDidMount: function () {
    var self = this;

    if (this.refs.checkbox) {
      $(this.refs.checkbox).labelauty({
        //label: false,
        checked_label: self.props.checked_label || 'Yes',
        unchecked_label: self.props.checked_label || 'No',
        icon: true,
      });
    }
  },

  render: function () {
    return <input type="checkbox" ref="checkbox" onChange={this.props.onChange} name={this.props.name} value={this.props.value} />
  },

});