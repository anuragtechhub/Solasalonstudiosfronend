var LocationSelect = React.createClass({

  componentDidMount: function () {
    $(this.refs.select).select2({
      theme: "classic"
    });
  },

  render: function () {
    return (
      <select ref="select">
        <option value="1">L1</option>
        <option value="2">L2</option>
      </select>
    );
  },

});
