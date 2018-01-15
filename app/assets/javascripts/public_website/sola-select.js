$.widget('solasalonstudios.solaselect', {
  
  _create: function() {
    var self = this;

    self.$select = this.element;
    self.$options = self.$select.find('.options');

    self.$options.addClass('sola-select-options');
    $('body').append(self.$options);

    /**
    * Bind Events
    */
    self.$select.on('click', function (e) { self.onDropdownClick(e); });
    self.$options.find('.option').on('click', function (e) { self.onOptionClick(e); });
  },

  hide: function () {
    var self = this;

    self.$options.hide();
    $('body').removeClass('stop-scrolling');
    $(window).off('click.solaselect');
  },

  show: function () {
    var self = this;

    self.positionOptions();
    self.$options.show(); 
    $('body').addClass('stop-scrolling');
    $(window).on('click.solaselect', function () {
      self.hide();
    }); 
  },

  positionOptions: function () {
    var self = this;
    var offset = self.$select.offset();

    //console.log('width', self.$select.width());

    self.$options.css({top: offset.top + self.$select.outerHeight() + 5, left: offset.left}).width(self.$select.width() - 24);
  },

  /**
  * Event Handlers
  */

  onDropdownClick: function (e) {
    var self = this;

    e.preventDefault();
    e.stopPropagation();

    if (self.$options.is(':visible')) {
      self.hide();
    } else {
      self.show();
    }
  },

  onOptionClick: function (e) {
    var self = this;

    e.preventDefault();
    e.stopPropagation();

    window.location.href = $(e.target).data('value');
  },

});