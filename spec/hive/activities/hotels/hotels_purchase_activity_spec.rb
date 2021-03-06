require 'spec_helper'

describe 'HOTELS_PURCHASE' do
  guest = { total: 1, adults: 1, children: 0 }

  day_ago = (Time.now - (60 * 60 * 24)).iso8601(3)
  stay = { checkin: day_ago, checkout: Time.now.iso8601(3) }

  invoice = {total: '1', subtotal: '1', currency: 'EUR'}

  payment = {total: '1', subtotal: '1', currency: 'EUR', source: 'Cash'}

  subject(:create_activity) {ACTIVITIES_FACTORY::HOTELS_PURCHASE.klass.new( source: 'GUEST', guests: guest, stay: stay, invoice: invoice, payment: payment ) }

  it '.add_rate' do
    create_activity.add_rate( date: 'date', subtotal: '1', total: '1', currency: 'EUR' )
  end

  it '.add_room' do
    create_activity.add_room( maxOccupancy: 1 )
  end
end