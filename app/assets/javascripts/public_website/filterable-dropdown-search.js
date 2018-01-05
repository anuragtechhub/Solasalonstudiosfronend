$.widget('solasalonstudios.filterabledropdownsearch', {
  
  _create: function() {
    var self = this;

    self.$selected_option = self.element.find('.selected-option');
    self.$options = self.element.find('.options');

    /**
    * Bind event handlers
    */
    self.$selected_option.on('click', function (e) { self.onClickSelectedOption(e); });
    self.$options.find('.option').on('click', function (e) { self.onClickOption(e); });
  },

  close: function () {
    var self = this;

    self.$options.removeClass('open');
    $(window).off('click.filterabledropdownsearch');
  },

  open: function () {
    var self = this;

    self.$options.addClass('open');
    $(window).on('click.filterabledropdownsearch', function (e) { self.$options.removeClass('open'); });
  },

  onClickOption: function (e) {
    var self = this;
    var $this = $(e.target);

    e.preventDefault();
    e.stopPropagation();

    self.$selected_option.find('.name').html($this.html());
    self.element.find('input[name=' + self.element.data('input') + ']').val($this.data('value'));
    self.close();
  },

  onClickSelectedOption: function (e) {
    var self = this;

    e.preventDefault();
    e.stopPropagation();

    if (self.$options.hasClass('open')) {
      self.close();
    } else {
      self.open();
    }
  },

});