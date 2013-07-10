module MailControl
  
  module Actor
    extend ActiveSupport::Concern

    included do
      cattr_accessor :mailing_klass

      has_many :logged_emails,             :class_name => "LoggedEmail", :as => :actor
      has_many :act_object_logged_emails,  :class_name => "LoggedEmail", :as => :act_object
      has_many :act_target_logged_emails,  :class_name => "LoggedEmail", :as => :act_target


    end

    module ClassMethods

      def mail_control_class(klass)
        self.mailing_klass = klass.to_s
      end

    end


    # Publishes the mailing to the receivers
    #
    # @param [ Hash ] options The options to publish with.
    #
    # @example publish an mailing with a act_object and act_target
    #   current_user.send_email(:enquiry, :act_object => @enquiry, :act_target => @listing)
    #
    def send_email(name, options={})
      options[:send_after]  = Time.now + options[:send_after]  if options[:send_after].kind_of?(Fixnum)
      options[:send_before] = Time.now + options[:send_before] if options[:send_before].kind_of?(Fixnum)

      raise "Expected Time type. Got:" + options[:send_after].class.name   unless options[:send_after].kind_of?(Time)
      raise "Expected Time type. Got:" + options[:send_before].class.name  unless options[:send_before].kind_of?(Time)

      mail_control_class.send_email(name, {:actor => self}.merge(options))
    end

    def mail_control_class
      @mailing_klass ||= mailing_klass ? mailing_klass.classify.constantize : ::LoggedEmail
    end

    def actor_logged_emails(options = {})

      if options.empty?
        logged_emails
      else
        logged_emails.where(options)
      end

    end

  end
  
end