# base.rb rails applicaiton template

# cleanup
run "rm public/index.html"
run "echo TODO > README"

# setup gems
gem 'devise'
gem 'activeadmin'


# git
run "echo database.yml > config/.gitignore"
git :init
git :add => "."

