 == README

* Ruby version: 2.2.8

* Rails version: 4.1.16

* System dependencies
  - gem install bundler -v 1.17.3
  - bundle \_1.17_ install
  - if you're a developer please use rubocop:
    gem install parallel -v "1.3.3.1"
    gem install rubocop -v "0.75.0"

* Configuration:
  - create .env.development; ask you teammate to provide necessary data (DATABASE_URL)
  - create .env.test from .env.development and change necessary data (DATABASE_URL)

* Database creation:
  - bundle exec rake db:create

* Database initialization:
  - Do not try to run schema migrations. Create fresh DB dump from heroku production and restore it.
   heroku pg:backups:capture --app solasalonstudios
   heroku pg:backups:download --app solasalonstudios
   pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb latest.dump

* Database initialization
  - bundle exec rake init:clean_address_emails

* Deployment instructions
  - staging:
    remote url: https://git.heroku.com/solasalonstudios-test.git
  
  - production:
    remote url: https://git.heroku.com/solasalonstudios.git
    
  - production br:
    remote url: https://git.heroku.com/solasalonstudios-br.git
    
  - example:
    1. git remote add heroku-production-br https://git.heroku.com/solasalonstudios-br.git
    2. heroku git:remote -a solasalonstudios-br -r heroku-production-br
    3. git push heroku-production-br YOUR_BRANCH_NAME:master (able to deploy only to master!)
