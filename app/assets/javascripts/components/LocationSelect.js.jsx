var LocationSelect = React.createClass({

  // componentDidMount: function () {
  //   $(this.refs.select).select2({
  //     theme: "classic"
  //   });
  // },

  // render: function () {
  //   return (
  //     <select ref="select">
  //       <option value="1">L1</option>
  //       <option value="2">L2</option>
  //     </select>
  //   );
  // },

  componentDidMount: function () {
    var self = this;

    if (this.refs.select) {
      $(this.refs.select).select2({
        theme: 'classic',
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
        // escapeMarkup: function (markup) { 
        //   return markup; 
        // },
        placeholder: 'Choose...',
        templateResult: function (location) {
          if (location.loading || location.id == '') {
            return location.text;
          }

          return location.name;
        },
        templateSelection: function (location) {
          if (location && location.id != null && location.id != '') {
            self.props.onChange(location);

            if (location.name) {
              return location.name;
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
    if (this.props.read_only) {
      return (
        <div>{this.props.location ? this.props.location.name : null}</div>
      );
    } else {
      return (
        <select ref="select">
          {this.props.location ? <option value={this.props.location.id}>{this.props.location.name}</option> : null}
        </select>
      );
    }
  },

});