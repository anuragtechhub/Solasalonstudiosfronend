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
    return (
      <div className={"expand-collapse-group " + (this.props.nested ? "expand-collapse-group-nested" : '')} style={{marginTop: '15px'}}>
        <legend>
          <i className={this.state.collapsed ? "icon-chevron-right" : "icon-chevron-down"} onClick={this.onToggle}></i> 
          <span onClick={this.onToggle}>{this.props.name}</span> 
          {this.renderSwitch()}
        </legend>
        <div className="expand-collapse-content" ref="content">{this.props.children}</div>
      </div>
    );
  },

  renderSwitch: function () {
    if (this.props.switch) {
      //console.log('we have a switch!', this.props.switch, this.state.disabled);
      return (
        <Checkbox name={this.props.switch.name} value={this.props.switch.value} onChange={this.onChangeSwitch} />
      );
    } else {
      //console.log('no switch :(', this.props.switch);
    }
  },

  /******************
  * Change Handlers *
  *******************/

  onChangeSwitch: function (e) {
    // console.log('onChangeSwitch e.currentTarget.name', e.currentTarget.name, e.currentTarget.type);
    // console.log('onChangeSwitch e.target.name', e.target.name, e.target.type);//, e.target == e.currentTarget);
    //e.stopPropagation();

    var target = e.target;
    var value = target.type === 'checkbox' ? target.checked : target.value;
    var name = target.name;

    //console.log('onChangeSwitch name, value', name, value);

    if (this.props.onChangeSwitch) {
      this.props.onChangeSwitch(e);  
    }
  },

  onToggle: function (e) {
    //if (this.isDisabled()) {
    //  console.log('we have a switch and it is disabled! ignore toggle');
    //} else {
    //  console.log('no switch or enabled switch')
      this.setState({collapsed: !this.state.collapsed});
    //}
    // console.log('TOGGLE e.currentTarget.name', e.currentTarget.name, e.currentTarget.type);
    // console.log('TOGGLE e.target.name', e.target.name, e.target.type);//, e.target == e.currentTarget);
    //e.preventDefault();
    //e.stopPropagation();
    
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