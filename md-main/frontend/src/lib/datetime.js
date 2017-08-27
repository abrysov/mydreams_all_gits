import moment from "moment";

export default {
  formatMessageDate: (date) => moment(date).format("D MMM"),
  formatUpdateDate: (date) => moment(date).format("H:mm D MMM"),
  formatPostDate: (date) => moment(date).format("H:mm D MMM"),
  formatCommentDate: (date) => moment(date).format("H:mm D MMM"),
  calculateAge: (birthday) => moment().diff(moment(birthday), 'years')
};

