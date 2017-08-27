var ModalHandler = (function($){

	function _checkSpinner(form)
	{
    form
    	.find('.js-form-submit').toggleClass('disabled')
    	.closest('.js-form-control').find('.js-preloader').toggleClass('active');
	}

	return {
		init: function()
		{

	    // REGISTRATION / AUTHORIZATION / RECOVERY / EDIT PASSWORD

	    $(document)
	      .off('show_registration show_recovery show_authorization show_pass_edit')
	      .on('show_registration show_recovery show_authorization show_pass_edit', function(e, data){
	        var
	        target_form = $('.jmod-container form'),
	        valid_field = target_form.find('.js-validation');

	        target_form.find('.js-validation').formValidation();

	        // форма регистрации и редактирования
	        if (target_form.data('modal-type') == 'registration'){
	          var
	          select_country = target_form.find('.js-select2-country'),
	          select_city = target_form.find('.js-select2-city'),
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

	          //init select2 field
	          select_city.select2({
	            placeholder: select_city.data('placeholder'),
	            allowClear: true,
	            minimumInputLength: 2,
	            multiple: false,
	            width: '100%',
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
	            templateSelection: formatRepoSelection
	          });

	          select_country.select2({
	            placeholder: select_country.data('placeholder'),
	            allowClear: true,
	            minimumInputLength: 2,
	            multiple: false,
	            width: '100%'
	          }).on('change', function(){
	            if ($(this).val() != null) {
	              select_city.prop('disabled', false);
	            }else {
	              select_city.prop('disabled', true);
	            }
	          });

	          if (select_country.val() === null) {
	            select_city.select2('disabled', true);
	          };

	          select_country.data('select2').$container.addClass('reg-search');
	          select_city.data('select2').$container.addClass('reg-search');
	          select_country.data('select2').$dropdown.addClass('reg-search');
	          select_city.data('select2').$dropdown.addClass('reg-search');

	          //init ikselect field

	          $('.ikselect:visible').createIkselect();

	          //init datapicker
	          target_form.find('.js-bday').pickmeup({
	            format: 'd-m-Y',
	            position: "bottom"
	          });

	          //init phone mask
	          if(!is_mobile()){
	            target_form.find('#user_phone').each(function(){
	              $(this).mask("+7 (999) 999-99-99 ");
	            });

	            target_form.find('#user_phone')
	              .removeAttr('required')
	              .removeAttr('pattern')
	              .removeAttr('title')
	              .attr({'placeholder':'+7 (___) ___ __ __'});
	          }
	        };

	        target_form
		        .off('ajax:send').on('ajax:send', function(e, data){
		          _checkSpinner(target_form);
		          target_form.find('.errors').html('');
		        })
		        .off('ajax:complete').on('ajax:complete', function(e, data){
		          _checkSpinner(target_form);
		        })
		        .off('ajax:success').on('ajax:success', function(e, data){
		          if(!data.errors){
		            document.location.href = '/account/dreamers/'+ data.id + '/dreams';
		          }else{
		            // target_form.find('.js-form-spinner').fadeOut();
			          target_form.find('.errors').html(data.errors[0].message);
		            if (typeof data.errors == 'object' && data.errors instanceof Array) {
		              valid_field.addClass('error');
		            }else {
		              for(k in data.errors){
		                target_form.find('#dreamer_' + k).addClass('error');
		              }
		            }
		          }
		        })
		        .off('ajax:error').on('ajax:error', function(e, data){
		          target_form.find('.errors').html('Unauthorized, please, contact support');
		        });
	    });


			// SUGGEST DREAM / POST

      $(document).off('show_suggest_dream show_suggest_post').on('show_suggest_dream show_suggest_post', function(e, data){
        var
        jmod_btn = $(e.btn),
        modal_type = jmod_btn.data('modal-type'),
        target_modal = $('.js-modal'),
        form = target_modal.find('form');
	      suggest_select = form.find('.js-select2'),
	      url = suggest_select.data('url'),
	      control = $('.js-form-control'),
	      check_null = function(elem)
	      {
	        if (elem === null || undefined){
	          elem = '';
	        }else {
	          elem = elem;
	        }

	        return elem;
	      },
	      formatRepo = function(results)
	      {
	        if (results.first_name) {
	          return '<img class="flag" src="'+ results.avatar + '"/>' + '<span>' + results.first_name + ' ' + results.last_name + '</span>';
	        }else {
	          return '<span>' + results.text + '</span>';
	        }
	      },
	      formatRepoSelection = function(results)
	      {
	        if (results.first_name) {
	          return '<span>' + results.first_name + ' ' + results.last_name + '</span>';
	        }else {
	          return '<span>' + results.text + '</span>';
	        }
	      };

	      suggest_select.select2({
	        width: '234px',
	        minimumInputLength: 2,
	        multiple: true,
	        tags: true,
	        minimumResultsForSearch: 1,
	        ajax:{
	          url: url,
	          dataType: 'json',
	          delay: 250,
	          data: function(term,page){
	            return {term: term}
	          },
	          processResults: function(data,page){
	            var results = data

	            return {results: results};
	          },
	          cache: true
	        },
	        escapeMarkup: function (m) { return m; },
	        templateResult: formatRepo,
	        templateSelection: formatRepoSelection
	      });

	      suggest_select.data('select2').$container.addClass('suggest');
	      suggest_select.data('select2').$dropdown.addClass('suggest');

	      suggest_select
	        .on('select2:select', function(e){
	          var selected = suggest_select.select2('data');

	          for(var i = 0; i < selected.length; i++){
	            if (selected[i].avatar) {
	              control.find('.js-form-submit').removeClass('disabled').prop('disabled', false);
	            };
	          };
	        })
	        .on('select2:unselect', function(e){
	          var selected = suggest_select.select2('data');

	          for(var i = 0; i < selected.length; i++){
	            if (! selected[i].avatar) {
	              control.find('.js-form-submit').addClass('disabled').prop('disabled', true);
	            };
	          };
	        });

	        form
		        .off('ajax:send').on('ajax:send', function(e, data){
		          _checkSpinner(form);
		        })
		        .off('ajax:complete').on('ajax:complete', function(e, data){
		          _checkSpinner(form);
		        })
	          .off('ajax:success').on('ajax:success', function(e, data){
	            jmod_btn.jMod('hide');
	          })
	          .off('ajax:error').on('ajax:error', function(e, data){
	            // TODO: написать обработку ошибок
	          });
	      });


		    // LIKED DREAMERS / COMMENTATORS / CERTIFICATES

		    $(document).on('show_commentators_list show_liked_list show_certificates', function(e){
		      var
		      id = $('.js-single-page').data('page-id'),
		      tooltipster = $('.tooltipster-base'),
		      modal_type = e.btn.data('modal-type'),
		      target_modal = $('.js-modal[data-modal-type='+modal_type+']'),
		      url = target_modal.data('url'),
		      page_num = target_modal.data('page') + 1,
		      container = target_modal.find('.js-list-body');

		      //грязный хак))
		      if (tooltipster.length) {
		        tooltipster.css('z-index', '0');
		      };

		      container.scrollLoader({
		        arrows: true,
		        url: url,
		        page_num: page_num,
		        ajaxSuccess: function(origin, data)
		        {
		          if (data.last_page) {
		            origin.scrollLoader('destroy');
		          }else {
		            origin.append(data);
		            origin.data('scrollLoader').options.page_num += 1;
		            origin.data('scrollLoader').options.loading = false;
		          }
		        }
		      });
		    });

		    $(document).on('destroy_commentators_list', function(e, data){
		      that.container.html('');
		    });


		    // DREAM COME TRUE

		    $(document).off('show_fulfill_dream').on('show_fulfill_dream', function(e, data){
		      var
		      jmod_btn = $(e.btn),
		      modal_type = e.btn.data('modal-type'),
		      target_form = $('.jmod-container form');

		      $(document).on('change', '#dream_came_true', function(){
		        target_form.find('input[type=submit]').trigger('click');
		      });

		      target_form
		        .off('ajax:send').on('ajax:send', function(e, data){
		          _checkSpinner(target_form);
		        })
		        .off('ajax:complete').on('ajax:complete', function(e, data){
		          _checkSpinner(target_form);
		        })
		        .off('ajax:success').on('ajax:success', function(e, data){
		          jmod_btn.jMod('hide');
		        })
		        .off('ajax:error').on('ajax:error', function(e, data){
		          // TODO: handler
		        });
		    });


		    // SET PRIVACY

		    $(document).off('show_set_private').on('show_set_private', function(e){
		      var
		      select = $('.jmod-container .ikselect'),
		      jmod_btn = $(e.btn),
		      target_form = $('.jmod-container form');

		      select.createIkselect();

		      target_form
		        .off('ajax:send').on('ajax:send', function(e, data){
		          _checkSpinner(target_form);
		        })
		        .off('ajax:complete').on('ajax:complete', function(e, data){
		          _checkSpinner(target_form);
		        })
			      .off('ajax:success').on('ajax:success', function(e, data){
			        var diff = $.parseJSON(data);

			        if (! data.errors) {
			          var new_restriction_level = diff.restriction_level;

			          if (new_restriction_level) {

			            if(new_restriction_level[1] == 0){
			              jmod_btn.closest('.card').find('.js-private-icon').removeClass('active');
			            }
			            else {
			              jmod_btn.closest('.card').find('.js-private-icon').addClass('active');
			            }
			          };

			          jmod_btn.jMod('hide');
			        };
			      })
		        .off('ajax:error').on('ajax:error', function(e, data){
		          // TODO: handler
		        });
		    });


		    // TAKE DREAM

		    $(document).off('show_take_dream').on('show_take_dream', function(e, data){
		      var
		      select = $('.jmod-container .ikselect'),
		      target_form = $('.jmod-container form');

		      select.createIkselect();

		      $('.js-validation').formValidation();

		      $('.jmod-container .js-imageLoader').imageLoader();

					//NOTE: not ajax
    			target_form.find('.js-form-submit').on('click', function(){
      			$(this).addClass('disabled').closest('.js-form-control').find('.js-preloader').addClass('active');
    			});

		      // target_form
		      //   .off('ajax:send').on('ajax:send', function(e, data){
		      //     // _checkSpinner(target_form);
		      //   })
		      //   .off('ajax:complete').on('ajax:complete', function(e, data){
		      //     // _checkSpinner(target_form);
		      //   })
		      //   .off('ajax:success').on('ajax:success', function(e, data){
		      //     // TODO: handler
		      //   })
		      //   .off('ajax:error').on('ajax:error', function(e, data){
		      //     // TODO:обработка ошибок
		      //   });
		    });


		    // TAKE POST

		    $(document).off('show_take_post').on('show_take_post', function(e, data){
		    	var target_form = $('.jmod-container form');

		      $('.js-validation').formValidation();

		      $('.jmod-container .js-imageLoader').imageLoader();

					//NOTE: not ajax
    			target_form.find('.js-form-submit').on('click', function(){
      			$(this).addClass('disabled').closest('.js-form-control').find('.js-preloader').addClass('active');
    			});

		      // target_form
		      //   .off('ajax:send').on('ajax:send', function(e, data){
		      //     // _checkSpinner(target_form);
		      //   })
		      //   .off('ajax:complete').on('ajax:complete', function(e, data){
		      //     // _checkSpinner(target_form);
		      //   })
		      //   .off('ajax:success').on('ajax:success', function(e, data){
		      //     // TODO: handler
		      //   })
		      //   .off('ajax:error').on('ajax:error', function(e, data){
		      //     // TODO:обработка ошибок
		      //   });
		    });


		    // CREATE FULFILLED DREAM

		    $(document).off('show_create-fulfilled-dream').on('show_create-fulfilled-dream', function(e, data){
		      var target_form = $('.jmod-container form');

		      target_form.find('.js-imageLoader').imageLoader();

		      target_form.find('.js-validation').formValidation();

					//NOTE: not ajax
    			target_form.find('.js-form-submit').on('click', function(){
      			$(this).addClass('disabled').closest('.js-form-control').find('.js-preloader').addClass('active');
    			});

		      // target_form
		      //   .off('ajax:send').on('ajax:send', function(e, data){
		      //     // _checkSpinner(target_form);
		      //   })
		      //   .off('ajax:complete').on('ajax:complete', function(e, data){
		      //     // _checkSpinner(target_form);
		      //   })
		      //   .off('ajax:success').on('ajax:success', function(e, data){
		      //     // TODO: handler
		      //   })
		      //   .off('ajax:error').on('ajax:error', function(e, data){
		      //     // TODO:обработка ошибок
		      //   });
		    });


		    // ADD TO FEED

		    $(document).off('show_add_to_feed').on('show_add_to_feed', function(e, data){
		      var
		      jmod_btn = $(e.btn),
		      target_form = $('.jmod-container form');

		      target_form.find('.js-add-to-feed-slider').slick({
		        infinite: false,
		        slidesToShow: 5,
		        slidesToScroll: 5,
		        variableWidth: true
		      });

		      target_form
		        .off('ajax:send').on('ajax:send', function(e, data){
		          _checkSpinner(target_form);
		        })
		        .off('ajax:complete').on('ajax:complete', function(e, data){
		          _checkSpinner(target_form);
		        })
			      .off('ajax:success').on('ajax:success', function(e, data){
			        var
			        feed = $('.js-feed'),
			        feed_items = feed.find('.js-tooltipster'),
			        target_item = $(data).find('.js-tooltipster-content').closest('.js-tooltipster');

			        $('.js-feed-add-btn').after(data);

			        feed_items.each(function(){
			          if ( $(this).data('dreamerId') == target_item.data('dreamerId') ){
			            $(this).remove();
			          }
			        });

			        feed.find('.js-tooltipster').not('.tooltipstered').createTooltip();

			        jmod_btn.jMod('hide');
			      })
		        .off('ajax:error').on('ajax:error', function(e, data){
		          // TODO:обработка ошибок
		        });
		    });


		    // AVATAR & DREAMBOOCK BG

		    $(document).on('show_avatar show_dreambook_bg', function(e, data){
		      var
		      jmod_btn = $(e.btn),
		      e_type = e.type,
		      target_form = $('.jmod-container form'),
		      load_btn = $('.js-imageLoader');

		      load_btn.imageLoader({crop: true});

		      target_form
		        .off('ajax:send').on('ajax:send', function(e, data){
		          _checkSpinner(target_form);
		        })
		        .off('ajax:complete').on('ajax:complete', function(e, data){
		          _checkSpinner(target_form);
		        })
		        .off('ajax:success').on('ajax:success', function(e, data){
		          switch(e_type){
		            case('show_avatar'):
		              $('.js-img-avatar').attr('src', data.avatar_url + '?random');
		              break;
		            case('show_dreambook_bg'):
		              var image = new Image();
		              image.setAttribute('src', data.dreambook_bg_url + '?random');
		              $('.js-dreambook_bg').html(image);
		              break;
		          }

		          jmod_btn.jMod('hide');
		        })
		        .off('ajax:error').on('ajax:error', function(e, data){
		          // TODO:обработка ошибок
		        });
		    });


		    // SEND MESSSAGE

		    $(document).on('show_send_message', function(e, data){
		      var
		      jmod_btn = $(e.btn),
		      target_form = $('.jmod-container form');

		      target_form.find('.js-validation').formValidation();

					//NOTE: not ajax
    			target_form.find('.js-form-submit').on('click', function(){
      			$(this).addClass('disabled').closest('.js-form-control').find('.js-preloader').addClass('active');
    			});

		      // target_form
		      //   .off('ajax:send').on('ajax:send', function(e, data){
		      //     // _checkSpinner(target_form);
		      //   })
		      //   .off('ajax:complete').on('ajax:complete', function(e, data){
		      //     // _checkSpinner(target_form);
		      //   })
		      //   .off('ajax:success').on('ajax:success', function(e, data){
		      //     // TODO: handler
		      //   })
		      //   .off('ajax:error').on('ajax:error', function(e, data){
		      //     // TODO:обработка ошибок
		      //   });
		    });

		}

	}

})(jQuery);
