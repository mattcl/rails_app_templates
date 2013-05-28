class AppBuilder < Rails::AppBuilder
  def readme
    create_file 'README.md', 'TODO'
  end

  def test
    @generator.gem_group :development, :test do
      @generator.gem 'rspec-rails'
      @generator.gem 'cucumber-rails'
      @generator.gem 'jasminerice'

      @generator.gem 'rb-inotify', :require => false
      @generator.gem 'guard'
      @generator.gem 'guard-rspec'
      @generator.gem 'guard-cucumber'
      @generator.gem 'guard-jasmine'
      @generator.gem 'guard-livereload'
    end

    run 'bundle install'

    generate 'rspec:install'
    generate 'cucumber:install'
    run 'guard init rspec'
    run 'guard init cucumber'
    run 'guard init jasmin'
    run 'guard init livereload'
  end
end
