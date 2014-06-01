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
