// This plugin is responsible for modals
// options:
//  speed (num): animation speed
//  width (str): modal width
// Public method: 'init' with args - options obj, 'show' and 'destroy' with args - target link and target modal
 
(function($){

  var methods = {

  	current_type: null,
		
		this_modal: null,

    state: false,

    init: function(options) 
    {
      return this.each(function(){ 
        var 
        $this = $(this),
        data = $this.data('jMod');
        
        if (!data) {
          $this.addClass('jMod');

          options = $.extend({
            speed: $this.data('jmod-speed') || 300,
            modal_width: $this.data('jmod-width') || 'auto'
          }, options);

          $this.data('jMod', {
            target  : $this,
            options : options
          });

          $this.off('ajax:success').on('ajax:success', function(e, xhr_data){
            methods.current_type = $(this).attr('data-modal-type');
            
            methods.this_modal = $('.jmod-container');
		        
            //кэшируем конфиг для текущей модалки в data контейнера, 
            //на случай если есть внутренние ссылки на другие модальные окна(форма регистрации)
            methods.this_modal.data('jMod', $this.data('jMod'));
            
            methods.show($this, xhr_data);
          });	
        }
      });
    },

    destroy: function() 
    {
      return this.each(function(){
        var
        $this = $(this),
        data = $this.data('jMod');

        $('.jmod-overlay').remove();

        $(window).unbind('.jMod');

        $this.removeData('jMod');

        $( 'html' ).css( 'overflow-y', 'auto' );

        $( 'body' ).removeClass('fix').css( 'overflow-y', 'auto' );
      });
    },

    hide: function($this)
    {
      var $this = $this || this;

      return $this.each(function(){
        var
        data = methods.this_modal.data('jMod');

        $('.jmod-overlay').fadeOut(data.options.speed, function(){
          methods.this_modal.html('').css('style', '').unwrap('.jmod-overlay');
          methods.state = false;
        });

        methods._createEvent($this, 'hide');

        // $(window).unbind('.jMod');

        $( 'html' ).css( 'overflow-y', 'auto' );

        $( 'body' ).removeClass('fix').css( 'overflow-y', 'auto' );
      });

    },

    show: function($this, xhr_data)
    {
      var $this = $this || this;

      return $this.each(function(){
        if(xhr_data){
          var data = methods.this_modal.data('jMod');

          if (methods.state === false) {
            var 
            overlay = $('<div class="jmod-overlay"></div>'),
            modal_wrapper = $( '<div class="jmod-wrapper"/>'),
            modal_scroller = $( '<div class="jmod-scroller"/>'),
            modal_close_overlay = $( '<div class="jmod-close-overlay"/>'),
            modal_window = $( '<div class="jmod-window"/>'),
            modal_close_button = $( '<div class="jmod-close-button"/>'),
            modal_content = $( '<div class="jmod-content"/>');

            overlay.append( modal_wrapper );
            modal_wrapper.append( modal_scroller );
            modal_scroller.append( modal_close_overlay );
            modal_scroller.append( modal_window );
            modal_window.append( modal_content );
            modal_window.append( modal_close_button );

            if ( data.options.modal_width != 'auto' ) {
              methods.this_modal.html(xhr_data).css('width', data.options.modal_width);
            } else {
              methods.this_modal.html(xhr_data);
            }

            modal_content.html(methods.this_modal);

            $('body').append(overlay).addClass('fix');

            $( 'html' ).css( 'overflow-y', 'hidden' );

            if ( $( 'body' ).height() > $( window ).height() ){
              $( 'body' ).css( 'overflow-y', 'scroll' );
            } else{
              $( 'body' ).css( 'overflow-y', 'hidden' );
            }
          
            $(document).off('click', '.jmod-close-button').on('click', '.jmod-close-button', function() {
              methods.hide($this);
            });

            $(document).off('click', '.jmod-close-overlay').on('click', '.jmod-close-overlay', function() {
              methods.hide($this);
            });

            overlay.fadeIn(data.options.speed, function(){
              if (typeof data.options.ajaxSuccess == 'function') {
                data.options.ajaxSuccess($this, methods.this_modal);
              };
            });
          }else {
            if ( data.options.modal_width != 'auto' ) {
              methods.this_modal.css('width', data.options.modal_width).html(xhr_data);
            } else {
              methods.this_modal.html(xhr_data);
            }
          } 
          
          $(document).off('click', '.jmod-close').on('click', '.jmod-close', function(e){
            methods.hide($this);
          });

          methods.state = true;

          methods._createEvent($this, 'show');
        }
      });
    },

    _createEvent: function($this, modal_event)
    {
      var 
      e = modal_event + '_' + methods.current_type,
      new_event = $.Event(e, {btn: $this});

      $(document).trigger(new_event);	
    }

  }

  $.fn.jMod = function(method) {
    
    if ( methods[method] ) {
      return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' not fined jQuery.jMod' );
    }    
  
  };

})(jQuery);

