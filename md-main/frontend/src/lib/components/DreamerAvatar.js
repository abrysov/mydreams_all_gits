import React from "react";

import DP from "presenters/Dreamer";

function getAvatarSize(size) {
  switch(size) {
    case 'xs':
    case 's':
      return 'small';
    case 'm':
      return 'pre_medium';
    case 'l':
      return 'medium';
    default:
      return 'small';
  }

}

export default function({ dreamer, size }) {
  const avatarSize = getAvatarSize(size);

  return (
    <a href={DP.url(dreamer)} className={`avatar size-${size}`}>
      <img alt={dreamer.full_name} src={DP.avatar(dreamer, avatarSize)}/>
    </a>
  );
}
