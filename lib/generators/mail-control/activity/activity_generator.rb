require 'generators/mail-control'
require 'rails/generators/active_record'

module MailControl
  module Generators
    # LoggedEmail generator that creates queued_task model file from template
    class LoggedEmailGenerator < ActiveRecord::Generators::Base
      extend Base

      argument :name, :type => :string, :default => 'logged_email'
      # Create model in project's folder
      def generate_files
        copy_file 'logged_email.rb', "app/models/#{name}.rb"
      end
    end
  end
end
