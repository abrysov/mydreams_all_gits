// модуль отвечает за анимацию вращения карточек
var FlipCard = (function($){
  var methods = {
    init: function() {
      var that = this;

      this.cards = $('.js-flip > .card__wrap.flip');
      this.count = 0;

      $( '.card_dream__description' ).not('.is-truncated').dotdotdot();
      $( '.card_post__description' ).not('.is-truncated').dotdotdot();

      setTimeout(function flipCard() {
        $(that.cards[that.count]).removeClass('flip');

        if (that.count < that.cards.length) {
          setTimeout(flipCard, 150);
          that.count += 1;
        }
      }, 200);
    }
  };

  return methods;
})(jQuery);
