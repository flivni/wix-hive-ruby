# THIS IS A GENERATED FILE, DO NOT EDIT THIS
# Generated on 2014-09-07T15:01:00.780Z

require 'hashie'
require 'hive/extensions/hashie_validate_enum'

module Hive
  module Activities
    module Music
      class Track < Hashie::Trash
        include Hashie::Extensions::IgnoreUndeclared

        property :name, required: true
        property :id
      end

      class Artist < Hashie::Trash
        include Hashie::Extensions::IgnoreUndeclared

        property :name, required: true
        property :id
      end

      class LyricsActivity < Hashie::Trash
        include Hashie::Extensions::IgnoreUndeclared
        include Hashie::Extensions::Coercion

        class Album < Hashie::Trash
          include Hashie::Extensions::IgnoreUndeclared

          property :name
          property :id
        end

        coerce_key :track, Track
        coerce_key :album, Album
        coerce_key :artist, Artist

        property :track
        property :album
        property :artist
      end
    end
  end
end