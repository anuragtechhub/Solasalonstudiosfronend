var Dropzone = React.createClass({

  getInitialState: function () {
    return {
      s3_fields: [],
      s3_url: '/',
      image_name: this.props.name,
      image_url: this.props.url,
      image_height: this.props.height,
      image_width: this.props.width,
      uploading: false,
    };
  },

  componentWillReceiveProps: function (nextProps) {
    if (nextProps.url && nextProps.name && nextProps.height && nextProps.width) {
      this.setState({
        image_name: nextProps.name,
        image_url: nextProps.url,
        image_height: nextProps.height,
        image_width: nextProps.width
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
          clickable: ['.action', '.action-camera-and-text'],
          uploadMethod: 'PUT',
          url: self.state.s3_url,
          addedfile: (file) => {
            //console.log('added file', file);
          },
          thumbnail: (file) => {
            //console.log('thumbnail file', file, file.width, file.height, file.name, file.type);
            self.setState({image_width: file.width, image_height: file.height, image_name: file.name, uploading: false})
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
              id: self.props.id,
              url: json.PostResponse.Location.replace(/%2F/gi, '/'),
              name: self.state.image_name,
              width: self.state.image_width,
              height: self.state.image_height,
            }

            self.setState({image_url: image.url, uploading: false});

            if (typeof self.props.onChange == 'function') {
              self.props.onChange(image);
            }
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
      url: '/mysola/s3-presigned-post',
      data: 'type=' + this.props.type + '&content_type=' + contentType
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
        <div className={this.imageClasses()}>
          {this.state.image_name && this.state.uploading ? <div className="spinner-icon" /> : null}
          {this.state.image_name ? <div className={this.nameClasses()} style={{opacity: this.state.uploading ? 0.33 : 1}}>{this.state.image_name}</div> : null}
          {this.state.image_url ? <div className="delete-icon" onClick={this.remove} /> : null}
          <a ref="dropzone" href="#" className="action" onClick={this.shhh} style={{display: this.state.image_name ? 'none' : 'block'}}><div className="action-camera-and-text">{this.props.addNewText || 'Upload a photo'}</div></a>
        </div>
      </div>
    );
  },

  triggerActionClick: function () {
    console.log('trigger action click');
    $(this.refs.dropzone).trigger('click');
  },

  imageClasses: function () {
    return this.classNames({
      'image': true,
      'exists': this.state.image_url,
    });
  },

  nameClasses: function () {
    return this.classNames({
      'name': true,
      'uploading': this.state.uploading,
    });
  },

  classNames: function () {
    var hasOwn = {}.hasOwnProperty;
    var classes = [];

    for (var i = 0; i < arguments.length; i++) {
      var arg = arguments[i];
      if (!arg) continue;

      var argType = typeof arg;

      if (argType === 'string' || argType === 'number') {
        classes.push(arg);
      } else if (Array.isArray(arg)) {
        classes.push(classNames.apply(null, arg));
      } else if (argType === 'object') {
        for (var key in arg) {
          if (hasOwn.call(arg, key) && arg[key]) {
            classes.push(key);
          }
        }
      }
    }

    return classes.join(' ');
  },

  remove: function () {
    this.setState({
      image_name: null,
      image_url: null,
      image_height: null,
      image_width: null,
    }, () => {
      if (typeof this.props.onChange == 'function') {
        var image = {
          id: this.props.id,
          url: null,
          height: null,
          width: null,
          name: null,
        };

        this.props.onChange(image);
      }   
    });
  },

  reset: function () {
    this.setState(this.getInitialState());

    if (typeof this.props.onChange == 'function') {
      var image = {
        id: this.props.id,
        url: null,
        height: null,
        width: null,
        name: null,
      };

      this.props.onChange(image);
    }    
  },

  shhh: function (event) {
    event.preventDefault();
  },

});