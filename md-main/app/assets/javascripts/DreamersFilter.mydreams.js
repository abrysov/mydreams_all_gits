//С помощью этого модуля осуществляется поиск и фильтрация по разделу "Мечтатели"

var DreamersFilter = (function($){
	return {
		init: function(){
			var
			form = $('.js-fast-search'),
			select_country = form.find('.js-select2-country'),
			select_city = form.find('.js-select2-city'),
			city_url = select_city.data('url'),
			formatRepo = function(results){
      	if (results.name) {
        	return '<span>' + results.name + '</span>';
      	};
      },
      formatRepoSelection = function(results){
        if (results.name) {
          return '<span>' + results.name + '</span>';
        }else {
          return '<span>' + results.text + '</span>';              
        }
      };

			select_country.select2({
				allowClear: true,
				minimumInputLength: 2,
				multiple: false,
				width: '182px'
			}).on('change', function(){
				if ($(this).val() != null) {
					select_city.prop('disabled', false);					
				}else {
					select_city.prop('disabled', true);
				}
			});

			select_city.select2({
				allowClear: true,
				minimumInputLength: 2,
				multiple: false,
				width: '182px',
        ajax:{
          url: city_url,
          dataType: 'json',
          delay: 400,
          data: function(term,page){
            return {term: term, country_id: select_country.val()}
          },
          processResults: function(data,page){
            var results = data;

            return {results: results};      
          },
          cache: true
        },
        escapeMarkup: function (m) { return m; },  
        templateResult: formatRepo,
        templateSelection: formatRepoSelection,  
			});

			if (select_country.val() === null) {
				select_city.select2('disabled', true);
			};

			select_country.data('select2').$container.addClass('fast-search');
			select_city.data('select2').$container.addClass('fast-search');
			select_country.data('select2').$dropdown.addClass('fast-search');
			select_city.data('select2').$dropdown.addClass('fast-search');

			// $(document).off('change', '.js-filter-checkbox').on('change', '.js-filter-checkbox', function(e){
			// 	var form_btn = form.find('input[type=submit]');

   //      form_btn.trigger('click');
			// });
		}
	}
})(jQuery);


