// This plugin is responsible for the dynamic load data into an overflow-container
// options:
//  url(string): request url (default: 'append')
//  page_num(string): hash parameter sent in the request
//  ajaxSuccess(func): callback afrter ajax success
//  reverse(boolean): if true, container is to scroll to the last child and new content should be added with 'prepend'.
// Public method: 'init', 'destroy' ( $(...).scrollLoader('destroy'); )

(function($){

  var methods = {

    init: function(options) 
    {
      return this.each(function(){ 
        var 
        $this = $(this),
        data = $this.data('scrollLoader');
         
        if (!data) {
          $this.addClass('scrollLoader').wrap('<div class="scrollLoader_wrap"></div>');

          options = $.extend({
            reverse: false,
            arrows: false
          }, options);

          $(this).data('scrollLoader', {
            target  : $this,
            loading : false,
            options : options
          });

          methods._inspect($this);

          if(options.arrows == true){
            methods._arrows($this);
          }
        }
      });
    },

    destroy: function() 
    {
      return this.each(function(){
        var 
        $this = $(this),
        data = $this.data('scrollLoader');

        $this.unbind('scroll');
        $(window).unbind('.scrollLoader');
        $this.removeData('scrollLoader');
      });
    },

    _arrows: function(elem)
    {
      elem
        .closest('.scrollLoader_wrap')
        .append('<div class="scrollLoader_btn scrollLoader_btn-next"></div> <div class="scrollLoader_btn scrollLoader_btn-prev"></div>');

      $(document).off('click', '.scrollLoader_btn-next').on('click', '.scrollLoader_btn-next', function(){
        elem.stop().animate({scrollTop: elem.scrollTop() - 100}, 200);
      });

      $(document).off('click', '.scrollLoader_btn-prev').on('click', '.scrollLoader_btn-prev', function(){
        elem.stop().animate({scrollTop: elem.scrollTop() + 100}, 200);
      });    
    },

    _inspect: function(elem)
    {
      if(elem.data('scrollLoader').options.reverse){
        elem.scrollTop(elem[0].scrollHeight);

        elem.bind('scroll', function(){
          var
          scroll = elem.scrollTop();

          if ( (scroll < 1) && !elem.data('scrollLoader').options.loading) {
            methods._updContent(elem);
            elem.data('scrollLoader').options.loading = true;
          }   
        });          
      }else {
        elem.bind('scroll', function() {
          var 
          height = elem.height(),
          scroll = elem.scrollTop(),
          scrollHeight = elem[0].scrollHeight,
          maxScroll = scrollHeight - height;

          if ((scroll >= maxScroll - 100) && !elem.data('scrollLoader').options.loading) {
            elem.data('scrollLoader').options.loading = true;
            elem[0].scrollTop = scroll;
            methods._updContent(elem);
          }
        });
      }
    },

    _updContent: function(elem, callback)
    {
      $.get(elem.data('scrollLoader').options.url, {page: elem.data('scrollLoader').options.page_num})
        .done(function(data) {
          elem.data('scrollLoader').options.ajaxSuccess(elem, data);
        })
        .fail(function(data) {
          // TODO: front: сделать обработку ошибок
        });
    }
  };

  $.fn.scrollLoader = function(method) {
    
    if ( methods[method] ) {
      return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' not fined jQuery.scrollLoader' );
    }    
  
  };

})(jQuery);









