var MySola = React.createClass({

  getInitialState: function () {
    return {
      fileUploadOverlay: false,
      focusedInputName: null,
      instagram_handle: '',
      i_feel: '',
      image: null,
      mysola_is: '',
      name: '',
      scrollTop: 0,
      sharePopupVisible: false,
      statement: '',
      statement_variant: 'mysola_is',
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
    if (this.state.i_feel) {
      return "I feel " + this.state.i_feel + ' in #MySola';
    } else if (this.state.mysola_is) {
      return "#MySola is my " + this.state.mysola_is;
    } else {
      return '#MySola'
    }
  },

  render: function () {
    return (
      <div className="my-sola">
        <div className="container">
          {this.renderHeaderCopy()}
          {this.renderNameAndHandleForm()}
          <MySolaImageDropzone ref="image_dropzone" statement={this.state.statement} statement_variant={this.state.statement_variant} instagram_handle={this.state.instagram_handle} name={this.state.name} onChangeImage={this.onChangeImage} />
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
          <a href={'/mysola-image-preview/' + this.state.image.public_id} className="button block">Download</a>
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

  renderHeaderCopy: function () {
    return (
      <div className="header-copy">
        <h3>Overview:</h3>
        <h2>What does your Sola mean to you?</h2>
        <p>Upload a photo and fill in one of the two statements below to create a custom image. Share your pic and tell the world why you decided to go Sola.</p>
      </div>
    );
  },

  renderNameAndHandleForm: function () {
    return (
      <div className="name-and-handle-form">
        <input type="text" name="name" placeholder={this.state.focusedInputName == 'name' ? null : "Please enter your name"} value={this.state.name} onFocus={this.onFocusInput} onBlur={this.onBlurInput} onChange={this.onChangeTextInput} />
        <input type="text" name="instagram_handle" placeholder={this.state.focusedInputName == 'instagram_handle' ? null : "Please enter your Instagram handle"} onFocus={this.onFocusInput} onBlur={this.onBlurInput} value={this.state.instagram_handle} onChange={this.onChangeTextInput} />
        <div className="next">
          <h3>Next</h3>
          <div className="next-icon"></div>
        </div>
      </div>
    );
  },

  renderStatementForm: function () {
    return (
      <div className="statement-form">
        <h3>Choose a statement below:</h3>
        <div className="madlibs">#MySola is my <input type="text" name="mysola_is" placeholder={this.state.focusedInputName == 'mysola_is' ? null : 'Type your "expression" here'} maxLength="21" value={this.state.mysola_is} onFocus={this.onFocusInput} onBlur={this.onBlurInput} onChange={this.onChangeTextInput} onKeyDown={this.onKeyDownMadLibsInput} onKeyUp={this.startTypingTimer} /></div>
        <h3>Or:</h3>
        <div className="madlibs">I feel <input type="text" name="i_feel" placeholder={this.state.focusedInputName == 'i_feel' ? null : 'Type your "expression" here'} maxLength="21" value={this.state.i_feel} onFocus={this.onFocusInput} onBlur={this.onBlurInput} onChange={this.onChangeTextInput} onKeyDown={this.onKeyDownMadLibsInput} onKeyUp={this.startTypingTimer} /> in #MySola</div>
      </div>
    );
  },

  onBlurInput: function (event) {
    this.setState({focusedInputName: null});
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
    if (event.target.name == 'mysola_is') {
      this.setState({i_feel: '', statement_variant: 'mysola_is', statement: event.target.value});
    } else if (event.target.name == 'i_feel') {
      this.setState({mysola_is: '', statement_variant: 'i_feel', statement: event.target.value});
    }

    this.setState({focusedInputName: event.target.name});
  },

  onHideSocialSharePopup: function () {
    this.setState({sharePopupVisible: false});
    $(window).off('click.share');
  },

  onKeyDownMadLibsInput: function (event) {
    // if (event.target.name == 'mysola_is') {
    //   this.setState({i_feel: ''});
    // } else if (event.target.name == 'i_feel') {
    //   this.setState({mysola_is: ''});
    // }
  },

  doneTyping: function () {
    if (this.state.mysola_is) {
      this.setState({statement: this.state.mysola_is});
    } else if (this.state.i_feel) {
      this.setState({statement: this.state.i_feel});
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