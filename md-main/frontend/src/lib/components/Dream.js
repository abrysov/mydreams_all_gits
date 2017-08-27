import React from 'react';
import moment from 'moment';

import DP from "presenters/Dream";
import DreamerAvatar from "lib/components/DreamerAvatar";

export default class Dream extends React.Component {
  onLike() {
    if (this.props.liked_by_me) {
      this.props.onUnlike(this.props.id);
    } else {
      this.props.onLike(this.props.id);
    }
  }

  render() {
    const {
      id,
      dreamer,
      photo,
      title,
      description,
      comments_count,
      launches_count,
      likes_count,
      liked_by_me,
      created_at,
      noNameMode,
      labelClass
    } = this.props;

    const dream = this.props;

    const menu = (
      <div className="menu">
        <div className="opt-list">
          <li className="icon-text">
            <div className="icon circle add">
              <span className="text">Добавить себе</span>
            </div>
          </li>
          <li className="icon-text">
            <div className="icon circle share-friends">
              <span className="text">Предложить другу</span>
            </div>
          </li>
          <li className="icon-text">
            <div className="icon circle shere">
              <span className="text">Поделиться</span>
            </div>
          </li>
          <li className="icon-text">
            <div className="icon circle gift">
              <span className="text">Подарить марку</span>
            </div>
          </li>
          <li className="icon-text">
            <div className="icon circle in-progress">
              <span className="text">Исполнить мечту</span>
            </div>
          </li>
        </div>
      </div>
    )

    const menuButton = (
      <div className="icon circle options"></div>
    )

    return (
      <div className="group">
        <div className="card">
          <div className="front">
            <a href="#" className={`label ${DP.certificateTypeClass(dream, labelClass)}`}>{DP.certificateType(dream)}</a>
            <a href={DP.url(dream)} className="picture">
              <div className="picture-wrap">
                <img alt="drean" src={DP.photo(dream, 'medium')} />
              </div>
            </a>
            <a href={DP.url(dream)} className="description">
              <h3>{title}</h3>
              <h5>{DP.description(dream, 40)}</h5>
            </a>
            <div className="reactions">
              <div className={liked_by_me ? "icon-text like active" : "icon-text like"}>
                <div className="icon" onClick={this.onLike.bind(this)}></div>
                <span className="text">{likes_count}</span>
              </div>
              <div className="icon-text in-progress">
                <div className="icon"></div>
                <span className="text">{launches_count}</span>
              </div>
              <div className="icon-text comments">
                <div className="icon"></div>
                <span className="text">{comments_count}</span>
              </div>
            </div>
            <div className="back"></div>
          </div>
        </div>

        { noNameMode === true ?
          '' :
          (<div className="user-card">
            <DreamerAvatar dreamer={dream.dreamer} size="s" />
            <div className="description">
              <a href={DP.dreamerUrl(dream)}>{DP.dreamerFullName(dream)}</a>
              <div className="icon-text">
                <div className="icon size-8 time"></div>
                <div className="text">{DP.createdAt(dream)}</div>
              </div>
            </div>
          </div>)
        }

      </div>
    );
  }
}
