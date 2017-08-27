// Модуль отвечает за ajax подгрузку данных с помощью гема Wiselinks
//TODO: refactor init js after reload

var PageNav = (function($){

  var methods = {
    
    init: function()
    {
      var 
      that = this;

      window.wiselinks = new Wiselinks($('#js-ajax-content'), {html4: true});

      $(document).off('click', '.js-flybook-link').on('click', '.js-flybook-link', function(){
        var dreambook_notifications;

        $(this).addClass('active').siblings().removeClass('active');

        // Чекаем нотификации. Пока нет сокетов так. Новости и подписчики сразу при открытии страницы считаются просмотренными
        // в остальных разделах требуется апрув активности. 
        if ($(this).data('targetPage') == 'activities') {
          $('.js-user-menu-link[data-target-page=activities]').find('.counter_new').remove();
          $('.js-flybook-link[data-target-page=activities]').find('.new').remove();
        };

        if ($(this).data('targetPage') == 'followers') {
          $('.js-user-menu-link[data-target-page=followers]').find('.counter_new').remove();
          $('.js-flybook-link[data-target-page=followers]').find('.new').remove();
        };  

        dreambook_notifications = $('.js-flybook-link').find('.new'); 

        if ( dreambook_notifications.length == 0 ) {
          $('.js-notification').removeClass('active');
        };
      });

      $(document).off('page:done').on('page:done', function(event, $target, render, url){        
        Likes.init();

        FlipCard.init();
        
        Comments.init();

        $('.jmod-btn').each(function(){
          switch($(this).data('modal-type')){
            case 'authorization':
              $(this).jMod({
                ajaxSuccess: function(link, modal){
                  modal.find('.jmod-btn').jMod();
                }
              });
              break;
            default:
              $(this).jMod();
              break;
          }
        });

        $('.js-tooltipster').not('.tooltipstered').createTooltip({
          functionBefore: function(origin, continueTooltip){
            continueTooltip();

            var 
            tooltip = $('.tooltipster-base'),
            tooltip_link = tooltip.find('.jmod-btn');

            tooltip_link.replaceWith('<div class="jmod-btn-trigger">'+tooltip_link.text()+'</div>');
            
            $(document).off('click', '.jmod-btn-trigger').on('click', '.jmod-btn-trigger', function(){
              origin.find('.jmod-btn').trigger('click');
            });
          }
        });  
        
        $('.js-imageLoader:visible').imageLoader();
        
        $( '.message-wrapper' ).dotdotdot();
        
      });
    }
  }

  return methods;

})(jQuery);