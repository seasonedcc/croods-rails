# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../todos/config/environment', __dir__)
# Prevent database truncation if the environment is production
if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end
require 'rspec/rails'
require 'timecop'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')]
#   .sort.each { |f| require f }
Dir[Rails.root.join('..', 'spec', 'support', '**', '*.rb')]
  .sort.each { |f| require f }

Devise.stretches = 1
Rails.logger.level = 4

# 1. Reduce Devise.stretches
# Explanation: Devise uses bcrypt-ruby by default to encrypt your password. Bcrypt is one of the best choices for such job because, different from other hash libraries like MD5, SHA1, SHA2, it was designed to be slow. So if someone steals your database it will take a long time for them to crack each password in it.
# That said, it is expected that Devise will also be slow during tests as many tests are generating and comparing passwords. For this reason, a very easy way to improve your test suite performance is to reduce the value in Devise.stretches, which represents the cost taken while generating a password with bcrypt. This will make your passwords less secure, but that is ok as long as it applies only to the test environment.
# Latest Devise versions already set stretches to one on test environments in your initializer, but if you have an older application, this will yield a nice improvement!

# 2. Increase your log level
# Explanation: Rails by default logs everything that is happening in your test environment to “log/test.log”. By increasing the logger level, you will be able to reduce the IO during your tests. The only downside of this approach is that, if a test is failing, you won’t have anything logged. In such cases, just comment the configuration option above and run your tests again.
# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
