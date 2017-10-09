var LeaseForm = React.createClass({

  getInitialState: function () {
    return {
      lease: this.props.lease || {},
    };
  },

  render: function () {
    return (
      <div className="lease-form">
        Lease Form
      </div>
    );
  },

});