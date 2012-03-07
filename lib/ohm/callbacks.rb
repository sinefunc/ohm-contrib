module Ohm
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

    module Scripted
      def save!
        new = new?

        _execute_before_callbacks(new)
        result = super
        _execute_after_callbacks(new)

        return result
      end

      def delete
        before_delete
        result = super
        after_delete

        return result
      end
    end

    module PureRuby
      def save
        new = new?

        super do |t|
          t.before do
            _execute_before_callbacks(new)
          end

          t.after do
            _execute_after_callbacks(new)
          end

          yield t if block_given?
        end
      end

      def delete
        super do |t|
          t.before do
            before_delete
          end

          t.after do
            after_delete
          end

          yield t if block_given?
        end
      end
    end

    if defined?(Ohm::Model::Scripted)
      include Scripted
    else
      include PureRuby
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
      _execute_callback(:before, :save)
    end

    def after_save
      _execute_callback(:after, :save)
    end

    def before_create
      _execute_callback(:before, :create)
    end

    def after_create
      _execute_callback(:after, :create)
    end

    def before_update
      _execute_callback(:before, :update)
    end

    def after_update
      _execute_callback(:after, :update)
    end

    def before_delete
      _execute_callback(:before, :delete)
    end

    def after_delete
      _execute_callback(:after, :delete)
    end

  private
    def _execute_before_callbacks(new)
      before_create if new
      before_update if not new
      before_save
    end

    def _execute_after_callbacks(new)
      after_create if new
      after_update if not new
      after_save
    end

    def _execute_callback(position, method)
      self.class.callbacks[position][method].each do |callback|
        __send__(callback)
      end
    end
  end
end
