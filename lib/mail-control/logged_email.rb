module MailControl
  module LoggedEmail
    extend ActiveSupport::Concern

    included do

      store :options

      belongs_to :actor,      :polymorphic => true
      belongs_to :act_object, :polymorphic => true
      belongs_to :act_target, :polymorphic => true

      validates_presence_of :actor_id, :actor_type, :verb
    end

    module ClassMethods

      def poll_for_changes()
        #if block_given?

        ::LoggedEmail.where('state = ? AND send_after <= ?', 'initial', Time.now).select(:act_target_id).uniq.each do |cur_target|
          target_id =  cur_target['act_target_id']

          ::LoggedEmail.where('state = ? AND act_target_id = ? AND send_after <= ?', 'initial', target_id, Time.now).select(:verb).uniq.each do |verb|

            changes_for_target =  ::LoggedEmail.where(:act_target_id => target_id, :state => 'initial', :verb => verb['verb'].to_s)

            yield  verb, changes_for_target

            changes_for_target.each do |cft|
              cft.update_attributes(:state => 'complete')
            end



          end


        end
      end


      # Defines a new LoggedEmail2 type and registers a definition
      #
      # @param [ String ] name The name of the queued_task
      #
      # @example Define a new queued_task
      #   queued_task(:enquiry) do
      #     actor :user, :cache => [:full_name]
      #     act_object :enquiry, :cache => [:subject]
      #     act_target :listing, :cache => [:title]
      #   end
      #
      # @return [Definition] Returns the registered definition
      def queued_task(name, &block)
        definition = MailControl::DefinitionDSL.new(name)
        definition.instance_eval(&block)
        MailControl::Definition.register(definition)
      end

      # Publishes an queued_task using an queued_task name and data
      #
      # @param [ String ] verb The verb of the queued_task
      # @param [ Hash ] data The data to initialize the queued_task with.
      #
      # @return [MailControl::LoggedEmail2] An LoggedEmail instance with data
      def send_email(verb, data)
        new.send_email({:verb => verb}.merge(data))
      end

    end



    # Publishes the queued_task to the receivers
    #
    # @param [ Hash ] options The options to send_email with.
    #
    def send_email(data = {})
      assign_properties(data)

      self
    end


    def refresh_data
      save(:validate => false)
    end

    protected

    def assign_properties(data = {})

      self.verb      = data.delete(:verb)


      write_attribute(:send_after, data[:send_after])
      data.delete(:send_after)

      write_attribute(:send_before, data[:send_before])
      data.delete(:send_before)

      self.state = 'initial'

      [:actor, :act_object, :act_target].each do |type|

        cur_object = data[type]

        unless cur_object
          if definition.send(type.to_sym)
            raise verb.to_json
            #raise MailControl::InvalidData.new(type)
          else
            next

          end
        end

        class_sym = cur_object.class.name.to_sym

        raise MailControl::InvalidData.new(class_sym) unless definition.send(type) == class_sym

        case type
          when :actor
            self.actor = cur_object
          when :act_object
            self.act_object = cur_object
          when :act_target
            self.act_target = cur_object
          else
            raise "unknown type"
        end

        data.delete(type)

      end

      [:grouped_actor].each do |group|


        grp_object = data[group]

        if grp_object == nil
          if definition.send(group.to_sym)
            raise verb.to_json
            #raise MailControl::InvalidData.new(group)
          else
            next

          end
        end

        grp_object.each do |cur_obj|
          raise MailControl::InvalidData.new(class_sym) unless definition.send(group) == cur_obj.class.name.to_sym

          self.grouped_actors << cur_obj

        end

        data.delete(group)

      end

      cur_bond_type = definition.send(:bond_type)

      if cur_bond_type
        write_attribute( :bond_type, cur_bond_type.to_s )
      end

      if definition.send(:unsubscribe_by)
        write_attribute(:unsubscribe_by, definition.send(:unsubscribe_by))
      else
        raise "definition must define unsubscribe_by option"
      end

      if self.act_target.is_unsubscribed_to?(self)
        self.state = 'unsubscribed'
      end

      def_options = definition.send(:options)
      def_options.each do |cur_option|
        cur_object = data[cur_option]

        if cur_object

          if cur_option == :description
            self.description = cur_object
          else
            options[cur_option] = cur_object
          end
          data.delete(cur_option)

        else
          #all options defined must be used
          raise Streama::InvalidData.new(cur_object[0])
        end
      end

      if data.size > 0
        raise "unexpected arguments: " + data.to_json
      end



      self.save


    end

    def definition
      @definition ||= MailControl::Definition.find(verb)
    end


  end
end
