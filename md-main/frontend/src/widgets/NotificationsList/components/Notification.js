import React from "react";

export default function(props) {
  const { fullName, link, avatar, message, id, onClose, onClick } = props;
  return (
    <div className="notification" key={id} onClick={(e) => onClick(id, e)}>
      <div className="avatar size-xs">
        <img src={avatar} />
      </div>
      <a href={link} className="user-name">{fullName}</a>
      <div className="message">{message}</div>
      <div className="close-button" onClick={(e) => onClose(id, e)} />
    </div>
  );
}
