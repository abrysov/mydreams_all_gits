// This plugin - wraps jquery.ikselect, it can be used to create custom settings of dom-elements data-attributes

(function( $ ){

	$.fn.createIkselect = function(init_options)
	{
		return this.each(function() 
		{
			var
  		custom_options = {
        ddCustomClass : $(this).data('custom-dd'),
        customClass   : $(this).data('custom')
  		},
      options = $.extend({
        autoWidth: false,
        ddFullWidth: false,
        onShow: function (inst) {
          var
          dropselect = $('.ik_select_dropdown'),
          active_select = $(inst.el).closest('.ik_select');

          $(window).off('resize').on('resize', function () {
            dropselect.css('left', active_select.offset().left);
          });
        },
        onHide: function (inst) {
          $('.ik_select_dropdown').css('left', 0);
        }
      }, custom_options, init_options);

      $(this).ikSelect(options);
		}); 
	}

})(jQuery);