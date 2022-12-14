var StylistSelect = React.createClass({

  componentDidMount: function () {
    var self = this;

    if (this.refs.select) {
      $(this.refs.select).select2({
        theme: 'classic',
        width: '100%',
        language: {
          noResults: function (params) {
            return "There are no stylists for this location";
          }
        },
        ajax: {
          url: '/cms/stylists-select',
          dataType: 'json',
          delay: 250,
          data: function (params) {
            return {
              q: params.term,
              page: params.page,
              results_per_page: 40,
              location_id: self.props.location ? self.props.location.id : null,
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
        templateResult: function (stylist) {
          if (stylist.loading || stylist.id == '') {
            return stylist.text;
          }

          return self.renderStylistName(stylist);
        },
        templateSelection: function (stylist) {
          if (stylist && stylist.id != null && stylist.id != '') {
            self.props.onChange(stylist);

            if (stylist.name) {
              return self.renderStylistName(stylist);
            } else {
              return stylist.text;
            }
          } else {
            return stylist.text;
          }
        }
      }).on('select2:unselect', function () {
        self.props.onChange(null);
      });
    }
  },

  componentWillReceiveProps: function (nextProps) {
    if (nextProps.stylist == null && this.refs.select) {
      $(this.refs.select).val(null).trigger('change');
    }
  },  

  render: function () {
    return (
      <div style={{maxWidth: '444px'}}>
        <select ref="select">
          {this.props.stylist ? <option value={this.props.stylist.id}>{this.renderStylistName(this.props.stylist)}</option> : null}
        </select>
      </div>
    );
  },

  renderStylistName: function (stylist) {
    return stylist.name + ((stylist.email_address || stylist.website_email_address) ? (' (' + (stylist.email_address || stylist.website_email_address) + ')') : '');
  },

  shouldComponentUpdate: function () {
    return false;
  },

});