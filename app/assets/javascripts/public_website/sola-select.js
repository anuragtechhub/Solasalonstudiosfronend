$.widget('solasalonstudios.solaselect', {
  
  _create: function() {
    console.log('create solaselect')
    var self = this;

    self.$select = this.element;
    self.$options = self.$select.find('.options');

    self.$options.addClass('sola-select-options');
    $('body').append(self.$options);

    /**
    * Bind Events
    */
    self.$select.on('click', function (e) { console.log('click'); self.onDropdownClick(e); });
    self.$select.find('.option').on('click', function (e) { self.onOptionClick(e); });
  },

  hide: function () {
    var self = this;

    self.$options.hide();
    $('body').off('touchmove.solaselect').removeClass('stop-scrolling');
    $(window).off('click.solaselect');
  },

  show: function () {
    var self = this;

    self.positionOptions();
    self.$options.show(); 
    $('body').on('touchmove.solaselect', function (e) {
      e.preventDefault();
    }).addClass('stop-scrolling');
    $(window).on('click.solaselect', function () {
      self.hide();
    }); 
  },

  positionOptions: function () {
    var self = this;
    var offset = self.$select.offset();

    self.$options.css({top: offset.top + self.$select.outerHeight() + 5, left: offset.left});
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