# frozen_string_literal: true

require_relative "../helper"

module Arel
  module Nodes
    class IdentifierTest < Arel::Test
      test "Arel.expr with a Symbol returns an Identifier" do
        node = Arel.expr(:name)
        assert_instance_of Arel::Nodes::Identifier, node
        assert_equal "name", node.name
      end

      test "Arel.[] is an alias for Arel.expr" do
        assert_equal Arel.expr(:name), Arel[:name]
      end

      test "Arel.[] with a String raises ArgumentError" do
        assert_raises(ArgumentError) { Arel["name"] }
      end

      test "Arel.[] with a Hash raises ArgumentError" do
        assert_raises(ArgumentError) { Arel[name: "DHH"] }
      end

      test "Arel.[] with an unsupported type raises ArgumentError" do
        assert_raises(ArgumentError) { Arel[123] }
      end

      test "predications return composite nodes" do
        eq = Arel[:name].eq("DHH")
        assert_instance_of Arel::Nodes::Equality, eq
        assert_instance_of Arel::Nodes::Identifier, eq.left

        gt = Arel[:age].gt(35)
        assert_instance_of Arel::Nodes::GreaterThan, gt
      end

      test "rendering an Identifier emits an unqualified column name" do
        assert_equal %("name"), Arel[:name].to_sql
        assert_equal %("name" = 'DHH'), Arel[:name].eq("DHH").to_sql
      end

      test "Identifier renders unqualified inside a SELECT" do
        users = Arel::Table.new(:users)
        manager = users.project(Arel.star).where(Arel[:name].eq("DHH"))
        sql = manager.to_sql
        assert_match(/FROM "users"/, sql)
        assert_match(/WHERE "name" = 'DHH'/, sql)
      end

      test "equality and hash are based on name" do
        assert_equal Arel[:name], Arel[:name]
        assert_equal Arel[:name].hash, Arel[:name].hash
        refute_equal Arel[:name], Arel[:other]
        assert_equal 1, [Arel[:name], Arel[:name]].uniq.size
      end

      test "Arel.identifier accepts a String" do
        node = Arel.identifier("name")
        assert_instance_of Arel::Nodes::Identifier, node
        assert_equal "name", node.name
      end
    end
  end
end
