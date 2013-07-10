module MailControl
  
  class MailControlError < StandardError
  end
  
  class InvalidLoggedEmail < MailControlError
  end
  
  # This error is raised when an act_object isn't defined
  # as an actor, act_object or act_target
  #
  # Example:
  #
  # <tt>InvalidField.new('field_name')</tt>
  class InvalidData < MailControlError
    attr_reader :message

    def initialize message
      @message = "Invalid Data: #{message}"
    end

  end
  
  # This error is raised when trying to store a field that doesn't exist
  #
  # Example:
  #
  # <tt>InvalidField.new('field_name')</tt>
  class InvalidField < MailControlError
    attr_reader :message

    def initialize message
      @message = "Invalid Field: #{message}"
    end

  end
  
  class LoggedEmailNotSaved < MailControlError
  end
  
  class NoFollowersDefined < MailControlError
  end
  
end