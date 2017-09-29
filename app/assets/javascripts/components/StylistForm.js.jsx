var StylistForm = React.createClass({

  getInitialState: function () {
    return {
      stylist: this.props.stylist,
    };
  },

  render: function () {
    return (
      <div className="stylist-form">
        <div className="form-horizontal denser">
          {this.renderRow('Location', <LocationSelect location={this.props.stylist.location} onChange={this.onChangeLocation} />)}

          {this.renderButtons()}
        </div>
      </div>
    );
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

  /******************
  * Change Handlers *
  *******************/

  onChangeLocation: function (location) {
    var stylist = this.state.stylist;
    stylist.location = location;
    this.setState({stylist: stylist});
  },

  /******************
  * Button Handlers *
  *******************/

  onCancel: function (e) {
    e.preventDefault();
    e.stopPropagation();
    window.history.back();
  },

  onSaveAndAddAnother: function (e) {
    e.preventDefault();
    e.stopPropagation();
    console.log('onSaveAndAddAnother');
  },  

  onSaveAndEdit: function (e) {
    e.preventDefault();
    e.stopPropagation();
    console.log('onSaveAndEdit');
  },

  onSave: function (e) {
    e.preventDefault();
    e.stopPropagation();
    console.log('onSave');
  },

});