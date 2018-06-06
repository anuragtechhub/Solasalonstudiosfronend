var Sola10kImageDropzone = React.createClass({

  getInitialState: function () {
    return {
      image: null,
      loading: false,
    };
  },

  componentDidMount: function () {
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
          url: 'sola10k-image-upload',
          addedfile: (file) => {
            //shhh...
          },
          thumbnail: (file) => {
            //console.log('thumbnail file', file, file.width, file.height, file.name, file.type);
            self.setState({loading: true}, () => {
              Dropzone.forElement(self.refs.dropzone).processQueue();
            });
          },
          processing: function () {
            //shhh...
          },
          sending: function(file, xhr, formData) {
            //shhh...
          },
          success: (file, response) => {
            //console.log('SUCCESS1', file, response);

            self.setState({image: response});
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

  render: function () {
    return (
      <div className="image-dropzone sola10k-dropzone" data-id={this.props.id}>
        <div className={this.imageClasses()}>
          {this.state.loading ? <div className="loading"><div className="spinner"></div></div> : null}
          {this.state.image ? <img src={this.getImageSource()} className="dropzone-image" onLoad={this.onLoad} style={{display: this.state.loading ? 'none' : 'block'}} /> : null}
          <a ref="dropzone" href="#" className="action" onClick={this.shhh} style={{display: this.state.image ? 'none' : 'block'}}><div className="action-camera-and-text">{this.props.addNewText || 'Upload or drag a photo'}</div></a>
        </div>
      </div>
    );
  },

  getImageSource: function () {
    return '/sola10k-image-preview/' + this.state.image.public_id + '?statement=' + this.props.statement + '&instagram_handle=' + this.props.instagram_handle + '&name=' + this.props.name;
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

  imageClasses: function () {
    return this.classNames({
      'image': true,
      'exists': this.state.image,
    });
  },

  onLoad: function () {
    if (this.state.image && typeof this.props.onChangeImage == 'function') {
      this.props.onChangeImage(this.state.image);
    }

    this.setState({loading: false});
  },

  reset: function () {
    this.setState(this.getInitialState()); 
  },

  shhh: function (event) {
    event.preventDefault();
  },

});