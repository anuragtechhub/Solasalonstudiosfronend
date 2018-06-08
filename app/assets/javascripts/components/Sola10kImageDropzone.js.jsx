var Sola10kImageDropzone = React.createClass({

  getInitialState: function () {
    var isMobile = false; //initiate as false
    // device detection
    if (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navigator.userAgent) 
        || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navigator.userAgent.substr(0,4))) { 
        isMobile = true;
    }

    return {
      image: null,
      isMobile: isMobile,
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

  componentDidUpdate: function () {
    var self = this;
    var $image = $(this.refs.image);

    if ($image && $image.length) {
      if ($image.hasClass('hammertime')) {
        // already initted - don't reinit
      } else {
        // color swipe left/right
        $image.addClass('hammertime');
        var mc = new Hammer(this.refs.image, {domEvents: true});
        mc.on('swipeleft', function(ev) {
          if (self.props.color == 'blue') {
            self.props.onChangeColor('pink');
          } else if (self.props.color == 'pink') {
            self.props.onChangeColor('black');
          } else if (self.props.color == 'black') {
            self.props.onChangeColor('blue');
          }
        });
        mc.on('swiperight', function(ev) {
          if (self.props.color == 'blue') {
            self.props.onChangeColor('black');
          } else if (self.props.color == 'pink') {
            self.props.onChangeColor('blue');
          } else if (self.props.color == 'black') {
            self.props.onChangeColor('pink');
          }
        });
      }
    }
  },

  componentWillReceiveProps: function (nextProps) {
    if (this.state.image && (nextProps.statement != '' && nextProps.statement != this.props.statement) || (nextProps.color != 'blue' && nextProps.color != this.props.color)) {
      this.setState({loading: true});
    }
  },

  render: function () {
    return (
      <div className="image-dropzone sola10k-dropzone" data-id={this.props.id}>
        <div className={this.imageClasses()}>
          {this.state.loading ? <div className="loading"><div className="spinner"></div></div> : null}
          {this.state.image ? <img ref="image" src={this.getImageSource()} className="dropzone-image" onLoad={this.onLoad} style={{display: this.state.image ? 'block' : 'none'}} /> : null}
          {this.state.isMobile && this.state.image && !this.state.loading && (this.props.statement == null || this.props.statement == '') ? <div className="swipe-to-change-color">SWIPE TO CHANGE COLOR</div> : null}
          <a ref="dropzone" href="#" className="action" onClick={this.shhh} style={{display: this.state.image ? 'none' : 'block'}}><div className="action-camera-and-text">{this.props.addNewText || 'Upload or drag a photo'}</div></a>
        </div>
      </div>
    );
  },

  getImageSource: function () {
    return '/sola10k-image-preview/' + this.state.image.public_id + '?statement=' + this.props.statement + '&instagram_handle=' + this.props.instagram_handle + '&name=' + this.props.name + '&color=' + this.props.color;
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