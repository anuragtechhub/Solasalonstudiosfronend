web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e $RAILS_ENV --config config/sidekiq.yml
release: bundle exec rake db:migrate
clockwork: bundle exec clockwork clock.rb
