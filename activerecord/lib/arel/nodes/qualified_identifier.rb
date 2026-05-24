# frozen_string_literal: true

module Arel # :nodoc: all
  module Nodes
    # A qualified column reference, e.g. <tt>"users"."name"</tt>.
    #
    #   Arel.qualify(:users, :name)    # => Arel::Nodes::QualifiedIdentifier
    #   Arel[:users][:name]            # => same as above
    #
    # Either part may itself be a QualifiedIdentifier for nested qualification:
    #
    #   Arel[:schema][:users][:name]   # "schema"."users"."name"
    #
    # This node is intentionally decoupled from Arel::Table and
    # Arel::Attributes::Attribute: it accepts plain Symbols and Strings, so
    # callers don't need (or don't want) a relation object.
    class QualifiedIdentifier < Arel::Nodes::Node
      include Arel::Expressions
      include Arel::Predications
      include Arel::AliasPredication
      include Arel::OrderPredications
      include Arel::Math
      include Arel::QualifyingMethods

      attr_reader :qualifier, :column

      def initialize(qualifier, column)
        super()
        @qualifier = coerce(qualifier)
        @column    = coerce(column)
      end

      # Like Identifier, carries no type information.
      def able_to_type_cast?
        false
      end

      def hash
        [self.class, qualifier, column].hash
      end

      def eql?(other)
        self.class == other.class &&
          qualifier == other.qualifier &&
          column    == other.column
      end
      alias :== :eql?

      private
        def coerce(value)
          case value
          when Symbol     then value.name
          when Identifier then value.name
          else value
          end
        end
    end
  end
end
