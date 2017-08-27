import React from 'react';
import { connect } from 'react-redux';
import cx from "classnames";

import ContentEditable from "lib/components/ContentEditable";
import LikesBlock from "lib/components/LikesBlock";
import Comments from "lib/components/Comments";
import DreamerAvatar from "lib/components/DreamerAvatar";
import DreamPhotoUpload from "./DreamPhotoUpload";

import DP from "presenters/Dream";

import {
  loadDream,
  handleBuyMarkClick,
  handleStartEdit,
  handleRemove,
  handleCancelEdit,
  handleSave,
  handlePhotoChange,
  handleFieldChange,
} from "../Actions";

class Root extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadDream(this.props.dreamId));
  }

  render() {
    const { state, currentUser, dispatch } = this.props;
    const { isEditing, dream } = state;
    const dreamJS = dream.toJS();

    if (!dreamJS.id) return null;

    return (
      <div>
        <div className={`dream-page`}>
          <div className="dream-block">
            <div className="dream">
              <div className="header">
                <div className="user-card">
                  <DreamerAvatar dreamer={dreamJS.dreamer} size="m" />

                  <div className="description">
                    <a href={DP.dreamerUrl(dreamJS)}>{DP.dreamerFullName(dreamJS)}</a>
                    <div className="icon-text">
                      <div className="icon size-8 time"></div>
                      <span className="text">{DP.createdAt(dreamJS)}</span>
                    </div>
                  </div>
                </div>
                { isEditing ?
                <div className="action-buttons">
                  <a className="cancel" href="#" onClick={() => dispatch(handleCancelEdit())}>Вернуть</a>
                  <a className="save" href="#" onClick={() => dispatch(handleSave())}>Сохранить</a>
                </div>
                :
                <div className="action-buttons">
                  <a className="edit" href="#" onClick={() => dispatch(handleStartEdit())}>Редактировать</a>
                  <a className="delete" href="#" onClick={() => dispatch(handleRemove())}>Удалить Мечту</a>
                </div> }
              </div>

              {isEditing ?
                <ContentEditable
                  className="title"
                  element="h2"
                  onChange={(e) => dispatch(handleFieldChange({ name: 'title', value: e.target.value}))}>{dreamJS.title}</ContentEditable>
                : <h2 className="title">{dreamJS.title}</h2> }

                <div className="dream-image-block">
                  <div className={`label size-l ${DP.certificateTypeClass(dreamJS)}`}>{DP.certificateType(dreamJS)}</div>
                  <DreamPhotoUpload
                    isEditing={isEditing}
                    image={DP.photo(dreamJS, 'large')}
                    onSelect={(e) => dispatch(handlePhotoChange(e))} />
                </div>
            </div>

            <div className="action-list">
              { /*
              <a className="logo" href="#">
                <img src="//d1bqk81vosxcch.cloudfront.net/assets/new/logos/mvideo-38b524e8216af79968520bc2f7b043becc7d4fddfd94f96f61a3f71ff61d2442.png" alt="Mvideo" />
              </a>
              */ }
              { /* <div className="button accent yellow get-price">Узнать цену</div> */ }
              <div className="button accent gray circle-icon" onClick={() => dispatch(handleBuyMarkClick())}>
                <div className="circle"></div>
                <span>Купить марку</span>
              </div>
              { /*
              <div className="button accent gray circle-icon">
                <div className="circle"></div>
                <span>Предложить другу</span>
              </div>
              */ }
              <div className="button accent gray circle-icon">
                <div className="circle"></div>
                <span>Поделиться</span>
              </div>
              <div className="button accent gray circle-icon">
                <div className="circle"></div>
                <span>Мечта сбылась</span>
              </div>
            </div>
          </div>

              {isEditing ?
                <ContentEditable
                  className="desc"
                  element="p"
                  onChange={(e) => dispatch(handleFieldChange({name: 'description', value: e.target.value}))}>{dreamJS.description}</ContentEditable>
                : <p className="desc">{dreamJS.description}</p> }

          <LikesBlock
            entityType="dreamJS"
            entityId={dreamJS.id}
            likesCount={dreamJS.likes_count}
            lastLikes={dreamJS.last_likes}
            likedByMe={dreamJS.liked_by_me}
            currentUser={currentUser} />

          <Comments
            resourceType="dream"
            resourceId={dreamJS.id}
            lastComments={dreamJS.last_comments}
            totalCommentsCount={dreamJS.comments_count} />

        </div>
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.dreamPage,
    currentUser: state.user,
    ownProps
  })
)(Root);
