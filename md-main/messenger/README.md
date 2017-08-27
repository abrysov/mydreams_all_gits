# Описание протокола

В каждом сообщении от клиента к серверу должен быть параметр `type`. В данный момент поддерживается три типа:

* `ping` Ping

* `im` Instant messaging

* `comments` Комментарии

Также для всех сообщений (кроме сообщений типа `ping`) должен присутствовать параметр `command`. Его значения зависят от типа сообщения. Далее идет произвольное кол-во доп. параметров

```json
{
  "type": <type>,
  "command": <command>,
  "param1": "value1",
  "param2": "value2",
  ...
}
```

Сообщение от сервера клиента имеет немного другую структуру. В сообщении, как правило, три параметра

```json
{
  "type": <type>,
  "command": <command>,
  "payload": <payload>,
}
```

Чтобы отличать ответы от пушей, клиент может добавить в запрос поле `id` и тогда в ответе на это сообщение будет ключ `reply_to` с идентификатором, который послал клиент в запросе.

## Типы данных

### Message

Name                 | Type   | Description
---------------------|--------|--------------
`id`                 | int    | Идентификатор сообщения
`conversation_id`    | int    | Идентификатор диалога
`message`            | text   | Текст сообщения
`dreamer_first_name` | string | Имя отправителя
`dreamer_last_name`  | string | Фамилия отправителя
`dreamer_age`        | int    | Возраст отправителя
`dreamer_avatar`     | url    | Аватарка отправителя

### Comment

Name                  | Type       | Description
----------------------|------------|---------------
`id`                  | int        | Идентификатор комментария
`resource_type`       | string     | Тип ресурса
`resource_id`         | int        | Идентификатор ресурса
`body`                | text       | Текст комментария
`dreamer_first_name`  | string     | Имя отправителя
`dreamer_last_name`   | string     | Фамилия отправителя
`dreamer_age`         | int        | Возраст отправителя
`dreamer_avatar`      | url        | Аватарка отправителя
`reactions`           | [Reaction] | Массив реакций

### Reaction

Name                  | Type       | Description
----------------------|------------|---------------
`id`                  | int        | Идентификатор
`reactable_type`      | string     | Тип ресурса
`reactable_id`        | int        | Идентификатор ресурса
`reaction`            | string     | Реакция
`dreamer_first_name`  | string     | Имя отправителя
`dreamer_last_name`   | string     | Фамилия отправителя


## Ping

Запрос:

```json
{
  "type": "ping"
}
```

Ответ:

```json
{
  "type": "pong"
}
```


## IM (Instant messaging)

### Команда `list`

Запрос:

```json
{
  "type": "im",
  "command": "list",
  "conversation_id": 11,
  "since_id": 0,
  "count": 10
}
```

Ответ: хеш, где ключ `conversation_id`, а значение коллекция объектов [Message](#Message)

```json
{
  "type": "im",
  "command": "list",
  "payload": {
    "conversation_id": "11",
    "since_id": 0,
    "messages": [
      {
        "id": 17,
        "conversation_id": 11,
        "message": "Привет! Как дела?",
        "dreamer_first_name": "Имя",
        "dreamer_last_name": "Фамилия",
        "dreamer_age": 29,
        "dreamer_avatar": "//asset-host/avatar/url"
      },
      ...
  ]}
}
```

### Команда `online_list`

Запрос:

```json
{
  "type": "im",
  "command": "online_list",
  "conversation_id": 11
}
```

Ответ: коллекция идентификторов пользователей

```json
{
  "type": "im",
  "command": "online_list",
  "payload": [19, 21, 23]
}
```

### Команда `send`

Запрос:

```json
{
  "type": "im",
  "command": "send",
  "conversation_id": 11,
  "message": "Привет, замкадыши",
  "attachments": [1, 2, 3]
}
```

Ответ: нет

### Команда `mark_read`

```json
{
  "type": "im",
  "command": "mark_read",
  "conversation_id": 11,
  "message_id": 22
}
```

Ответ: нет

### Пуш `message`

Payload содержит объект [Message](#Message)

```json
{
  "type": "im",
  "command": "message",
  "payload": {
    "id": 18,
    "conversation_id": 11,
    "message": "Дела как в Польше. Тот прав, у кого хуй больше",
    "dreamer_first_name": "Имя",
    "dreamer_last_name": "Фамилия",
    "dreamer_age": 13,
    "dreamer_avatar": "//asset-host/avatar/url",
    "attachments": [
      {
        "id": 1,
        "url": "//asset-host/attachment/url"
      }
    ]
  }
}
```

## Комментарии

### Команда `list`

Запрос:

```json
{
  "type": "comments",
  "command": "list",
  "resource_type": "dream",
  "resource_id": 11,
  "since_id": 0,
  "count": 10
}
```

Ответ: коллекция объектов [Comment](#Comment)

```json
{
  "type": "comments",
  "command": "list",
  "payload": [
    {
      "id": 33,
      "body": "Первый нах",
      "resource_type": "dream",
      "resource_id": 11,
      "dreamer_first_name": "Имя",
      "dreamer_last_name": "Фамилия",
      "dreamer_age": 12,
      "avatar": "//asset-host/avatar/url"
    },
    ...
  ]
}
```

### Команда `subscribe`

Запрос:

```json
{
  "type": "comments",
  "command": "subscribe",
  "resource_type": "dream",
  "resource_id": 11,
}
```

Ответ: нет

### Команда `unsubscribe`

Запрос:

```json
{
  "type": "comments",
  "command": "unsubscribe",
  "resource_type": "dream",
  "resource_id": 11,
}
```

Ответ: нет

### Команда `post`

Запрос:

```json
{
  "type": "comments",
  "command": "post",
  "resource_type": "dream",
  "resource_id": 11,
  "body": "Второй нах"
}
```

Ответ: нет

### Команда `add_reaction`

Запрос:

```json
{
  "type": "comments",
  "command": "add_reaction",
  "comment_id": 17,
  "body": "+1"
}
```

Ответ: нет

### Пуш `comment`

Payload содержит объект [Comment](#Comment)

```json
{
  "type": "comments",
  "command": "comment",
  "payload": {
    "id": 33,
    "body": "Первый нах",
    "dreamer_first_name": "Имя",
    "dreamer_last_name": "Фамилия",
    "dreamer_age": 12,
    "avatar": "//asset-host/avatar/url"
  }
}
```

### Пуш `add_reaction`

Payload содержит объект [Reaction](#Reaction)

```json
{
  "type": "comments",
  "command": "add_reaction",
  "payload": {
    "id": 33,
    "reactable_type": "Comment",
    "reactable_id": 17,
    "dreamer_first_name": "Имя",
    "dreamer_last_name": "Фамилия",
  }
}
```

## Feedback

### Пуш `create`

Чтобы отправить пуш, необходимо дернуть ендпоинт feedback/:id

Напр. вот так

```
curl -v \
  -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  http://localhost:8081/feedbacks/1
```

```json
{
  "type":"feedback",
  "command": "create",
  "payload": {
    "dreamer_id":4,
    "entity_id":2,
    "entity_type": "dream",
    "initiator_id": 1
  }
}
```

## Pusher

`curl -X POST -d hello http://localhost:8081/pusher/4`

### Пуш `push`

```json
{
  "type": "pusher",
  "command": "push",
  "payload": "hello"
}
```
