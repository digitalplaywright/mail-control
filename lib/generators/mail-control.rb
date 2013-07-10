require 'rails/generators/named_base'

module MailControl
  # A generator module with LoggedEmail table schema.
  module Generators
    # A base module 
    module Base
      # Get path for migration template
      def source_root
        @_mail_control_source_root ||= File.expand_path(File.join('../mail-control', generator_name, 'templates'), __FILE__)
      end
    end
  end
end
