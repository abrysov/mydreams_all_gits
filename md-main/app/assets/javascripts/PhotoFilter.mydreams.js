var PhotoFilter = (function($){
	 
		return {
			init: function()
			{
				console.log('photofilter');
			
				$(document).off('click', '.js-photo-filter').on('click', '.js-photo-filter', function(){
					// var 
					// // effect = $(this).data('effect'),
					// effect = {
					// 	vignette: {
     //            black: 0.8,
     //            white: 0.2
     //        },
     //        noise: 20,
     //        screen: {
     //            red: 12,
     //            green: 75,
     //            blue: 153,
     //            strength: 0.3
     //        },
     //        desaturate: 0.05
					// },
					// options = {
     //    		onError: function() {
     //        	alert('ERROR');
     //    		}
    	// 		};
    	// 		console.log('click ' + effect);

					// $('.js-imageLoader-preview img').vintage(options, effect);
				});
			}
		}
	
})(jQuery);