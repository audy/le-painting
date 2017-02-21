# Le Painting

Source code for [painting.austinfanclub.com](http://painting.austinfanclub.com)

## Requirements

- Postgres 9.X
- Ruby 2.1.2
- Various gems (installed with Bundler)

```bash
# install requirements
bundle install

# specify database URL with an environment variable
# (run once per session)
export DATABASE_URL=postgres://$USER@127.0.0.1

# migrate the database
bundle exec rake db:migrate

# start app
bundle exec rackup

# run tests
bundle exec rspec
```

App will auto-refresh in development mode

## Deployment

This project uses docker-compose:

```bash
docker-compose up -d --build
```

### First Time

The first time you deploy, you need to run a few extra commands to create the
database and run the migrations:

```bash
# start the database container
docker-compose up db

# create the database
docker-compose run --entrypoint createdb db --host db --user postgres lepainting

# migrate the database

docker-compose run --entrypoint rake web db:migrate
```

Then `CTRL-C` the db and use the usual deployment command.

## License

MIT (see `license.md`)
