# THIS IS A GENERATED FILE, DO NOT EDIT THIS
# Generated on 2014-09-03T09:53:09.174Z

require 'hashie'

module Wix
  module Hive
    module Activities
      module ECommerce
        class Media < Hashie::Trash
          include Hashie::Extensions::IgnoreUndeclared

          property :thumbnail
        end

        class Variant < Hashie::Trash
          include Hashie::Extensions::IgnoreUndeclared

          property :title
          property :value
        end

        class Item < Hashie::Trash
          include Hashie::Extensions::IgnoreUndeclared
          include Hashie::Extensions::Coercion

          coerce_key :media, Media
          coerce_key :variants, Array[Variant]

          property :id
          property :sku
          property :title
          property :quantity
          property :price
          property :formattedPrice
          property :currency
          property :productLink
          property :weight
          property :formattedWeight
          property :media
          property :variants, default: []
        end

        class Coupon < Hashie::Trash
          include Hashie::Extensions::IgnoreUndeclared

          property :total
          property :formattedTotal
          property :title
        end

        class Tax < Hashie::Trash
          include Hashie::Extensions::IgnoreUndeclared

          property :total
          property :formattedTotal
        end

        class Shipping < Hashie::Trash
          include Hashie::Extensions::IgnoreUndeclared

          property :total
          property :formattedTotal
        end

        class Payment < Hashie::Trash
          include Hashie::Extensions::IgnoreUndeclared
          include Hashie::Extensions::Coercion

          coerce_key :coupon, Coupon
          coerce_key :tax, Tax
          coerce_key :shipping, Shipping

          property :total
          property :subtotal
          property :formattedTotal
          property :formattedSubtotal
          property :currency
          property :coupon
          property :tax
          property :shipping
        end

        class ShippingAddres < Hashie::Trash
          include Hashie::Extensions::IgnoreUndeclared

          property :firstName
          property :lastName
          property :email
          property :phone
          property :country
          property :countryCode
          property :region
          property :regionCode
          property :city
          property :address1
          property :address2
          property :zip
          property :company
        end

        class BillingAddres < Hashie::Trash
          include Hashie::Extensions::IgnoreUndeclared

          property :firstName
          property :lastName
          property :email
          property :phone
          property :country
          property :countryCode
          property :region
          property :regionCode
          property :city
          property :address1
          property :address2
          property :zip
          property :company
        end

        class PurchaseActivity < Hashie::Trash
          include Hashie::Extensions::IgnoreUndeclared
          include Hashie::Extensions::Coercion

          coerce_key :items, Array[Item]
          coerce_key :payment, Payment
          coerce_key :shippingAddress, ShippingAddres
          coerce_key :billingAddress, BillingAddres

          property :cartId
          property :storeId
          property :orderId
          property :items, default: []
          property :payment
          property :shippingAddress
          property :billingAddress
          property :paymentGateway
          property :note
          property :buyerAcceptsMarketing
        end
      end
    end
  end
end
