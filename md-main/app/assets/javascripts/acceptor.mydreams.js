(function($){
  var suggestDreamAction = function(){
    var links = $('.js-action');

    links
      .off('ajax:success').on('ajax:success', function(e, data){
        var
        target_elem = $(e.target).closest('.js-suggest-dream'),
        container = target_elem.closest('.js-suggested-dreams'),
        group = container.find('.js-suggested-dreams-group'),
        suggest_dream_count = target_elem.siblings('.js-suggest-dream').length,
        fake = $('<div class="card fake-card"></div>');

        if(suggest_dream_count < 1){
          container.remove(); 
        } 

        if(suggest_dream_count >= 1) {
          target_elem.remove();
          group.append(fake);
        }
        
        if ($(e.target).data('action') == 'accept') {
          $('.js-add-card').after(data).next().find('.card__wrap').removeClass('flip');
        };
      })
      .off('ajax:error').on('ajax:error', function(){
        //TODO: handler
      });
  }

  suggestDreamAction();

  // return suggestDreamAction;
})(jQuery)