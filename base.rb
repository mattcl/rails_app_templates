# base.rb rails applicaiton template

# cleanup
run "rm public/index.html"
run "rm README.rdoc"
run "touch README.md"
run "echo TODO > README.md"

# setup gems
gem 'devise'
gem 'activeadmin'

# assets
gem 'zurb-foundation', :group => [:assets]

# testing
gem_group :development, :test do
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false
  gem 'jasminerice'

  gem 'rb-inotify', :require => false
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-jasmine'
  gem 'guard-livereload'
end

# git
run "echo database.yml > config/.gitignore"
git :init

run 'bundle install'
generate 'rspec:install'
generate 'jasminerice:install'
generate 'cucumber:install'
run 'guard init rspec'
run 'guard init cucumber'
run 'guard init jasmine'
run 'guard init livereload'
