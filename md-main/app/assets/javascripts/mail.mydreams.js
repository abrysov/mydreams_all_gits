$(function(){
  var mail = {
    
    init: function()
    {
      var that = this;

      //if modal msg
      $(document).off('show_send_message').on('show_send_message', function(){
        that.message_container = $('.js-message-container');
        that.message_form = $('.js-chat-form');
        that.attachment_container = that.message_form.find('.js-attachment-container');
      });

      $(document).off('click', '.js-chat-close').on('click', '.js-chat-close', function(){
        $(this).closest('.js-conversation').removeClass('active');
        $(this).addClass('hide');
        $(this).closest('.js-chat').slideUp(400).scrollLoader('destroy'); 
      });  

      //chat
      $(document).off('click', '.js-chat-init').on('click', '.js-chat-init', function(e){
        if ($(this).hasClass('active')) {
          return;
        }else {
          $(this)
            .off('ajax:success').on('ajax:success', function(e, data){
              that.conversation = $(this).closest('.js-conversation'); 
              that.chat = that.conversation.find('.js-chat');

              var
              page_num = that.chat.data('page'), 
              url = $(this).attr('href'),
              userbar_message_notification = $('.js-user-menu-link[data-target-page=message]'),
              dreambook_message_notification = $('.js-flybook-link[data-target-page=message]'),
              pager = $('.js-pager'),
              conversation_counter = that.conversation.find('.js-new-messages-val'),
              dreambook_notifications;

              //Обновляем счетчик переписки и чекаем нотификации. Пока нет сокетов так.
              if (pager.length && conversation_counter.length) {
                var
                pager_val = pager.text(),
                conversation_val = conversation_counter.text(),
                current_new_message = pager_val - conversation_val;

                pager.text( current_new_message || '');

                conversation_counter.closest('.js-new-messages').html('');

                if(current_new_message == 0){
                  pager.addClass('disabled');
                  userbar_message_notification.find('.counter_new').remove();
                  dreambook_message_notification.find('.new').remove();
                  dreambook_notifications = $('.js-flybook-link').find('.new');
                
                  if (dreambook_notifications.length == 0) {
                    $('.js-notification').removeClass('active');
                  };
                }else {
                  userbar_message_notification.find('.counter_new').text( current_new_message );
                  dreambook_message_notification.find('.new').text( current_new_message );
                }                
              };

              that.chat.find('.js-chat-messages').html(data);         
              that.conversation.siblings('.active').find('.js-chat-close').trigger('click');

              that.chat.slideDown(400, function(){
                that.message_container = that.chat.find('.js-message-container');
                that.message_form = that.chat.find('.js-chat-form');
                that.attachment_container = that.message_form.find('.js-attachment-container'); 
                
                that.message_container.scrollLoader({
                  arrows: true,
                  reverse: true,
                  url: url,
                  page_num: page_num += 1,
                  ajaxSuccess: function(origin, data)
                  {
                    if (data.last_page) {
                      origin.scrollLoader('destroy');
                    }else {
                      var firstEl = origin.children().first();
                      origin.prepend(data);
                      origin.scrollTop(firstEl.position().top);
                      origin.data('scrollLoader').options.page_num += 1;
                      origin.data('scrollLoader').options.loading = false;                  
                    }
                  }
                });
              }).find('.js-chat-close').removeClass('hide');
              
              that.conversation.addClass('active');

            })
            .off('ajax:error').on('ajax:error', function(e, data){
              // TODO: handler
            });
        }
      });

      $(document).off('click', '.js-send-message').on('click', '.js-send-message', function(e){
        e.preventDefault();

        var 
        modal = $(this).data('modal') ? true : false,
        url = that.message_form.attr('action'),
        form_data = new FormData(that.message_form[0]);
          
        $.ajax({
          url: url,
          type: "POST",
          processData: false,
          contentType: false,
          data: form_data
        })
        .success(function (data){ 
          if (modal) {
            $('.jmod-close-button').trigger('click');
          }else{
            that.message_container.append(data);
            that.message_container.scrollTop(that.message_container[0].scrollHeight);              
            that.message_form.find('textarea').val('');
            that.attachment_container.html('');
          };
        })
        .error(function (data){
          // that.message_container.prepend('Error');
          // TODO: handler
        });
      });
    }
  }

  mail.init();
});

