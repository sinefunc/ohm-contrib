module Ohm
  # Minimalistic callback support for Ohm::Model.
  #
  # You can implement callbacks by overriding any of the following
  # methods:
  #
  #    - before_create
  #    - after_create
  #    - before_save
  #    - after_save
  #    - before_update
  #    - after_update
  #    - before_delete
  #    - after_delete
  #
  # If you prefer to do a class level declaration that is also possible.
  #
  # @example
  #
  #   class Post < Ohm::Model
  #     include Ohm::Callbacks
  #
  #     before :create, :timestamp!
  #     before :save,   :recalc_votes
  #
  #     after  :create, :post_to_twitter!
  #     after  :save,   :sync_ids
  #
  #   protected
  #     def clean_decimals
  #       # sanitize the decimal values here
  #     end
  #
  #     def timestamp!
  #       # do timestamping code here
  #     end
  #
  #     def recalc_votes
  #       # do something here
  #     end
  #
  #     def post_to_twitter!
  #       # do twitter posting here
  #     end
  #
  #     def sync_ids
  #       # do something with the ids
  #     end
  #   end

  module Callbacks
    def self.included(model)
      model.extend ClassMethods
    end

    module ClassMethods
      # Use to add a before callback on `method`. Only symbols
      # are allowed, no string eval, no block option also.
      #
      # @example
      #
      #   class Post < Ohm::Model
      #     include Ohm::Callbacks
      #
      #     before :create, :timestamp!
      #     before :save,   :recalc_votes
      #
      #   protected
      #     def timestamp!
      #       # do timestamping code here
      #     end
      #
      #     def recalc_votes
      #       # do something here
      #     end
      #   end
      #
      # @param [Symbol] method the method type, e.g. `:create`, or `:save`
      # @param [Symbol] callback the name of the method to execute
      # @return [Array] the callback in an array if added e.g. [:timestamp]
      # @return [nil] if the callback already exists
      def before(method, callback)
        unless callbacks[:before][method].include?(callback)
          callbacks[:before][method] << callback
        end
      end

      # Use to add an after callback on `method`. Only symbols
      # are allowed, no string eval, no block option also.
      #
      # @example
      #
      #   class Post < Ohm::Model
      #     include Ohm::Callbacks
      #
      #     after  :create, :post_to_twitter!
      #     after  :save,   :sync_ids
      #
      #   protected
      #     def post_to_twitter!
      #       # do twitter posting here
      #     end
      #
      #     def sync_ids
      #       # do something with the ids
      #     end
      #   end
      #
      # @param [Symbol] method the method type, `:validate`, `:create`, or `:save`
      # @param [Symbol] callback the name of the method to execute
      # @return [Array] the callback in an array if added e.g. [:timestamp]
      # @return [nil] if the callback already exists
      def after(method, callback)
        unless callbacks[:after][method].include?(callback)
          callbacks[:after][method] << callback
        end
      end

      # @private internally used to maintain the state of callbacks
      def callbacks
        @callbacks ||= Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = [] }}
      end
    end

    # The overriden create of Ohm::Model. It checks if the
    # model is valid, and executes all before :create callbacks.
    #
    # If the create succeeds, all after :create callbacks are
    # executed.
    def write
      creating = @creating

      execute_callback(:before, :create) if creating
      execute_callback(:before, :update) unless creating
      execute_callback(:before, :save)

      super

      execute_callback(:after, :create) if creating
      execute_callback(:after, :update) unless creating
      execute_callback(:after, :save)
    end

    def create
      @creating = true
      super.tap { @creating = false }
    end

    def delete
      execute_callback(:before, :delete)
      super
      execute_callback(:after, :delete)
    end

  protected
    def before_validate() end
    def after_validate()  end
    def before_save()     end
    def after_save()      end
    def before_create()   end
    def after_create()    end
    def before_update()   end
    def after_update()    end
    def before_delete()   end
    def after_delete()    end

  private
    def execute_callback(position, method)
      self.class.callbacks[position][method].each do |callback|
        __send__(callback)
      end

      __send__("#{ position }_#{ method }")
    end
  end
end