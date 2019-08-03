# Basic SocialNetwork

# Install gems
- docker-compose run --rm website bundle install

# DB
- docker-compose run --rm website bundle exec rake db:create
- docker-compose run --rm website bundle exec rake db:migrate

# Run project
- docker-compose up --build -d