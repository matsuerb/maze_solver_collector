# Maze solver collector

## Requirements

We tested on:

* Ruby 2.3.1
* Docker 1.12.1

## Setup

Setup Docker Image to run posted solvers.

```sh
$ docker build -t solver_runner solver_runner/
```

Setup server.

```sh
$ bundle
$ cp -avi config/database.yml{.example,}
$ editor config/database.yml
<set your database settings.>
$ bin/rails db:create:all
$ bin/rails db:migrate
$ bin/rails maze:import
```

Run test.

```sh
$ bin/rake
```

## Enjoy

Run server.

```sh
$ bin/rails s
```

Open http://localhost:3000/solvers on your web browser and enjoy it!
