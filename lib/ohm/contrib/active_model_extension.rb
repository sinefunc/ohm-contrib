# encoding: UTF-8

require "active_model"

# Extension for ActiveModel compatibility
#
# @example
#
#   class Post < Ohm::Model
#     include Ohm::ActiveModelExtension
#   end
module Ohm
  module ActiveModelExtension
    def to_model
      ActiveModelInterface.new(self)
    end
  end

  class ActiveModelInterface
    def initialize(model)
      @model = model
    end

    extend ActiveModel::Naming

    def to_model
      self
    end

    def valid?
      @model.valid?
    end

    def new_record?
      @model.new?
    end

    def destroyed?
      false
    end

    def to_key
      [@model.id] if persisted?
    end

    def persisted?
      ! new_record?
    end

    def to_param
      if persisted?
        @model.respond_to?(:to_param) ?
          @model.to_param :
          @model.id
      end
    end

    def errors
      Errors.new(@model.errors)
    end

    class Errors
      def initialize(errors)
        @errors = Hash.new { |hash, key| hash[key] = [] }

        errors.each do |key, value|
          @errors[key] << value
        end
      end

      def [](key)
        @errors[key]
      end

      def full_messages
        @errors.map do |key, value|
          "#{key}: #{value.join(", ")}"
        end
      end
    end
  end
end
