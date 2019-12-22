# Notice: This project is over

[**Matsue Ruby Kaigi 08 is out!**](https://magazine.rubyist.net/articles/0056/0056-MatsueRubyKaigi08Report.html) :tada:

**This repository is unmaintained and read only.**

# Maze solver collector

## Requirements

We tested on:

* Ruby 2.3.3
* Docker 1.12.3

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
$ bin/rails maze:import MAZE_PATH="data/**/01.maze"
```

Run test.

```sh
$ bin/rake
```

## Enjoy

Run solver runner.

```sh
$ bin/delayed_job start
```

Run web server.

```sh
$ bin/rails s
```

Open http://localhost:3000/solvers on your web browser and enjoy it!
