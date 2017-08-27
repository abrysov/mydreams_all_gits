import Routes from "routes";
import React from "react";
import { connect } from "react-redux";

import {
  loadPosts,
  loadNextPosts,
  createPost,
  showPhoto
} from "../Actions";

import BodyInfinityScroll from "lib/components/BodyInfinityScroll";

import NewPostForm from "./NewPostForm";
import Post from "./Post";

class Root extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadPosts());
  }

  render() {
    const { currentUser, state, dispatch } = this.props;

    const {
      widgetParams,
      isPostsListLoadStarted,
      posts
    } = state;

    return (
      <div className="feed-container">
        { widgetParams.isAddPostFormShown ?
        <NewPostForm currentUser={currentUser} onSubmit={(data) => dispatch(createPost(data))} />
        : ""}
        { posts.size > 0 ?
        <BodyInfinityScroll className="posts-list"
                            isLoading={state.isPostsListLoadStarted}
                            onScrollEnd={(e) => dispatch(loadNextPosts())}>
          {posts.map(this.renderPost.bind(this))}
        </BodyInfinityScroll>
        : <div className="info">Нет новостей</div>}
      </div>
    );
  }

  renderPost(post) {
    const postJs = post.toJS();
    const currentUser = this.props.currentUser.toJS();
    const actions = {
      onPhotoClick: (payload) => this.props.dispatch(showPhoto(payload))
    };

    return <Post key={postJs.id} currentUser={currentUser} {...postJs} {...actions} />
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.postsFeed,
    currentUser: state.user.user
  })
)(Root);



