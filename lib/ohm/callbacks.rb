module Ohm
  # This plugin originally handled both instance level and
  # class level callbacks.
  #
  # Starting with Ohm 1.0, instance level callbacks are part of
  # the core, this plugin only adds macro level callbacks.
  #
  # The following is an example usage of this plugin:
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

  protected
    def before_save
      super
      execute_callback(:before, :save)
    end

    def after_save
      super
      execute_callback(:after, :save)
    end

    def before_create
      super
      execute_callback(:before, :create)
    end

    def after_create
      super
      execute_callback(:after, :create)
    end

    def before_update
      super
      execute_callback(:before, :update)
    end

    def after_update
      super
      execute_callback(:after, :update)
    end

    def before_delete
      super
      execute_callback(:before, :delete)
    end

    def after_delete
      super
      execute_callback(:after, :delete)
    end

  private
    def execute_callback(position, method)
      self.class.callbacks[position][method].each do |callback|
        __send__(callback)
      end
    end
  end
end