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
end
