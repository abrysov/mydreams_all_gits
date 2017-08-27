import React from "react";

// VK seems to match URLs like that:
const linkMatch = /(https?:\/\/)?((?:[A-Za-z\$0-9А-Яа-яёЁ](?:[A-Za-z\$0-9\-\_А-Яа-яёЁ]*[A-Za-z\$0-9А-Яа-яёЁ])?\.){1,5}[A-Za-z\$рфуконлайнстРФУКОНЛАЙНСТ\-\d]{2,22}(?::\d{2,5})?)((?:\/(?:(?:\&amp;|\&#33;|,[_%]|[A-Za-z0-9А-Яа-яёЁ\-\_#%?+\/\$.~=;:]+|\[[A-Za-z0-9А-Яа-яёЁ\-\_#%?+\/\$.,~=;:]*\]|\([A-Za-z0-9А-Яа-яёЁ\-\_#%?+\/\$.,~=;:]*\))*(?:,[_%]|[A-Za-z0-9А-Яа-яёЁ\-\_#%?+\/\$.~=;:]*[A-Za-z0-9А-Яа-яёЁ\_#%?+\/\$~=]|\[[A-Za-z0-9А-Яа-яёЁ\-\_#%?+\/\$.,~=;:]*\]|\([A-Za-z0-9А-Яа-яёЁ\-\_#%?+\/\$.,~=;:]*\)))?)?)/ig;
const BR = '<br/>';

export default class HyperText extends React.Component {
  parseAll(text = '') {

    const makeLinks = this.props.links || true;
    const makeNewlines = this.props.newlines || true;

    var result = [text];

    // Get links from text.
    if (makeLinks) {
      result = this.parseLinks(result);
    }

    // Separate newlines by <br/>.
    if (makeNewlines) {
      result = this.parseNewlines(result);
    }

    return result;

  }

  parseLinks(rawArray) {
    var result = [],
        matches,
        index,
        link;

    rawArray.forEach((text) => {
      while (text) {
        matches = linkMatch.exec(text);
        if (matches !== null) {
          link = matches[0];
          index = matches.index;
          index && result.push(text.slice(0, index));
          result.push(link);
          text = text.slice(index + link.length);
        } else {
          result.push(text);
          text = '';
        }
      }
    });

    return result;
  }

  parseNewlines(rawArray) {
    var result = [];

    rawArray.forEach((text) => {
      var lines = text.split(/\n/);
      lines.forEach((item, i) => {
        result.push(item);
        if (i < lines.length - 1) {
          result.push(BR);
        }
      });
    });

    return result;
  }

  renderParts(chunks) {
    return chunks.map((chunk) => {
      if (chunk === BR) {
        return <br />;
      } else if (linkMatch.test(chunk)) {
        let url = (chunk.slice(0, 4) !== 'http') ? 'http://' + chunk : chunk;
        return <a href={url} rel="nofollow">{chunk}</a>;
      } else {
        return chunk;
      }
    });
  }

  render() {
    if (typeof this.props.children === 'string') {
      const chunks = this.parseAll(this.props.children);
      return (<p>{this.renderParts(chunks)}</p>);
    } else {
      console.warn('HyperText works only with plaintext children, no nested Components.');
      return <p></p>;
    }
  }
}

