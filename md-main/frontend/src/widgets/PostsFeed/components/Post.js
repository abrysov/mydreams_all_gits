import Routes from "routes";
import React from "react";
import Immutable from "immutable";

import Header from "./Post/Header";
import Content from "./Post/Content";
import EditForm from "./Post/EditForm";
import ImageGrid from "./Post/ImageGrid";
import LikesBlock from "lib/components/LikesBlock";
import Comments from "lib/components/Comments";

export default class Post extends React.Component {
  render() {
    const {
      id,
      dreamer,
      content,
      created_at,
      likes_count,
      comments_count,
      liked_by_me,
      last_likes,
      last_comments,
      photos,
      currentUser,
      isEditing,
      onPhotoClick
    } = this.props;

    if (isEditing) {
      return (
        <div className="content-items edit">
          <EditForm currentUser={currentUser}
            content={content}
            photos={photos}
            postId={id} />
        </div>
      );
    } else {
      return (
        <div className="content-items">
          <Header postId={id}
            dreamer={dreamer}
            createdAt={created_at}
            currentUser={currentUser} />

          <Content content={content} />

          <ImageGrid photos={photos} onClick={this.handlePhotoClick.bind(this)} />

          <LikesBlock
            entityType="post"
            entityId={id}
            likesCount={likes_count}
            lastLikes={last_likes}
            likedByMe={liked_by_me}
            currentUser={currentUser} />

          <Comments
            resourceId={id}
            resourceType="post"
            lastComments={last_comments}
            totalCommentsCount={comments_count} />
        </div>
      );
    }
  }

  handlePhotoClick(photoId) {
    const photos = this.props.photos.map((p) => ({
      id: p.id,
      caption: "",
      preview: p.photo.medium,
      photo: p.photo.large
    }));
    this.props.onPhotoClick({
      photoId,
      photos: photos,
      currentPage: 1,
      canUploadNext: false
    });
  }
}
