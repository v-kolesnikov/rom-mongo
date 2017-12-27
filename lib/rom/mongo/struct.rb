require 'rom/struct'

module ROM
  module Mongo
    class Struct < ROM::Struct
      constructor_type :permissive
    end
  end
end
