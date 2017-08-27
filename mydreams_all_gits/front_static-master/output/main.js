//base js to demonstrate show & hide

$(".show-head_feed").on('click', function(){
    $(this).toggleClass('is-open');
    $('.head_feed').toggleClass('is-hidden');
});

$(".userbar__avatar-name").on('click', function(){
    $('.userbar__list').toggleClass('is-hidden');
});
