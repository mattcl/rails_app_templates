# base.rb rails applicaiton template

use_devise = yes? 'use devise and generate default user?'

# cleanup
run "rm public/index.html"
run "rm README.rdoc"
run "touch README.md"
run "echo TODO > README.md"

# setup gems
gem 'devise' if use_devise
gem 'activeadmin' if use_devise
gem 'high_voltage'
gem 'redcarpet'
gem 'simple_form'

# assets
gem 'zurb-foundation', :group => [:assets]

# testing
gem_group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'jasminerice'
  gem 'rb-inotify', :require => false
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-jasmine'
  gem 'guard-livereload'
  gem 'zeus'
end



run 'bundle install'

# test setup
generate 'rspec:install'
generate 'jasminerice:install'
generate 'cucumber:install'

file '.rspec', <<-RSPEC, :force => true
--color
--format documentation
RSPEC

# foundation
generate 'foundation:install'
inside('app/views') do
  run 'rm layouts/application.html.erb'
  file 'layouts/application.html.erb', <<-VIEW
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" contains="width-device-width, initial-scale=1.0" />
    <title>#{@app_name.titleize}</title>
    <%= stylesheet_link_tag    "application", :media => "all" %>
    <%= javascript_include_tag "application" %>
    <%= javascript_include_tag "vendor/custom.modernizr" %>
    <%= csrf_meta_tags %>
  </head>
  <body>
    <%= render 'layouts/site_nav' %>
    <%= yield %>
  </body>
</html>
VIEW

  file 'layouts/_site_nav.html.erb', <<-NAV
<nav class="top-bar">
  <ul class="title-area">
    <li class="name">
      <h1><%= link_to('#{@app_name.titleize}', root_path) %></h1>
    </li>
    <li class="toggle-topbar menu-icon"><a href="#"><span>Menu</span></a></li>
  </ul>

  <section class="top-bar-section">
    <ul class="left">
      <li><%= link_to('some link', '#') %></li>
    </ul>
    <ul class="right">
      <%= render 'devise/menu/login_items' %>
    </ul>
  </section>
</nav>
NAV
end

# devise
if use_devise
  generate 'model User username:string'
  generate 'devise:install'
  generate 'devise User'
  generate 'devise:views'
  run 'mkdir app/views/devise/menu'
  file 'app/views/devise/menu/_login_items.html.erb', <<-AUTHSTATUS
<li class="divider"></li>
<% if user_signed_in? %>
  <li><%= link_to("Logged in as \#{current_user.username}", edit_user_registration_path) %></li>
  <li class="divider"></li>
  <li></span><%= link_to('Logout', destroy_user_session_path, :method => :delete) %></li>
<% else %>
  <li><%= link_to('Login', new_user_session_path) %>
  <li class="divider"></li>
  <li><%= link_to('Register', new_user_registration_path) %></li>
<% end %>
AUTHSTATUS

  file 'app/views/devise/sessions/new.html.erb', <<-LOGIN, :force => true
<div class="row">
  <div class="large-4 large-centered column">
    <h2>Sign in</h2>

    <%= simple_form_for(resource, :as => resource_name, :url => session_path(resource_name)) do |f| %>
      <div class="form-inputs">
        <%= f.input :email, :required => false, :autofocus => true %>
        <%= f.input :password, :required => false %>
        <%= f.input :remember_me, :as => :boolean if devise_mapping.rememberable? %>
      </div>

      <div class="form-actions">
        <%= f.button :submit, "Sign in" %>
      </div>
    <% end %>

    <%= render "devise/shared/links" %>
  </div>
</div>
LOGIN

  file 'app/views/devise/registrations/new.html.erb', <<-REGISTRATION, :force => true
<div class="row">
  <div class="large-4 large-centered column">
    <h2>Sign up</h2>

    <%= simple_form_for(resource, :as => resource_name, :url => registration_path(resource_name)) do |f| %>
      <%= f.error_notification %>

      <div class="form-inputs">
        <%= f.input :username, :required => true, :autofocus => true %>
        <%= f.input :email, :required => true %>
        <%= f.input :password, :required => true %>
        <%= f.input :password_confirmation, :required => true %>
      </div>

      <div class="form-actions">
        <%= f.button :submit, "Sign up" %>
      </div>
    <% end %>

    <%= render "devise/shared/links" %>
  </div>
</div>
REGISTRATION

  file 'app/views/devise/registrations/edit.html.erb', <<-EDITREGISTRATION, :force => true
<div class="row">
  <div class="large-4 large-centered column">
    <h2>Edit <%= resource_name.to_s.humanize %></h2>

    <%= simple_form_for(resource, :as => resource_name, :url => registration_path(resource_name), :html => { :method => :put }) do |f| %>
      <%= f.error_notification %>

      <div class="form-inputs">
        <%= f.input :email, :required => true %>

        <% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
          <p>Currently waiting confirmation for: <%= resource.unconfirmed_email %></p>
        <% end %>

        <%= f.input :password, :autocomplete => "off", :hint => "leave it blank if you don't want to change it", :required => false %>
        <%= f.input :password_confirmation, :required => false %>
        <%= f.input :current_password, :hint => "we need your current password to confirm your changes", :required => true %>
      </div>

      <div class="form-actions">
        <%= f.button :submit, "Update" %>
      </div>
    <% end %>

    <h3>Cancel my account</h3>

    <p>Unhappy? <%= link_to "Cancel my account", registration_path(resource_name), :data => { :confirm => "Are you sure?" }, :method => :delete %>.</p>

    <%= link_to "Back", :back %>
  </div>
</div>
EDITREGISTRATION
end

# Git Ignore
file '.gitignore', <<-GITIGNORE, :force => true
.bundle
.DS_Store
.sass-cache/*
*.swp
*.swo
**/.DS_STORE
bin/*
bundler_stubs/*
config/database.yml
db/*.sqlite3
log/*.log
log/*.pid
public/system/*
public/stylesheets/compiled/*
public/assets/*
tmp/*
GITIGNORE

# git
git :init
git :add => '.'
git :commit => "-a -m 'initial commit'"

