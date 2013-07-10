require "rubygems"
require "bundler"
Bundler.setup(:default, :test)

$:.unshift File.expand_path('../../lib/', __FILE__)
require 'active_support/testing/setup_and_teardown'
require 'mail-control'
require 'minitest/autorun'

#LiveStream.config # touch config to load ORM, needed in some separate tests

require 'active_record'
require 'active_record/connection_adapters/sqlite3_adapter'


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
end

class LoggedEmail < ActiveRecord::Base
  include MailControl::LoggedEmail

  queued_task :new_enquiry do
    actor        :User
    act_object   :Article
    act_target   :User
    #option       :description
    unsubscribe_by :option_1
  end

  queued_task :test_description do
    actor        :User
    act_object   :Article
    act_target   :User
    option       :description
    unsubscribe_by :option_1
  end

  queued_task :test_option do
    actor        :User
    act_object   :Article
    act_target   :User
    option       :country
    unsubscribe_by :option_1
  end

  queued_task :test_bond_type do
    actor        :User
    act_object   :Article
    act_target   :User
    bond_type    :global
    unsubscribe_by :option_1
  end

end

class User < ActiveRecord::Base
  include MailControl::Actor

  def is_unsubscribed_to?(_logged_email)
    _logged_email.unsubscribe_by == 'i_am_unsubscribed'
  end

end

class Article < ActiveRecord::Base

end

class Volume < ActiveRecord::Base

end

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Migrator.migrate(File.expand_path('../migrations', __FILE__))
