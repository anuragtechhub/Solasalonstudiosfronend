$.widget('solasalonstudios.modal', {
  _create: function() {
    var self = this;

    self.$body = $(document.body);
    self.$window = $(window);
    self.$overlay = $('<div class="modal-overlay"></div>');
    self.$modal = $('<div class="modal"></div>');
    self.$content = $('<div class="content"></div>');
    self.$close = $('<div class="close"><span class="ss-delete"></span></div>');

    // add classes
    if (self.element.data('modal-class')) {
      self.$modal.addClass(self.element.data('modal-class'));
    }

    // bind events
    self.$close.on('click', self.close.bind(this));

    // append elemetns
    self.$content.append(self.$close).append(self.element);
    self.$modal.append(self.$content);

    // attach to DOM
    self.$body.append(self.$modal).append(self.$overlay);
  },

  open: function () {
    var self = this;

    self.$body.css('overflow', 'hidden');
    self.reposition();

    self.$modal.show();
    self.$overlay.show();
  },

  close: function () {
    var self = this;

    self.$body.css('overflow', 'auto');
    self.$modal.hide();
    self.$overlay.hide();  
  },

  fadeOut: function () {
    var self = this;

    self.$body.css('overflow', 'auto');
    self.$modal.fadeOut('slow');
    self.$overlay.fadeOut('slow')
  },

  reposition: function () {
    var self = this;

    var modalWidth = self.$modal.outerWidth();
    var modalHeight = self.$modal.outerHeight();
    //var windowWidth = self.$window.outerWidth();
    //var windowHeight = self.$window.outerHeight();

    self.$modal.css({marginTop: '-' + (modalHeight / 2) + 'px', marginLeft:  '-' + (modalWidth / 2) + 'px'})
  },

});