[![Code Climate](https://codeclimate.com/repos/5591c6ee69568076af002014/badges/6f1f1b0dec355623de4c/gpa.svg)](https://codeclimate.com/repos/5591c6ee69568076af002014/feed)
[![Vexor status](https://ci.vexor.io/projects/3f7c560d-89ab-4d5c-8b5a-b7d802fac211/status.svg)](https://ci.vexor.io/ui/projects/3f7c560d-89ab-4d5c-8b5a-b7d802fac211/builds)

## How to run project in Docker Compose

First, install Docker and Docker Compose.

Create `docker-compose.yml` if it doesn't exist:
```
cp docker-compose.example.yml docker-compose.yml
```

Then add those lines to `default` section of `config/database.yml` (copy it from `config/database.yml.example` if not exists):
```
default: &default
  adapter: postgresql
  host: db
  username: postgres
```

Install Node.js modules, create `tmp/pids` directory:
```
npm install
mkdir -p ./tmp/pids
```

Set up docker container:
```
sudo docker-compose up -d
sudo docker-compose run web rake db:setup
```

Finally, execute that to run container's bash:
```
docker exec -it mydreams_web_1 bash
```

Run the application inside the container's bash:
```
foreman start
```

To access app console, run this inside the container's bash:
```
rails c
```

In app console, to create a user (with admin privileges):
```
d = Dreamer.first; d.password = 'пароль_для_пользователя'; d.password_confirmation = 'пароль_для_пользователя'; d.role = :admin; d.save;
d.update_column(:email, 'твой_email');
d.reload;
```

## how to run rails console(and other script)

```
docker-compose run web rails c
```

## for mac
[docker+xhyve](https://gist.github.com/zzet/f3f9cc44f9b87602695c)

# Use docker on mac os x

Create machine
``` bash
docker-machine create -d xhyve --xhyve-cpu-count "2" --xhyve-disk-size "20000" --xhyve-memory-size "2048" --xhyve-experimental-nfs-share mydreams
```

Export machine env variables
``` bash
eval $(docker-machine env mydreams)
```

Build and run machine
``` bash
docker-compose build && docker-compose up -d
```

Login into vm
``` bash
docker exec -it mydreams_web_1 bash
```
