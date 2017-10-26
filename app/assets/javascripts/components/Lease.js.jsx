var Lease = React.createClass({

  render: function () {
    return (
      <div style={{marginTop: '15px'}}>
        <table className="table model-table">
          <thead>
            <tr>
              <th>Studio</th>
              <th>Start Date</th>
              <th>End Date</th>
              <th>Agreement File</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>{this.props.lease.studio.name}</td>
              <td>{this.props.lease.start_date}</td>
              <td>{this.props.lease.end_date}</td>
              <td><a href={this.props.lease.agreement_file_url} target="_blank">{this.props.lease.agreement_file_url}</a></td>
            </tr>
          </tbody>
        </table>
      </div>
    );
  }

});