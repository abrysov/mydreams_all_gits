import React from "react";

export default class Form extends React.Component {
  render() {
    const { } = this.props;

    return (
      <div className="comment-textarea">
        <div className="textarea-wrapper">
          <textarea placeholder="Комментировать…" rows="1" ref="newCommentTextArea"></textarea>
        </div>
        <div className="submit-button" onClick={this.onSubmit.bind(this)}>Отправить</div>
      </div>
    );
  }

  onSubmit() {
    const value = this.refs.newCommentTextArea.value;
    this.props.onSubmit({ value });
    this.refs.newCommentTextArea.value = '';
  }
}

