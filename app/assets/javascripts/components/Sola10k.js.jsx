var Sola10k = React.createClass({

  getInitialState: function () {
    return {
      fileUploadOverlay: false,
      focusedInputName: null,
      instagram_handle: '',
      image: null,
      my_inspired_story: '',
      name: '',
      color: 'blue',
      scrollTop: 0,
      sharePopupVisible: false,
      statement: '',
      typingTimer: null,
    };
  },

  componentDidMount: function () {
    var self = this;

    // window scroll handler
    $(window).on('scroll', function () {
      self.setState({scrollTop: $(window).scrollTop()});
    }).trigger('scroll');

    // hide social sharing popup
    window.onClickSocialShareButton = function () {
      self.onHideSocialSharePopup();
    },

    // social sharing
    $(this.refs.social_share_wrapper).jsSocials({
      shares: ["twitter", "facebook"],
      text: self.shareText(),
      showCount: false,
      showLabel: false,
      shareIn: 'popup',
      shareText: this.shareText(),
      shareUrl: this.shareUrl(),
    });

    window.getShareText = function () {
      return self.shareText();
    };

    window.getShareUrl = function () {
      return self.shareUrl();
    };
  },

  componentDidUpdate: function () {
    $(this.refs.social_share_wrapper).jsSocials('refresh');
  },

  shareUrl: function () {
    //console.log('shareUrl', this.state.image ? this.state.image.share_url : null)
    return this.state.image ? this.state.image.share_url : null;
  },

  shareText: function () {
    return 'My ' + this.state.statement + ' #Sola10K';
  },

  render: function () {
    return (
      <div className="sola10k">
        <div className="container">
          {this.renderHeaderCopy()}
          {this.renderNameAndHandleForm()}
          <Sola10kImageDropzone ref="image_dropzone" color={this.state.color} statement={this.state.statement} instagram_handle={this.state.instagram_handle} name={this.state.name} onChangeImage={this.onChangeImage} onChangeColor={this.onChangeColor} />
          {this.renderColorPicker()}
          {this.renderStatementForm()}
          {this.renderBottomButtons()}
        </div>
        {this.state.scrollTop > 0 ? <div className="back-to-top" onClick={this.scrollToTop}></div> : null}
      </div>
    );
  },

  renderBottomButtons: function () {
    if (this.state.image && this.state.image.id) {
      return (
        <div className="bottom-buttons">
          <div className="share-button">
            <a href="#" className="button block" onClick={this.toggleSharePopup}>Share</a>
            <div className="social-share-icons" ref="social_share_wrapper" style={{display: this.state.sharePopupVisible ? 'block' : 'none'}}></div>
          </div>
          <a href={'/sola10k-image-preview/' + this.state.image.public_id} className="button block">Download</a>
          <div className="start-over"><a href="#" onClick={this.startOver}>Start Over</a></div>
        </div>
      );
    } else {
      return (
        <div className="bottom-buttons">
          <div className="share-button">
            <a href="#" className="button disabled block" onClick={this.shhh}>Share</a>
            <div className="social-share-icons" ref="social_share_wrapper" style={{display: this.state.sharePopupVisible ? 'block' : 'none'}}></div>
          </div>
          <a href="#" className="button disabled block" onClick={this.shhh}>Download</a>
          <div className="start-over"><a href="#" className="disabled" onClick={this.shhh}>Start Over</a></div>
        </div>
      );
    }
  },

  renderColorPicker: function () {
    return (
      <div className="sola10k-colorpicker" style={{visibility: this.state.image ? 'visible' : 'hidden'}}>
        <div data-color="blue" className={"blue colorswatch " + (this.state.color == 'blue' ? 'active' : '')} onClick={this.onChangeColor.bind(this, 'blue')}></div>
        <div data-color="pink" className={"pink colorswatch " + (this.state.color == 'pink' ? 'active' : '')} onClick={this.onChangeColor.bind(this, 'pink')}></div>
        <div data-color="black" className={"black colorswatch " + (this.state.color == 'black' ? 'active' : '')} onClick={this.onChangeColor.bind(this, 'black')}></div>
      </div>
    );
  },

  renderHeaderCopy: function () {
    return (
      <div className="header-copy">
        <h1 className="text-center">10,000 Individual Stories.<br />One Powerful Community.</h1>
        <p className="text-center"><strong>The Sola story really is made up of 10,000 individual stories. It's this growing community that continues to inspire us every day.</strong></p>
        <p className="text-center">Whether it's customizing your studio to fit your style, learning a new technique at the Sola Sessions, reaching a new business milestone, or having coffee with your Sola bestie, you are creating a unique journey every day.</p>
        <p className="text-center"><strong>Share a piece of the Sola story!</strong></p>
        <p className="text-center tighter"><strong>Step 1:</strong><br />Create your image below.</p>
        <p className="text-center tighter"><strong>Step 2:</strong><br />Share on social with the hashtag <strong>#Sola10K</strong></p>
        <p className="text-center tighter"><strong>Step 3:</strong><br />Win cool prizes!</p>
      </div>
    );
  },

  renderNameAndHandleForm: function () {
    return (
      <div className="name-and-handle-form">
        <input type="text" name="name" placeholder={this.state.focusedInputName == 'name' ? null : "Please enter your name"} value={this.state.name} onFocus={this.onFocusInput} onBlur={this.onBlurInput} onChange={this.onChangeTextInput} />
        <input ref="instagram_input" type="text" name="instagram_handle" placeholder={this.state.focusedInputName == 'instagram_handle' ? null : "Please enter your Instagram handle"} onFocus={this.onFocusInstagramInput} onKeyDown={this.onKeyDownInstagramInput} onBlur={this.onBlurInput} value={this.state.instagram_handle} onChange={this.onChangeTextInput} />
      </div>
    );
  },

  renderStatementForm: function () {
    return (
      <div className="statement-form">
        <div className="madlibs">My <input type="text" name="my_inspired_story" placeholder={this.state.focusedInputName == 'my_inspired_story' ? null : 'inspired story'} maxLength="21" value={this.state.my_inspired_story} onFocus={this.onFocusInput} onBlur={this.onBlurInput} onChange={this.onChangeTextInput} onKeyDown={this.onKeyDownMadLibsInput} onKeyUp={this.startTypingTimer} /></div>
      </div>
    );
  },

  onBlurInput: function (event) {
    if (event.target.name == 'instagram_handle' && this.state.instagram_handle == '@') {
      this.setState({focusedInputName: null, instagram_handle: ''});
    } else {
      this.setState({focusedInputName: null});
    }
  },

  onChangeColor: function (color) {
    this.setState({color: color});
  },

  onChangeImage: function (image) {
    this.setState({image: image});
  },

  onChangeTextInput: function (event) {
    var state = this.state;
    state[event.target.name] = event.target.value;

    this.setState(state);
  },

  onFocusInput: function (event) {
    if (event.target.name == 'my_inspired_story') {
      this.setState({statement: event.target.value});
    }

    this.setState({focusedInputName: event.target.name});
  },

  onFocusInstagramInput: function (event) {
    var self = this;
    var $input = $(this.refs.instagram_input);

    if (this.state.instagram_handle == '') {
      this.setState({instagram_handle: '@', focusedInputName: event.target.name}, function () {
        //console.log('set selection range to ONE');
        //self.refs.instagram_input.setSelectionRange(1, 1);
        self.refs.instagram_input.selectionStart = self.refs.instagram_input.selectionEnd = 1;
        setTimeout(function () {
          //console.log('moving...')
          self.refs.instagram_input.selectionStart = self.refs.instagram_input.selectionEnd = 1;
        }, 1);
        setTimeout(function () {
          //console.log('moving...')
          self.refs.instagram_input.selectionStart = self.refs.instagram_input.selectionEnd = 1;
        }, 10);
        setTimeout(function () {
          //console.log('moving...')
          self.refs.instagram_input.selectionStart = self.refs.instagram_input.selectionEnd = 1;
        }, 100);
      });
      
    } else {
      this.setState({focusedInputName: event.target.name}, function () {
        // var val_length = $input.val().length;
        // console.log('set selection range to ' + val_length);
        // //this.refs.instagram_input.setSelectionRange(val_length, val_length);
        // setTimeout(function () {
        //   self.refs.instagram_input.selectionStart = self.refs.instagram_input.selectionEnd = val_length;
        // }, 250);
      });
    }
  },

  onHideSocialSharePopup: function () {
    this.setState({sharePopupVisible: false});
    $(window).off('click.share');
  },

  onKeyDownInstagramInput: function (event) {
    if (event.target.value.startsWith('@')) {
      //all good
    } else {
      this.setState({instagram_handle: '@' + event.target.value});
    }
  },

  onKeyDownMadLibsInput: function (event) {
    if (event.target.name == 'my_inspired_story') {
      this.setState({my_inspired_story: event.target.value});
    }
  },

  doneTyping: function () {
    if (this.state.my_inspired_story) {
      this.setState({statement: this.state.my_inspired_story});
    }
  },

  scrollToTop: function (event) {
    if (event && typeof event.preventDefault == 'function') {
      event.preventDefault();
    }

    $("html, body").animate({scrollTop: 0}, "normal");
  },

  shhh: function (event) {
    event.preventDefault();
  },

  startOver: function (event) {
    var self = this;

    if (event && typeof event.preventDefault == 'function') {
      event.preventDefault();
    }

    this.refs.image_dropzone.reset();
    this.setState(this.getInitialState(), function () {
      self.scrollToTop();
    });
  },

  startTypingTimer: function () {
    clearTimeout(this.state.typingTimer);
    this.setState({typingTimer: setTimeout(this.doneTyping, 1000)});
  },

  toggleSharePopup: function (event) {
    var self = this;

    event.preventDefault();    
    event.stopPropagation();

    if (this.state.sharePopupVisible) {
      this.onHideSocialSharePopup();
    } else {
      this.setState({sharePopupVisible: true});
      $(window).on('click.share', function () {
        self.onHideSocialSharePopup();
      });
    }
  },  

});