# frozen_string_literal: true

module Arel
  # Methods for qualifying an identifier with a table (or schema with a table)
  # by producing an Arel::Nodes::QualifiedIdentifier:
  #
  #   Arel[:column].qualify(:table)         # "table"."column"
  #   Arel[:table][:column]                 # "table"."column"
  #   Arel[:schema][:table][:column]        # "schema"."table"."column"
  #   Arel.qualify(:table, :column)         # "table"."column"
  module QualifyingMethods
    # Qualify the receiver with +qualifier+ (a table for a column, or a schema
    # for a table).
    def qualify(qualifier)
      Arel.qualify(qualifier, self)
    end

    # Treat the receiver as a qualifier and produce a deeper QualifiedIdentifier:
    #
    #   Arel[:users][:name]  # => "users"."name"
    def [](column)
      Arel.qualify(self, column)
    end

    # With no arguments, returns the receiver qualifying all columns:
    #
    #   Arel[:users].*           # "users".*
    #   Arel[:schema][:users].*  # "schema"."users".*
    #
    # With an argument, falls through to Arel::Math#* (multiplication).
    def *(*args)
      args.empty? ? Arel.qualify(self, Arel.star) : super
    end
  end
end
