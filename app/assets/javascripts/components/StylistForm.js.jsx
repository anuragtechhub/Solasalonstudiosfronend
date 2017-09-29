var StylistForm = React.createClass({

  render: function () {
    return (
      <div className="form-horizontal denser">
        stylist form {this.props.stylist.id} {this.props.stylist.name}
        {this.renderRow('Location', <LocationSelect />)}
      </div>
    );
  },

  renderRow: function (name, input) {
    return (
      <div className="control-group">
        <label className="control-label">{name}</label>
        <div className="controls">
          {input}
          {/*<input id="location_name" maxlength="255" name="location[name]" size="50" type="text" value="South Broadway Test" />
          <p className="help-block">Required. Length up to 255.</p>*/}
        </div>
      </div>
    );
  },

});