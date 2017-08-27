// Модуль предоставляет возможность добавлять комментарии на детальных страницах мечтаний и записей
 
var Comments = (function($){
  var
  form, 
  attachment_container,
  comments_container,
  textarea,
  textarea_val;

  function _sendCreate()
  {
    var 
    url = form.attr('action'),
    files = form.find('.js-attacment').val(),
    form_data = new FormData(form[0]),
    no_comments_title = $('.js-no_comment');

   $.ajax({
      url: url,
      type: "POST",
      processData: false,
      contentType: false,
      data: form_data
    })
    .success(function (data){
      if(data.errors == '1'){
        comments_container.prepend('Error');
      }else{          
        comments_container.prepend(data);
        textarea.val('');          
        attachment_container.html('');

        if (no_comments_title.length) {
          no_comments_title.remove();
        };
      }
    })
    .error(function (data){
      comments_container.prepend('Error');
    });
  };

  return {
    init: function()
    {      
      $(document).off('click', '.js-comment-send-btn').on('click', '.js-comment-send-btn', function(){
        form = $('.js-comments-form'), 
        attachment_container = form.find('.js-attachment-container'),
        comments_container = $('.js-commnets-group');       
        textarea = form.find('textarea'),
        textarea_val = $.trim(textarea.val());

        if (textarea_val != '') {
          _sendCreate();  
        };
      }); 

      $('.js-show-all-comments')
        .off('ajax:success').on('ajax:success', function(e, data){
          $(this).replaceWith(data);
        })
        .off('ajax:errors').on('ajax:errors', function(e, data){
          $(this).prepend('Connect Error').show(100).delay(2000).hide(100);
        })        
    }
  };  

})(jQuery);


