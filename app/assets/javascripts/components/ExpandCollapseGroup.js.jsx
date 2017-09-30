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
    console.log('render ExpandCollapseGroup', this.props);

    return (
      <div className={"expand-collapse-group " + (this.props.type == 'nested' ? "expand-collapse-group-nested" : null)} style={{marginTop: '15px'}}>
        <legend onClick={this.onToggle}><i className={this.state.collapsed ? "icon-chevron-up" : "icon-chevron-down"}onClick={this.onToggle}></i> {this.props.name}</legend>
        <div className="expand-collapse-content" ref="content">{this.props.children}</div>
      </div>
    );
  },

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

  onToggle: function (e) {
    e.preventDefault();
    e.stopPropagation();
    this.setState({collapsed: !this.state.collapsed});
  }

});