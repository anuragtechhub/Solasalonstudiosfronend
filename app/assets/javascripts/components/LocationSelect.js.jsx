var LocationSelect = React.createClass({

  componentDidMount: function () {
    var self = this;

    if (this.refs.select) {
      $(this.refs.select).select2({
        theme: 'classic',
        width: '100%',
        ajax: {
          url: '/cms/locations-select',
          dataType: 'json',
          delay: 250,
          data: function (params) {
            return {
              q: params.term,
              page: params.page,
              results_per_page: 40
            };
          },
          processResults: function (data, params) {
            params.page = params.page || 1;

            return {
              results: data.items,
              pagination: {
                more: (params.page * 40) < data.total_count
              }
            };
          },
          cache: true
        },
        allowClear: true,
        placeholder: 'Choose...',
        templateResult: function (location) {
          if (location.loading || location.id == '') {
            return location.text;
          }

          return self.renderLocationName(location);
        },
        templateSelection: function (location) {
          if (location && location.id != null && location.id != '') {
            if (!self.props.location || self.props.location.id != location.id) {
              //console.log('locationselect onchange!', location.id, self.props.location)
              self.props.onChange(location);
            }

            if (location.name) {
              return self.renderLocationName(location);
            } else {
              return location.text;
            }
          } else {
            return location.text;
          }
        }
      }).on('select2:unselect', function () {
        self.props.onChange(null);
      });
    }
  },

  render: function () {
    return (
      <div style={{maxWidth: '443px'}}>
        <select ref="select">
          {this.props.location ? <option value={this.props.location.id}>{this.renderLocationName(this.props.location)}</option> : null}
        </select>
      </div>
    );
  },

  renderLocationName: function (location) {
    return location.name + ' (' + location.city + ', ' + location.state + ')';
  },

});