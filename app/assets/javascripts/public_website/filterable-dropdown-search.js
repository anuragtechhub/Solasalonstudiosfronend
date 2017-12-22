$.widget('solasalonstudios.filterabledropdownsearch', {
  
  _create: function() {
    var self = this;

    console.log('create filterable dropdown search yo!');

    self.$selected_option = self.element.find('.selected-option');
    self.$options = self.element.find('.options');

    /**
    * Bind event handlers
    */
    self.$selected_option.on('click', function (e) { self.onClickSelectedOption(e); });
  },

  onClickSelectedOption: function (e) {
    console.log('click');
    var self = this;

    e.preventDefault();
    e.stopPropagation();

    if (self.$options.hasClass('open')) {
      self.$options.removeClass('open');
      $(window).off('click.filterabledropdownsearch');
    } else {
      self.$options.addClass('open');
      $(window).on('click.filterabledropdownsearch', function (e) { self.$options.removeClass('open'); });
    }
  },

});