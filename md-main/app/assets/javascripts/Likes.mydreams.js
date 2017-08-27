// С помощью этого модуля осуществляется отображение и учет лайков

var Likes = (function($){

  var methods = {

    init: function()
    {
      var that = this;

      $(document).off('click', '.js-like-btn').on('click', '.js-like-btn', function(e){
        e.preventDefault();

        that.page = $('.js-single-page');
        that.like_btn = $(this);
        that.action = that.like_btn.attr('data-ctrl-type');
        that.target = that.like_btn.data('target');
        that.id = that.like_btn.data('id');
        that.url = '/' + that.target + '/' + that.id + '/' + that.action + '.json';
        that.like_text = that.like_btn.find('.js-text-action');
        that.bubble_counter = that.like_btn.find('.js-bubble-counter');
        that.bubble_users = that.like_btn.find('.js-bubble_items');

        that._get();
      });
    },

    _get: function()
    {
      var that = this;

      $.get(that.url)
        .done(function(data) {
          that._update(data);
        })
        .fail(function(data) {
          // TODO: front: сделать обработку ошибок
        });
    },

    _update: function(data)
    {
      var
      val = JSON.parse(data.liked_dreamers),
      max = data.all_liked > 5 ? 5 : data.all_liked,
      likes_counter = this.like_btn.find('.js-like-btn-count'),
      liked_link = this.like_btn.find('.js-bubble-link'),
      result = [];

      //список лайкнувших
      for (var i = 0; i < max; i++) {
        var
        link = document.createElement('a'),
        img = document.createElement('img');

        link.setAttribute('href', '/account/dreamers/' + val[i].id + '/dreams');

        img.setAttribute('src', val[i].avatar_url_or_default_small);

        $(link).append(img);

        result.push(link);
      };

      //upd кнопки
      this.action == 'like' ? this.like_btn.attr('data-ctrl-type', 'unlike') : this.like_btn.attr('data-ctrl-type', 'like');
      this.like_text.text(data.liked_action);

      //счетчик лайков
      likes_counter.html(data.all_liked);

      //список юзеров
      this.bubble_users.html(result);

      //tooltips
      this.bubble_counter.html(data.liked_title);

      if (this.action == "unlike") {
        this.like_btn.addClass('empty');
      }else {
        this.like_btn.removeClass('empty');        
      }

      //скрыть/показать ссылку на полный список
      if (data.all_liked > max)
        liked_link.addClass('active');
      else
        liked_link.removeClass('active');

      if (data.all_liked > 0) {

        if (! this.like_btn.hasClass('js-tooltipster')) {   
          this.like_btn.addClass('js-tooltipster');       
        }else {
          this.like_btn.tooltipster('destroy');
        }

        this.like_btn.createTooltip({
          functionBefore: function(origin, continueTooltip){
            continueTooltip();

            if ( origin.data('t-target') == 'comments' || 'liked_list') {
              var
              tooltip = $('.tooltipster-base'),
              tooltip_link = tooltip.find('.jmod-btn');

              tooltip_link.replaceWith('<div class="jmod-btn-trigger">'+tooltip_link.text()+'</div>');

              $(document).off('click', '.jmod-btn-trigger').on('click', '.jmod-btn-trigger', function(){
                origin.find('.jmod-btn').trigger('click');
              });
            };
          }  
        })
        .tooltipster('show');

      }else {
        this.like_btn
          .removeClass('js-tooltipster')
          .tooltipster('hide')
          .tooltipster('destroy');
      }
    }
  }

  return methods;

})(jQuery);
