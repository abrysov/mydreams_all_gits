import Immutable from "immutable";

class Notification extends Immutable.Record({
  id: -1,
  fullName: "",
  link: "",
  avatar: "",
  message: "",
  conversation_id: -1
}) {

}

export class State extends Immutable.Record({
  notifications: Immutable.List()
}) {
  getById(id) {
    return this.notifications.find((n) => n.id == id);
  }

  removeNotification(id) {
    return this.update('notifications', (list) => {
      return list.filter((n) => n.id != id);
    });
  }

  addNotification(data) {
    return this.update('notifications', (list) => {
      return list.push(new Notification({
        id: data.id,
        conversation_id: data.conversation_id,
        fullName: `${data.dreamer_first_name} ${data.dreamer_last_name}`,
        link: Routes.d_path(data.dreamer_id),
        avatar: data.dreamer_avatar,
        message: data.message
      }));
    });
  }
}
