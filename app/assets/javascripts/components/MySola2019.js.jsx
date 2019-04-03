var MySola2019 = React.createClass({

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
        <p>The beauty of Sola is that it means something different to everyone. For some, it's about freedom and control. For others, it's about living that BOSS life. We are continually inspired by the 12,000 individual experiences that make up the Sola story. We want to celebrate what #MySola means to YOU.</p>
        <h2>Create an image below and Make It Yours.</h2>
        
        <h1>#MySola</h1>
        
        <h2>Step 1:</h2> 
        <p>Create your social media image below</p>

        <h2>Step 2:</h2> 
        <p>Share on Instagram with the hashtag #MySola</p>

        <h2>Step 3:</h2> 
        <p>Win cool prizes!</p>
      </div>
    );
  },

  renderNameAndHandleForm: function () {
    return (
      <div className="name-and-handle-form">
        <input type="text" name="name" placeholder={this.state.focusedInputName == 'name' ? null : "Enter your name"} value={this.state.name} onFocus={this.onFocusInput} onBlur={this.onBlurInput} onChange={this.onChangeTextInput} />
        <input type="text" name="instagram_handle" placeholder={this.state.focusedInputName == 'instagram_handle' ? null : "Enter your Instagram handle"} onFocus={this.onFocusInstagramInput} onKeyDown={this.onKeyDownInstagramInput} onBlur={this.onBlurInput} value={this.state.instagram_handle} onChange={this.onChangeTextInput} />
        {/*<div className="next">
          <h3>Next</h3>
          <div className="next-icon"></div>
        </div>*/}
      </div>
    );
  },

  renderStatementForm: function () {
    return (
      <div className="statement-form">
        <div className="madlibs">
          <div className="circle-b" data-step="A">A</div>
          <div className="static-text">#MySola is my</div>
          <input type="text" name="mysola_is" placeholder={this.state.focusedInputName == 'mysola_is' ? null : 'Write your message here'} maxLength="21" value={this.state.mysola_is} onFocus={this.onFocusInput} onBlur={this.onBlurInput} onChange={this.onChangeTextInput} onKeyDown={this.onKeyDownMadLibsInput} onKeyUp={this.startTypingTimer} />
        </div>
        <h3>OR</h3>
        <div className="madlibs">
          <div className="circle-b" data-step="B">B</div>
          <div className="static-text">I feel</div>
          <input type="text" name="i_feel" placeholder={this.state.focusedInputName == 'i_feel' ? null : 'Write your message here'} maxLength="21" value={this.state.i_feel} onFocus={this.onFocusInput} onBlur={this.onBlurInput} onChange={this.onChangeTextInput} onKeyDown={this.onKeyDownMadLibsInput} onKeyUp={this.startTypingTimer} /> 
          <div className="static-text">in #MySola</div>
        </div>
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

  onFocusInstagramInput: function () {
    if (this.state.instagram_handle == '') {
      this.setState({instagram_handle: '@', focusedInputName: event.target.name});
    } else {
      this.setState({focusedInputName: event.target.name});
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