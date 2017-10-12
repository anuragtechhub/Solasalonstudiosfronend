var StudioSelect = React.createClass({

  componentDidMount: function () {
    var self = this;

    if (this.refs.select) {
      $(this.refs.select).select2({
        theme: 'classic',
        width: '100%',
        ajax: {
          url: '/cms/studios-select',
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
        templateResult: function (studio) {
          if (studio.loading || studio.id == '') {
            return studio.text;
          }

          return self.renderStudioName(studio);
        },
        templateSelection: function (studio) {
          if (studio && studio.id != null && studio.id != '') {
            self.props.onChange(studio);

            if (studio.name) {
              return self.renderStudioName(studio);
            } else {
              return studio.text;
            }
          } else {
            return studio.text;
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
          {this.props.studio ? <option value={this.props.studio.id}>{this.renderStudioName(this.props.studio)}</option> : null}
        </select>
      </div>
    );
  },

  renderStudioName: function (studio) {
    return studio.name;
  },

});