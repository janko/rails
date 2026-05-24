# frozen_string_literal: true

module Arel # :nodoc: all
  module Nodes
    # An unbound column reference, created via Arel.[]:
    #
    #   Arel[:name]            # => Arel::Nodes::Identifier (name: "name")
    #   Arel[:name].eq("DHH")  # => Arel::Nodes::Equality
    #
    # An Identifier is a tableless column reference; it renders without a table
    # qualifier. To qualify it, call #qualify or #[]:
    #
    #   Arel[:name].qualify(:users)  # "users"."name"
    #   Arel[:users][:name]          # "users"."name"
    class Identifier < Arel::Nodes::Node
      include Arel::Expressions
      include Arel::Predications
      include Arel::AliasPredication
      include Arel::OrderPredications
      include Arel::Math
      include Arel::QualifyingMethods

      attr_reader :name

      def initialize(name)
        super()
        @name = name.is_a?(Symbol) ? name.name : name
      end

      # Identifiers carry no type information, so values combined with them
      # are not type-cast (see Arel::Nodes.build_quoted).
      def able_to_type_cast?
        false
      end

      # Value equality, so identical Identifier-based predicates dedup through
      # ActiveRecord::Relation::WhereClause set operations (merge, or, except).
      def hash
        [self.class, name].hash
      end

      def eql?(other)
        self.class == other.class && name == other.name
      end
      alias :== :eql?
    end
  end
end
