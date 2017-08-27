// This plugin - wraps jquery.tooltipster, it can be used to create custom settings of dom-elements data-attributes

(function( $ ){

	$.fn.createTooltip = function(init_options)
	{
		return this.each(function() 
		{
			var
  		custom_options = {
  			trigger: $(this).data('t-trigger'),
    		position: $(this).data('t-position'),
        width: $(this).data('t-width'),
        minWidth: $(this).data('t-min-width'),
    		maxWidth: $(this).data('t-max-width'),
        interactive: $(this).data('t-interactive'),
    		content: $(this).find('.js-tooltipster-content').html()
  		},
      options = $.extend({
        contentAsHTML: true,
        speed: 200,
        offsetY: -2,
        onlyOne: true
      }, custom_options, init_options);

      $(this).tooltipster(options);
		}); 
	}

})(jQuery);
