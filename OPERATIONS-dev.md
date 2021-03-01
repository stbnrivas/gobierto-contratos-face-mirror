# Operations


```bash
cd gobierto-contratos-face-mirror

# set environment
cp .env.example .env

# run infra requirements
docker-compose up

# prepare db
bin/rails db:create
bin/rails db:migrate

bin/rails db:migrate RAILS_ENV=test

# run tests
bin/rails test

# import fiscal_entities.csv
bin/rails csv:load

# scrape face api for new entities passing level as params
bin/rails face:import_level[1]

# scrape face api for new entities for **ALL LEVELS**
bin/rails face:import_level
```


using the docker compose approach you get the sidekiq-ui at [localhost:9292](localhost:9292) to check background job status, cancel


```
# from now worker is off, to run
bundle exec sidekiq

# I preferred don't start the worker by default into docker compose from now
```
