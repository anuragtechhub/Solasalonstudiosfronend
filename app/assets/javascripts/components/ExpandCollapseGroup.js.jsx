var ExpandCollapseGroup = React.createClass({

  getInitialState: function () {
    return {
      collapsed: this.props.collapsed || false,
    };
  },

  componentDidMount: function () {
    this.animateCollapsed(false);
  },

  componentDidUpdate: function (prevProps, prevState) {
    if (prevState.collapsed !== this.state.collapsed) {
      this.animateCollapsed();
    }
  },

  render: function () {
    console.log('RENDER this.state.collapsed', this.state.collapsed)
    return (
      <div className={"expand-collapse-group " + (this.props.nested ? "expand-collapse-group-nested" : '') + (this.isDisabled() ? "expand-collapse-group-disabled" : '')} style={{marginTop: '15px'}}>
        <legend>
          <i className={this.state.collapsed ? "chevron-right" : "chevron-down"} onClick={this.onToggle}></i> 
          <span className="name" onClick={this.onToggle}>{this.props.name}</span> 
          {this.renderSwitch()}
        </legend>
        <div className="expand-collapse-content" ref="content">{this.props.children}</div>
      </div>
    );
  },

  renderSwitch: function () {
    if (this.props.switch) {
      return (
        <Checkbox name={this.props.switch.name} 
                  value={this.props.switch.value} 
                  onChange={this.onChangeSwitch} 
                  checkedLabel="Enabled"
                  uncheckedLabel="Disabled"
        />
      );
    }
  },

  /******************
  * Change Handlers *
  *******************/

  onChangeSwitch: function (e) {
    var target = e.target;
    var value = target.type === 'checkbox' ? target.checked : target.value;
    var name = target.name;

    if (this.props.onChangeSwitch) {
      this.props.onChangeSwitch(e);  
    }
  },

  onToggle: function (e) {
    if (this.isDisabled()) {
      console.log('disabled!!! do nothing', this.state.collapsed);
    } else {
      console.log('toggle!', this.state.collapsed);
      this.setState({collapsed: !this.state.collapsed});
    }
  },

  /*******************
  * Helper Functions *
  ********************/

  animateCollapsed: function (animated) {
    if (this.state.collapsed) {
      if (animated === false) {
        $(this.refs.content).hide();
      } else {
        $(this.refs.content).slideUp('normal');
      }   
    } else {
      if (animated === false) {
        $(this.refs.content).show();
      } else {
        $(this.refs.content).slideDown('normal');
      } 
    }
  },

  isDisabled: function () {
    return this.props.switch && this.props.switch.value === false;
  },

});