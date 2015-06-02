require "json"
require "json-schema"

require "minitest/autorun"

describe "Validating JSON" do
  before :each do
    @schema = {
      "type" => "object",
      "required" => ["a"],
      "properties" => {
        "a" => {"type" => "integer"}
      }
    }

    @data = {
      "a" => 5
    }
  end

  it "is a real thing people do" do
    assert(JSON::Validator.validate(@schema, @data))
  end

  it "raises errors too" do
    bad_data = {"b" => 1}
    refute(JSON::Validator.validate(@schema, bad_data))
  end

  describe "validating types" do
    it "knows about strings" do
      @schema = {
        "type" => "object",
        "required" => ["a"],
        "properties" => {
          "a" => {"type" => "string"}
        }
      }

      refute(JSON::Validator.validate(@schema, {"a" => 1}))
      refute(JSON::Validator.validate(@schema, {"a" => []}))
      refute(JSON::Validator.validate(@schema, {"a" => nil}))
      refute(JSON::Validator.validate(@schema, {"a" => true}))
      refute(JSON::Validator.validate(@schema, {"a" => false}))
      refute(JSON::Validator.validate(@schema, {"a" => Time.now}))
      refute(JSON::Validator.validate(@schema, {"a" => { "b" => "strang"}}))
      refute(JSON::Validator.validate(@schema, {"a" => Object.new}))
      assert(JSON::Validator.validate(@schema, {"a" => "strang"}))
    end

    # numberInteger/Float [6]
    # objectHash
    # arrayArray
    # booleanTrueClass/FalseClass
    # nullNilClass

    it "knows about number" do
      @schema = {
        "type" => "object",
        "required" => ["a"],
        "properties" => {
          "a" => {"type" => "number"}
        }
      }

      assert(JSON::Validator.validate(@schema, {"a" => 1}))
      refute(JSON::Validator.validate(@schema, {"a" => []}))
      refute(JSON::Validator.validate(@schema, {"a" => nil}))
      refute(JSON::Validator.validate(@schema, {"a" => true}))
      refute(JSON::Validator.validate(@schema, {"a" => false}))
      refute(JSON::Validator.validate(@schema, {"a" => Time.now}))
      refute(JSON::Validator.validate(@schema, {"a" => { "b" => "strang"}}))
      refute(JSON::Validator.validate(@schema, {"a" => "strang"}))
    end

    it "knows about booleans" do
      @schema = {
        "type" => "object",
        "required" => ["a"],
        "properties" => {
          "a" => {"type" => "boolean"}
        }
      }

      refute(JSON::Validator.validate(@schema, {"a" => 1}))
      refute(JSON::Validator.validate(@schema, {"a" => []}))
      assert(JSON::Validator.validate(@schema, {"a" => true}))
      assert(JSON::Validator.validate(@schema, {"a" => false}))
      refute(JSON::Validator.validate(@schema, {"a" => nil}))
      refute(JSON::Validator.validate(@schema, {"a" => Time.now}))
      refute(JSON::Validator.validate(@schema, {"a" => { "b" => "strang"}}))
      refute(JSON::Validator.validate(@schema, {"a" => "strang"}))
    end

    it "knows about nil/null" do
      @schema = {
        "type" => "object",
        "required" => ["a"],
        "properties" => {
          "a" => {"type" => "null"}
        }
      }

      refute(JSON::Validator.validate(@schema, {"a" => 1}))
      refute(JSON::Validator.validate(@schema, {"a" => []}))
      refute(JSON::Validator.validate(@schema, {"a" => true}))
      refute(JSON::Validator.validate(@schema, {"a" => false}))
      assert(JSON::Validator.validate(@schema, {"a" => nil}))
      refute(JSON::Validator.validate(@schema, {"a" => Time.now}))
      refute(JSON::Validator.validate(@schema, {"a" => { "b" => "strang"}}))
      refute(JSON::Validator.validate(@schema, {"a" => "strang"}))
    end

    it "knows about arrays" do
      @schema = {
        "type" => "object",
        "required" => ["a"],
        "properties" => {
          "a" => {"type" => "array"}
        }
      }

      refute(JSON::Validator.validate(@schema, {"a" => 1}))
      refute(JSON::Validator.validate(@schema, {"a" => true}))
      refute(JSON::Validator.validate(@schema, {"a" => false}))
      refute(JSON::Validator.validate(@schema, {"a" => nil}))
      refute(JSON::Validator.validate(@schema, {"a" => Time.now}))
      refute(JSON::Validator.validate(@schema, {"a" => { "b" => "strang"}}))
      refute(JSON::Validator.validate(@schema, {"a" => "strang"}))
      assert(JSON::Validator.validate(@schema, {"a" => []}))
      assert(JSON::Validator.validate(@schema, {"a" => ["1", "2"]}))
      assert(JSON::Validator.validate(@schema, {"a" => [[[]]]}))
    end

    it "knows about hashes/objects" do
      @schema = {
        "type" => "object",
        "required" => ["a"],
        "properties" => {
          "a" => {"type" => "object"}
        }
      }

      refute(JSON::Validator.validate(@schema, {"a" => 1}))
      refute(JSON::Validator.validate(@schema, {"a" => []}))
      refute(JSON::Validator.validate(@schema, {"a" => true}))
      refute(JSON::Validator.validate(@schema, {"a" => false}))
      refute(JSON::Validator.validate(@schema, {"a" => nil}))
      refute(JSON::Validator.validate(@schema, {"a" => Time.now}))
      refute(JSON::Validator.validate(@schema, {"a" => "strang"}))
      assert(JSON::Validator.validate(@schema, {"a" => { "b" => "strang"}}))
    end
  end
end
