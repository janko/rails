# frozen_string_literal: true

require_relative "../helper"

module Arel
  module Nodes
    class QualifiedIdentifierTest < Arel::Test
      test "Arel.qualify builds a QualifiedIdentifier" do
        node = Arel.qualify(:users, :name)
        assert_instance_of QualifiedIdentifier, node
        assert_equal "users", node.qualifier
        assert_equal "name",  node.column
      end

      test "Arel.identifier builds an Identifier" do
        node = Arel.identifier(:name)
        assert_instance_of Identifier, node
        assert_equal "name", node.name
      end

      test "Arel.qualify renders as a qualified column" do
        assert_equal %("users"."name"), Arel.qualify(:users, :name).to_sql
      end

      test "Arel[:table][:column] renders as a qualified column" do
        assert_equal %("users"."name"), Arel[:users][:name].to_sql
      end

      test "Identifier#qualify wraps the receiver in a QualifiedIdentifier" do
        node = Arel[:name].qualify(:users)
        assert_instance_of QualifiedIdentifier, node
        assert_equal %("users"."name"), node.to_sql
      end

      test "QualifiedIdentifier#qualify chains a higher qualifier" do
        node = Arel.qualify(:users, :name).qualify(:schema)
        assert_equal %("schema"."users"."name"), node.to_sql
      end

      test "Arel[:schema][:users][:name] supports three-level qualification" do
        assert_equal %("schema"."users"."name"), Arel[:schema][:users][:name].to_sql
      end

      test "predications produce composite nodes against QualifiedIdentifier" do
        node = Arel.qualify(:users, :name).eq("DHH")
        assert_instance_of Equality, node
        assert_equal %("users"."name" = 'DHH'), node.to_sql
      end

      test "Identifier passed as a part is coerced to its name" do
        node = Arel.qualify(Arel[:users], Arel[:name])
        assert_equal "users", node.qualifier
        assert_equal "name",  node.column
      end

      test "QualifiedIdentifier equality and hash are based on its parts" do
        assert_equal Arel.qualify(:users, :name), Arel.qualify(:users, :name)
        assert_equal Arel.qualify(:users, :name).hash, Arel.qualify(:users, :name).hash
        refute_equal Arel.qualify(:users, :name), Arel.qualify(:users, :email)
        refute_equal Arel.qualify(:users, :name), Arel.qualify(:posts, :name)
        assert_equal 1, [Arel.qualify(:users, :name), Arel.qualify(:users, :name)].uniq.size
      end

      test "Symbol parts are coerced to Strings on the node" do
        node = Arel.qualify(:users, :name)
        assert_equal "users", node.qualifier
        assert_equal "name",  node.column
      end

      test "as alias is supported" do
        assert_equal %("users"."name" AS alias), Arel.qualify(:users, :name).as("alias").to_sql
      end

      test "Identifier#* with no argument qualifies all columns" do
        assert_equal %("users".*), Arel[:users].*.to_sql
      end

      test "QualifiedIdentifier#* with no argument qualifies all columns" do
        assert_equal %("schema"."users".*), Arel[:schema][:users].*.to_sql
      end

      test "Identifier#* with an argument still creates a Multiplication" do
        node = Arel[:price] * 2
        assert_instance_of Arel::Nodes::Multiplication, node
      end
    end
  end
end
