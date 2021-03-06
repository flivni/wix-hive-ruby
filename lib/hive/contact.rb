require 'hashie'

module Hive
  class Name < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    property :prefix
    property :first
    property :middle
    property :last
    property :suffix
  end

  class Company < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    property :role
    property :name
  end

  class Email < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    property :id
    property :tag
    property :email
    property :emailStatus
    property :unsubscribeLink
  end

  class Phone < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    property :id
    property :tag
    property :phone
    property :normalizedPhone
  end

  class Address < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    property :id
    property :tag
    property :address
    property :neighborhood
    property :city
    property :region
    property :country
    property :postalCode
  end

  class Url < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    property :id
    property :tag
    property :url
  end

  class Date < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    property :id
    property :tag
    property :date, with: lambda { |v| Time.parse(v) }
  end

  class Note < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    property :id
    property :modifiedAt
    property :content
  end

  class Custom < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    property :id
    property :field
    property :value
  end

  class Link < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    property :href
    property :rel
  end

  class Contact < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    include Hashie::Extensions::Coercion

    coerce_key :name, Name
    coerce_key :company, Company
    coerce_key :emails, Array[Email]
    coerce_key :phones, Array[Phone]
    coerce_key :addresses, Array[Address]
    coerce_key :urls, Array[Url]
    coerce_key :dates, Array[Date]
    coerce_key :notes, Array[Note]
    coerce_key :custom, Array[Custom]
    coerce_key :links, Array[Link]
    property :id
    property :name, default: Hive::Name.new
    property :picture
    property :company, default: Hive::Company.new
    property :emails, default: []
    property :phones, default: []
    property :addresses, default: []
    property :urls, default: []
    property :dates, default: []
    property :notes, default: []
    property :custom, default: []
    property :createdAt
    property :links
    property :modifiedAt

    remove_method :emails=, :phones=, :addresses=, :urls=, :dates=, :notes=, :custom=, :links=

    def add_email(args)
      emails << Email.new(args)
    end

    def add_phone(args)
      phones << Phone.new(args)
    end

    def add_address(args)
      addresses << Address.new(args)
    end

    def add_url(args)
      urls << Url.new(args)
    end

    def add_date(args)
      dates << Date.new(args)
    end

    def add_note(args)
      notes << Note.new(args)
    end

    def add_custom(args)
      custom << Custom.new(args)
    end
  end

  class ContactSubscriber < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    include Hashie::Extensions::Coercion

    coerce_key :name, Name
    coerce_key :emails, Array[Email]

    property :id
    property :name, default: Hive::Name.new
    property :emails, default: []
  end
end
