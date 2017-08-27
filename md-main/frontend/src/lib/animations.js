import $ from "jquery";

export function animateBodyScrollTop(duration = 500, callback = () => {}) {
  $('body').stop().animate({ scrollTop: 0 }, duration);
}
