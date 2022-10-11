# Description

- An API to register and search profiles and then getting some data(scraping) from github

## Dependencies

- Ruby > 2.7
- Rails >= 6
- Docker
- Postgresql(via DOCKER)

# Features

1. Register user
   1. Providing name and a github profile
   2. After a few moments will scrap data from his github profile and fill his corresponding row
2. Search for registered users(list)
   1. Pagination
   2. Filter by name(looking between `name`, `githubProfile`, `organization`, `localization`)
3. Edit profile 5. Request the rescan(1.2)
4. Delete profile

# Missing things/features(backlog)

- Use something like `sidekiq` or `aws sqs` to queue scan requests and prevent bottleneck from thousands of requests
- Separation of microservices
  1.  Scrapping
  2.  Queue/background microservice
- More automated tests and coverage(currently non-existent)
- Better use of services to provide better readability
- Improvements on clean code
- Better use of filters(maybe using scopes on a better way)
- If page provided is not a profile should delete(or not even create) and provide some error
- Improve scrapping technique
  - Use more appropriate tags to find the items
- Use some URL shortener to the github page

# Run tests

1. `bundle install`
2. `rspec`

# Run locally

If desired to not use docker and use another, please edit on `config/database.yml:21`

1. `docker-compose up -d` (database)
2. `bundle install`
3. `rake db:setup`
4. `rails s`

## Attention

- `config/master.key` must be created (`EDITOR=vim rails credentials:edit`)
- `.env` must be created, in case of doubt just clone the current `.env.example`
