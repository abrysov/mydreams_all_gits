import moment from "moment";
import Immutable from "immutable";

class WidgetParams extends Immutable.Record({
  dataUrlBuilder: () => "",
  dataUrlParams: {},
  isAddPostFormShown: true,
  apiCollectionKey: 'feeds' // feeds || updates || comments || recommendations
}) {}

class Post extends Immutable.Record({
  id: -1,
  content: "",
  likes_count: 0,
  last_likes: [],
  liked_by_me: false,
  comments_count: 0,
  last_comments: [],
  created_at: moment(),
  dreamer: {},
  photos: [],
  isEditing: false
}) { }

export class State extends Immutable.Record({
  currentPage: 1,
  isPostsListLoadStarted: false,
  posts: Immutable.List(),
  widgetParams: new WidgetParams()
}) {
  setParams(params) {
    return this.set('widgetParams', new WidgetParams(params));
  }

  getDataUrl(params = {}) {
    return this.widgetParams.dataUrlBuilder(Object.assign({}, this.widgetParams.dataUrlParams, params));
  }

  handleLoadPostsSuccess(response) {
    const collection = response[this.widgetParams.apiCollectionKey].map((p) => new Post(p));


    return this
      .set('posts', Immutable.fromJS(collection))
      .set('currentPage', response.meta.page)
      .set('isPostsListLoadStarted', false);
  }

  handleLoadNextPostsSuccess(response) {
    const collection = response[this.widgetParams.apiCollectionKey].map((p) => new Post(p));

    if (collection.length > 0) {
      const currentIds = this.posts.map((d) => d.get('id'));

      const adds = Immutable.fromJS(collection)
                        .filter((d) => !currentIds.contains(d.get('id')));

      return this.update('posts', (d) => d.concat(adds))
                  .set('currentPage', response.meta.page)
                  .set('isPostsListLoadStarted', false);
    }

    return this.set('isPostsListLoadStarted', false);
  }

  handleCreatePostSuccess(response) {
    return this.update('posts', (d) => d.unshift(new Post(response.post)));
  }

  handleEditPostBegin(postId) {
    const index = this.posts.findIndex((item) => (postId === item.id));
    return this.setIn(['posts', index, 'isEditing'], true);
  }

  handleUpdatePostSuccess(post) {
    const updatedPost = new Post(post); // `isEditing` is set to `false` implicitly
    const index = this.posts.findIndex((item) => (post.id === item.id));
    return this.setIn(['posts', index], updatedPost);
  }

  handleUpdatePostFailed(postId) {
    const index = this.posts.findIndex((item) => (postId === item.id));
    return this.setIn(['posts', index, 'isEditing'], false);
  }
}
