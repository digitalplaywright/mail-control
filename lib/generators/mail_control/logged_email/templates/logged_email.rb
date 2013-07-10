# LoggedEmail model for customisation & custom methods
class LoggedEmail < ActiveRecord::Base
  include MailControl::LoggedEmail

end
