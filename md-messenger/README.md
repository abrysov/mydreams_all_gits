messenger
=====

An OTP application

Build
-----

    $ rebar3 compile

## Как запустить

### Requirements

* erlang

* postgres

* nodejs

### Засетапить мнимальную базу

`make db-setup`

### Собрать фронтенд

`make frontend`

Или в рукопашную

`cd frontend`

`npm install -g webpack`

`npm install`

`webpack`


### Запустить приложеньку в dev-режиме

`make run`

Заходим на порт на http://localhost:8080

## Описание протокола

Клиент -> Сервер

```json
{
  "type": <type>,
  "command": <command>,
  "param1": "value1",
  "param2": "value2",
  ...
}
```

Сервер -> Клиент

```json
{
  "type": <type>,
  "command": <command>,
  "payload": <payload>,
}
```

`type`: `im` | `comments`

### IM (Instant messages)

`command`: `list` | `send` | `online_list` | `mark_read`

#### Параметры

`conversation_id`

### Comments

`command`: `list` | `subscribe` | `post`

#### Параметры

`resource_type`
`resource_id`
