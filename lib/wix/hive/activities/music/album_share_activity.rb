# THIS IS A GENERATED FILE, DO NOT EDIT THIS
# Generated on 2014-09-03T09:53:09.203Z

require 'hashie'

module Wix
  module Hive
    module Activities
      module Music
        class ShareActivity < Hashie::Trash
          include Hashie::Extensions::IgnoreUndeclared
          include Hashie::Extensions::Coercion

          coerce_key :album, Album

          property :album
          property :sharedTo
        end
      end
    end
  end
end
