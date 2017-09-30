var ImageDropzone = React.createClass({

  getInitialState: function () {
    return {
      s3_fields: [],
      s3_url: '/',
      image_url: this.props.image_url || '',
      uploading: false,
    };
  },

  componentWillReceiveProps: function (nextProps) {
    if (nextProps.image_url) {
      this.setState({
        image_url: nextProps.image_url,
      });
    }
  },

  componentDidMount: function () {
    this.initDropzone();
  },

  componentDidUpdate: function () {
    this.initDropzone();     
  },

  initDropzone: function () {
    var self = this;

    if (this.refs.dropzone) {
      var $dropzone = $(this.refs.dropzone);
      
      if (!$dropzone.hasClass('dz-clickable')) { // don't re-init a dropzone
        $dropzone.dropzone({
          autoProcessQueue: false,
          uploadMethod: 'PUT',
          url: self.state.s3_url,
          addedfile: (file) => {
            //console.log('added file', file);
          },
          thumbnail: (file) => {
            //console.log('thumbnail file', file, file.width, file.height, file.name, file.type);
            self.setState({uploading: false})
            self.getPresignedPost(file.type).done((s3_fields, s3_url) => {
              //console.log('presigned post is DONE', s3_fields, s3_url);
              self.setState({s3_fields: s3_fields, s3_url: s3_url, uploading: true});
              Dropzone.forElement(self.refs.dropzone).processQueue();
            });
          },
          processing: function () {
            this.options.url = self.state.s3_url;
          },
          sending: function(file, xhr, formData) {
            for (d in self.state.s3_fields) {
              formData.append(d, self.state.s3_fields[d]);
            }
          },
          success: (file, response) => {
            var json = $.xml2json(response);
            //console.log('SUCCESS', json);
            
            var image = {
              url: json.PostResponse.Location.replace(/%2F/gi, '/'),
            }

            //console.log('set state image_url', image.url);

            self.setState({image_url: image.url, uploading: false}, function () {
              self.props.onChange({
                target: {
                  name: self.props.name,
                  value: image.url
                }
              });
            });
          }           
        });
      }
    }

    /* prevent window from loading dropped file that misses the dropzone */
    window.addEventListener("dragover", function (e) {
      e = e || event;
      e.preventDefault();
    }, false);

    window.addEventListener("drop", function (e) {
      e = e || event;
      e.preventDefault();
    }, false);     
  },

  getPresignedPost: function (contentType) {
    var self = this;
    var promise = $.Deferred();

    $.ajax({
      type: 'POST',
      url:  '/cms/s3-presigned-post',
      data: 'content_type=' + contentType
    }).error(function (data) {
      //console.log('getPresignedPost error', data)
    }).success(function (data) {
      //console.log('getPresignedPost success', data.fields, data.url, promise);
      promise.resolve(data.fields, data.url);
    });

    return promise;
  },

  render: function () {
    return (
      <div className="image-dropzone" data-id={this.props.id}>
        <div className="row">
          <div className={this.imageClasses()}>
            {this.state.uploading ? <div className="spinner" /> : null}
            {this.state.image_url ? <img src={this.state.image_url} /> : null}
            {this.state.image_url ? <div className="ss-delete" onClick={this.reset} /> : null}
            <a ref="dropzone" href="#" className="action" onClick={this.shhh} style={{display: this.state.image_url ? 'none' : 'block'}}>+ Add New Image</a>
          </div>
        </div>
      </div>
    );
  },

  imageClasses: function () {
    return classNames({
      'image': true,
      'exists': this.state.image_url,
    });
  },

  nameClasses: function () {
    return classNames({
      'name': true,
      'uploading': this.state.uploading,
    });
  },

  reset: function () {
    var state = this.getInitialState();
    state.image_url = ''
    this.setState(state);
  },

  shhh: function (event) {
    event.preventDefault();
  },

});