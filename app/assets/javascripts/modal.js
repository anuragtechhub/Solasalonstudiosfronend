$.widget('solasalonstudios.modal', {
  _create: function() {
    var self = this;

    self.$body = $(document.body);
    self.$window = $(window);
    self.$overlay = $('<div class="modal-overlay"></div>');
    self.$modal = $('<div class="modal"></div>');
    self.$content = $('<div class="content"></div>');
    self.$close = $('<div class="close"><span class="ss-delete"></span></div>');
    self.$spinner = $('<div class="spinner-wrapper"><div class="spinner"></div></div>');
    self.animated = self.element.data('animated');

    // add classes
    if (self.element.data('modal-class')) {
      self.$modal.addClass(self.element.data('modal-class'));
      self.$overlay.addClass(self.element.data('modal-class'));
    }

    // overlay opacity
    if (self.element.data('overlay-background')) {
      self.$overlay.css('background', self.element.data('overlay-background'));
    }

    // hide close button
    if (self.element.data('close')) {
      self.$close.hide();
    }

    // custom modal width
    if (self.element.data('width')) {
      self.width = self.element.data('width');
      self.$modal.css('max-width', self.width);
      self.$modal.css('width', self.width);
    }

    // bind events
    self.$close.on('click', self.close.bind(this));
    self.$overlay.on('click', self.close.bind(this));
    $(window).on('resize.modalzzz', function () { self.reposition(); });

    // append elements
    self.$content.append(self.element).append(self.$spinner);
    self.$modal.append(self.$close).append(self.$content);

    // attach to DOM
    self.$body.append(self.$modal).append(self.$overlay);
  
    // cache outerWidth and outerHeight
    self.$modal.show();
    self.outerWidth = self.$modal.outerWidth();
    self.outerHeight = self.$content[0].scrollHeight;
    self.$modal.hide();
  },

  width: 392,

  open: function () {
    var self = this;

    // self.outerWidth = self.$modal.outerWidth();
    // self.outerHeight = self.$modal.outerHeight();

    $(document).on('touchmove.modalzzz', function (e) { e.preventDefault(); });
    self.$body.css('overflow', 'hidden');
    self.reposition();

    if (self.animated) {
      self.$overlay.fadeIn('fast');
      self.$modal.fadeIn('fast');
    } else {
      self.$modal.show();
      self.$overlay.show();
    }

    // self.outerWidth = self.$modal.outerWidth();
    // self.outerHeight = self.$modal.outerHeight();    
  },

  close: function () {
    var self = this;

    $(document).off('touchmove.modalzzz');
    self.$body.css('overflow', 'auto');

    if (self.animated) {
      self.$overlay.fadeOut('fast');  
      self.$modal.fadeOut('fast');
    } else {
      self.$modal.hide();
      self.$overlay.hide();  
    }
  },

  showSpinner: function () {
    this.$spinner.fadeIn('fast');
  },

  hideSpinner: function () {
    this.$spinner.fadeOut('fast');
  },

  fadeIn: function () {
    var self = this;

    self.open();
    self.$modal.hide();
    self.$overlay.hide();
    self.$modal.fadeIn('fast');
    self.$overlay.fadeOut('fast');
  },

  fadeOut: function () {
    var self = this;

    self.$body.css('overflow', 'auto');
    self.$modal.fadeOut('slow');
    self.$overlay.fadeOut('slow');
  },

  resize: function () {
    var self = this;

    //console.log('outerHeight b4', self.outerHeight);
    // if (self.$content[0].scrollHeight) {
    //   self.outerHeight = self.$content[0].scrollHeight;
    // }
    //console.log('outerHeight after', self.outerHeight);
  },

  reposition: function () {
    var self = this;
    var $window = $(window);
    var windowHeight = $window.height();
    var windowWidth = $window.width();

    //self.resize();
    console.log('reposition', self.outerHeight);

    if (windowHeight <= self.outerHeight || windowWidth <= self.outerWidth) {
      console.log('1')
      if (windowHeight <= self.outerHeight) {
        console.log('a')
        self.$modal.css({top: '30px', bottom: '30px', 'margin-top': 0});
      } else {
        console.log('b');
        self.$modal.css({top: '50%', bottom: 'auto', 'margin-top': '-' + self.outerHeight / 2 + 'px'});
      }
      if (windowWidth <= self.outerWidth) {
        self.$modal.css({left: '30px', right: '30px', 'margin-left': 0, 'width': 'auto'});
      } else {
        self.$modal.css({left: '50%', right: 'auto', 'margin-left': '-' + self.outerWidth / 2 + 'px', 'width': self.width + 'px'});
      }
    } else {
      //console.log('2')
      self.$modal.css({top: '50%', left: '50%', right: 'auto', bottom: 'auto', 'margin-top': '-' + self.outerHeight / 2 + 'px', 'margin-left': '-' + self.outerWidth / 2 + 'px', 'width': self.width + 'px'});
    }

    // var modalWidth = self.$modal.outerWidth();
    // var modalHeight = self.$modal.outerHeight();
    // var windowWidth = self.$window.outerWidth();
    // var windowHeight = self.$window.outerHeight();
    
    // self.$modal.css({top: '50%', left: '50%', bottom: 'auto', right: 'auto', marginTop: '-' + (modalHeight / 2) + 'px', marginLeft:  '-' + (modalWidth / 2) + 'px'});

    // if (modalHeight > windowHeight) {
    //   self.$modal.css({marginTop: 0, top: 0, bottom: 0});
    // }

    // if (modalWidth > windowWidth) {
    //   self.$modal.css({marginLeft: 0, left: 0, right: 0});
    // }
  },

});