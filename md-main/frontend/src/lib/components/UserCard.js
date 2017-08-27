import React from "react";
import { connect } from "react-redux";
import { getJson } from "lib/ajax";
import datetime from "lib/datetime";

import {
  buildApiDreamer,
  buildApiDreamerPhotos
} from "lib/apiUrlsBuilders";

class UserCard extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      user: null,
      photos: null
    };
  }

  componentDidMount() {
    const userUrl = buildApiDreamer(this.props.route.userId);
    const photosUrl = buildApiDreamerPhotos(this.props.route.userId);
    getJson(userUrl)
      .then(
        (r) => {
          this.setState({
            user: r.dreamer
          });
        }
      );
    getJson(photosUrl)
      .then(
        (r) => {
          this.setState({
            photos: r.photos
          });
        }
      );
  }

  render() {
    if (this.state.user === null) return (<div></div>);

    const activeClass = this.props.route.activeClass;

    const user = this.state.user;
    const userId = user.id;

    const userName = user.full_name;
    const userAge = datetime.calculateAge(user.birthday);
    const userCountry = user.country ? user.country.name : 'N/A';
    const userCity = user.city ? user.city.name : 'N/A';

    return (
      <div className="top">

        <ul className="vertical-menu">
          <li>
            <a href={Routes.d_path(userId)} className="active user-card">
              <span className="avatar size-s">
                <img src={user.avatar.small} alt={userName} />
              </span>
              <span className="description">
                <strong>{userName}</strong>
                <span className="icon-text info">
                  <span className={"icon size-8 " + user.gender}></span>
                  <span>{`${userAge}, ${userCountry}, ${userCity}`}</span>
                </span>
              </span>
            </a>
          </li>
        </ul>

        <div className="wrapper">

          { this.renderPhotos() }

          <ul className="widget-stats">
            <li title="Мечты">
              <a href={Routes.d_dreams_path(userId)}>
                <div className="icon"></div>
                <div className="number">{user.dreams_count}</div>
              </a>
            </li>
            <li title="Сбывшиеся" className={ activeClass === 'fulfilled_dreams' ? 'active' : '' }>
              <a href={Routes.d_fulfilled_dreams_path(userId)}>
                <div className="icon"></div>
                <div className="number">{user.fulfilled_dreams_count}</div>
              </a>
            </li>
            <li title="Запуски">
              <div className="icon"></div>
              <div className="number">{user.launches_count}</div>
            </li>
            <li title="Друзья">
              <a href={Routes.d_friends_path(userId)}>
                <div className="icon"></div>
                <div className="number">{user.friends_count}</div>
              </a>
            </li>
            <li title="Подписчики">
              <a href={Routes.d_followers_path(userId)}>
                <div className="icon"></div>
                <div className="number">{user.followers_count}</div>
              </a>
            </li>
          </ul>

        </div>
      </div>
    );
  }

  renderPhotos() {
    const photos = this.state.photos;
    if (!photos || photos.length === 0) return '';
    return (
      <div>
        <div className="right-title">
          Фотоальбом
          <div className="number">23</div>
        </div>
        <br />
        <div className="widget-photos">
          { photos.map((p) => {
            const style = {backgroundImage: `url(${p.preview})`};
            return (<a className="img" href="#" style={style}
                       onClick={(e) => { e.preventDefault(); return false; }}></a>);
          }) }
        </div>
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    ownProps
  })
)(UserCard);