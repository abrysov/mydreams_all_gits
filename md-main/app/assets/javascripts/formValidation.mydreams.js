//Плагинчик для валидации форм
//Умеет слушать простые текстовые поля, email, чекбоксы
//TODO: refactor: вычистить все лишнее, добавить тип поля 'confirm', валидацию на длину пароля

(function($){

	var methods = {

		_email_reg: /^([a-z0-9_\.-])+@[a-z0-9-]+\.([a-z]{2,4}\.)?[a-z]{2,10}$/i,

		init: function(init_options)
		{
		  return this.each(function(){
			var
			$this = $(this),
			field_type = $this.data('valid');

			methods._inspect($this);

			switch(field_type){
				case 'name':
					methods._validText($this);
					break;
				case 'password':
					methods._validPassword($this);
					break;
				case 'email':
					methods._validEmail($this);
					break;
				// case 'gender':
				// 	methods._validGender($this);
				// 	break;
				case 'terms':
					methods._validTerms($this);
					break;
				case 'confirm_password':
					methods._validConfirmPassword($this);
					break;
				case 'old_password':
					methods._validText($this);
					break;
			}
		  });
		},

		_validTerms: function($this)
		{
			$this.off('change').on('change', function(){
				if($(this).val() === true){
					$(this).removeClass('error');
					$(this).removeClass('not-approved');
					methods._inspect($this);
				} else {
					$(this).addClass('error');
					$(this).addClass('not-approved');
					methods._inspect($this);
				}
			});
		},

		_validText: function($this)
		{
			var inspect,
			input_field = $this.closest('.js-input-field'),
			// foo = function(){
			// 	if(! $.trim($this.val()).length){
			// 	  $this.addClass('error');
			// 	  methods._inspect($this);
			// 	}else {
			// 		$this.removeClass('error');
			// 		methods._inspect($this);
			// 	}
			// },
			approvement = function() {

				if ( !$.trim( $this.val() ).length ) {

					$this.addClass( 'not-approved' );
					input_field.addClass( 'error' ).removeClass( 'success' );
					methods._inspect( $this );

				} else {

					$this.removeClass( 'not-approved' );
					input_field.addClass( 'success' ).removeClass( 'error' );
					methods._inspect( $this );

				}

			};

			// $this.off('focusin').on('focusin', function() {
			// 	input_field.removeClass( 'error' )
			// });

			$this.off('focusout').on('focusout', function() {
				// if ( $.trim( $this.val() ) !== '' ) foo();
				if ( $.trim( $this.val() ) !== '' ) approvement();
			});

			$this.off('input').on('input', function(){
				approvement();
				methods._inspect($this);
			});

			// $this.off('focusin').on('focusin', function(){
			// 	inspect = methods._intervalTrigger($this, foo, 300);
			// });

			// $this.off('focusout').on('focusout', function(){
			// 	window.clearInterval(inspect);
			// 	methods._inspect($this);
			// });

		},

		_validPassword: function($this)
		{
			var
			inspect,
			input_field = $this.closest('.js-input-field'),
			// foo = function(){
			// 	if(! $.trim($this.val()).length){
			// 		$this.addClass('error');
			// 		methods._inspect($this);
			// 	}else {
			// 		$this.removeClass('error');
			// 		methods._inspect($this);
			// 	}
			// },
			approvement = function() {

				if ( $.trim( $this.val() ).length < 5 ) {

					$this.addClass( 'not-approved' );
					input_field.addClass( 'error' ).removeClass( 'success' );
					methods._inspect( $this );

				} else {

					$this.removeClass( 'not-approved' );
					input_field.addClass( 'success' ).removeClass( 'error' );
					methods._inspect( $this );

				}

			};

			// $this.off('focusin').on('focusin', function() {
			// 	input_field.removeClass( 'error' );
			// });

			$this.off('focusout').on('focusout', function() {
				// if ( $.trim( $this.val() ) !== '' ) foo();
				if ( $.trim( $this.val() ) !== '' ) approvement();
			});

			$this.off('input').on('input', function(){
				approvement();
				methods._inspect($this);
			});

		},

		_validEmail: function($this)
		{
			var
			inspect,
			input_field = $this.closest('.js-input-field'),
			// foo = function(){
			// 	if( ! methods._email_reg.test($this.val()) ){
			// 	  $this.addClass('error');
			// 		methods._inspect($this);
			// 	}else {
			// 		$this.removeClass('error');
			// 		methods._inspect($this);
			// 	}
			// },
			approvement = function() {

				if ( ! methods._email_reg.test( $this.val() ) ) {

					$this.addClass( 'not-approved' );
					input_field.addClass( 'error' ).removeClass( 'success' );
					methods._inspect( $this );

				} else {

					$this.removeClass( 'not-approved' );
					input_field.addClass( 'success' ).removeClass( 'error' );
					methods._inspect( $this );

				}

			};

			// $this.off('focusin').on('focusin', function() {
			// 	input_field.removeClass( 'error' );
			// });

			$this.off('focusout').on('focusout', function() {
				// if ( $.trim( $this.val() ) !== '' ) foo();
				if ( $.trim( $this.val() ) !== '' ) approvement();
			});

			$this.off('input').on('input', function(){
				approvement();
				methods._inspect($this);
			});

		},

		//TODO: refactor: убрали дефолтное значение "Пол", теперь нет необходимости валидировать такой тип поля
		// _validGender: function($this)
		// {
		// 	  $this.off('change').on('change', function(){
		// 			var ikselect_field = $('.reg_gender_select .ik_select_link');

		// 			if($(this).val() === null){
		// 			  ikselect_field.addClass('error');
		// 			  $this.addClass('error');
		// 			  $this.addClass('not-approved');
		// 			}else {
		// 				ikselect_field.removeClass('error');
		// 				$this.removeClass('error');
		// 				$this.removeClass('not-approved');
		// 			}

		// 			methods._inspect($this);
		// 	  });
		// },



		_checkTerms: function(terms)
		{
			if (terms.prop('checked') === true) {

				return true;
			} else {
				return false;
			}

		},

		_inspect: function($this)
		{
			var
			target_form = $this.closest('form'),
			fields = target_form.find('.js-validation').not('[data-valid=phone], [data-valid=terms]'),
			terms = target_form.find('.js-validation[data-valid=terms]'),
			result = [];

			fields.each(function(i){
				if ($(this).val() === null || !$(this).val().length || $(this).hasClass('not-approved')) {
					result.push($(this));
			  target_form.find('input[type=submit]').prop('disabled', true);
			  target_form.find('.js-form-submit').addClass('disabled');
				}else {
					if (i+1 == fields.length && result.length == 0) {
						if (terms.length) {
							if (methods._checkTerms(terms)) {
								target_form.find('input[type=submit]').prop('disabled', false);
								target_form.find('.js-form-submit').removeClass('disabled');
							}else {
								target_form.find('input[type=submit]').prop('disabled', true);
								target_form.find('.js-form-submit').addClass('disabled');
							}
						}else {
							target_form.find('input[type=submit]').prop('disabled', false);
							target_form.find('.js-form-submit').removeClass('disabled');
						}
					}else {
						target_form.find('input[type=submit]').prop('disabled', true);
						target_form.find('.js-form-submit').addClass('disabled');
					}
				}
			});
		},

	};

	$.fn.formValidation = function(method) {

		if ( methods[method] ) {
			return methods[method].apply( this, Array.prototype.slice.call( arguments ));
		} else if ( typeof method === 'object' || ! method ) {
			return methods.init.apply( this, arguments );
		} else {
			$.error( 'Method ' +  method + ' not fined jQuery.formValidation' );
		}

	};

})(jQuery);
