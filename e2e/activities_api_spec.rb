require_relative './e2e_helper'

describe 'Activities API' do

  FACTORY = Wix::Hive::Activities
  session_id = '02594992c9c57f61148351a766cf2ab79f7a7007ce309a16fc2b6475b0895b5b09250b55ec2c4cdba152aef47daded4d1e60994d53964e647acf431e4f798bcd0b93ce826ad6aa27a9c95ffedb05f421b7b1419780cf6036d4fd8efd847f9877'

  let(:base_activity) {
    Wix::Hive::Activity.new(
        type: FACTORY::MUSIC_ALBUM_FAN.type,
        locationUrl: 'http://www.wix.com',
        details: { summary: 'test', additionalInfoUrl: 'http://www.wix.com' },
        info: { album: { name: 'Wix', id: '1234' } })
  }

  it '.new_activity' do
    new_activity_result = client.new_activity(session_id, base_activity)

    expect(new_activity_result.activityId).to be_truthy
  end

  it '.activity' do
    new_activity_result = client.new_activity(session_id, base_activity)

    expect(new_activity_result.activityId).to be_truthy

    expect(client.activity(new_activity_result.activityId)).to be_a Wix::Hive::Activity
  end

  context '.activities' do
    it 'returns a cursor with activity results' do
      cursored_result = client.activities
      expect(cursored_result).to be_a Wix::Hive::Cursor
      expect(cursored_result.results.first).to be_a Wix::Hive::Activity
    end

    it 'returns a cursor with activities filtered by activityTypes' do
      cursored_result = client.activities(activityTypes: Wix::Hive::Activities::MUSIC_ALBUM_FAN.type)
      expect(cursored_result).to be_a Wix::Hive::Cursor
      expect(cursored_result.results.map{ |v| v.activityType } ).to all(eq Wix::Hive::Activities::MUSIC_ALBUM_FAN.type)
    end

    it 'returns a cursor with activities filtered by scope' do
      app_result = client.activities(scope: :app)
      site_result = client.activities(scope: :site)
      expect(app_result).to be_a Wix::Hive::Cursor
      expect(site_result).to be_a Wix::Hive::Cursor
    end

    it 'returns a cursor with activities limited by date range' do
      now_result = client.activities(from: Time.now.iso8601(3), until: Time.now.iso8601(3))
      day_ago = (Time.now - (60 * 60 * 24)).iso8601(3)
      day_ago_result = client.activities(from: day_ago, until: Time.now.iso8601(3))

      expect(now_result.results.size).to eq 0
      expect(day_ago_result.results.size).to be >= 1
    end
  end

  context 'create activities' do
    it 'CONTACTS_CREATE' do

      contacts_create = FACTORY::CONTACTS_CREATE.klass.new
      contacts_create.name = {first: 'E2E Activity', last: 'Activity'}
      contacts_create.emails << {email: 'activity@example.com', tag: 'work'}

      activity = Wix::Hive::Activity.new(
          type: FACTORY::CONTACTS_CREATE.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: contacts_create)

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'CONVERSION_COMPLETE' do
      activity = Wix::Hive::Activity.new(
          type: FACTORY::CONVERSION_COMPLETE.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: {conversionType: 'PAGEVIEW'})

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'E_COMMERCE_PURCHASE' do
      coupon = {total: '1', title: 'Dis'}
      payment = {total: '1', subtotal: '1', currency: 'EUR', coupon: coupon}

      purchase = FACTORY::E_COMMERCE_PURCHASE.klass.new(cartId: '11111',
                                                        storeId: '11111', payment: payment)

      activity = Wix::Hive::Activity.new(
          type: FACTORY::E_COMMERCE_PURCHASE.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: purchase)

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'MESSAGING_SEND' do
      recipient = {method: 'EMAIL', destination: {name: {first: 'Alex'}, target: 'localhost'}}

      send = FACTORY::MESSAGING_SEND.klass.new(recipient: recipient)

      activity = Wix::Hive::Activity.new(
          type: FACTORY::MESSAGING_SEND.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: send)

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'MUSIC_ALBUM_FAN' do
      activity = Wix::Hive::Activity.new(
          type: FACTORY::MUSIC_ALBUM_FAN.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: { album: { name: 'Wix', id: '1234' } })

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'MUSIC_ALBUM_SHARE' do
      activity = Wix::Hive::Activity.new(
          type: FACTORY::MUSIC_ALBUM_SHARE.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: { album: { name: 'Wix', id: '1234' }, sharedTo: 'FACEBOOK' })

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'MUSIC_TRACK_LYRICS' do
      activity = Wix::Hive::Activity.new(
          type: FACTORY::MUSIC_TRACK_LYRICS.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: { album: { name: 'Wix', id: '1234' }, track: { name: 'Wix', id: '1234' } })

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'MUSIC_TRACK_PLAY' do
      activity = Wix::Hive::Activity.new(
          type: FACTORY::MUSIC_TRACK_PLAY.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: { album: { name: 'Wix', id: '1234' }, track: { name: 'Wix', id: '1234' } })

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'MUSIC_TRACK_PLAYED' do
      activity = Wix::Hive::Activity.new(
          type: FACTORY::MUSIC_TRACK_PLAYED.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: { album: { name: 'Wix', id: '1234' }, track: { name: 'Wix', id: '1234' } })

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'MUSIC_TRACK_SKIP' do
      activity = Wix::Hive::Activity.new(
          type: FACTORY::MUSIC_TRACK_SKIP.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: { album: { name: 'Wix', id: '1234' }, track: { name: 'Wix', id: '1234' } })

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'MUSIC_TRACK_SHARE' do
      activity = Wix::Hive::Activity.new(
          type: FACTORY::MUSIC_TRACK_SHARE.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: { album: { name: 'Wix', id: '1234' }, track: { name: 'Wix', id: '1234' }, sharedTo: 'FACEBOOK' })

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'HOTELS_CONFIRMATION' do
      guest = { total: 1, adults: 1, children: 0 }

      day_ago = (Time.now - (60 * 60 * 24)).iso8601(3)
      stay = { checkin: day_ago, checkout: Time.now.iso8601(3) }

      invoice = {total: '1', subtotal: '1'}

      activity = Wix::Hive::Activity.new(
          type: FACTORY::HOTELS_CONFIRMATION.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: { source: 'GUEST', guests: guest, stay: stay, invoice: invoice })

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'HOTELS_CANCEL' do
      refund = {kind: 'FULL', total: 1, currency: 'EUR', destination: 'NYC'}

      guest = { total: 1, adults: 1, children: 0 }

      day_ago = (Time.now - (60 * 60 * 24)).iso8601(3)
      stay = { checkin: day_ago, checkout: Time.now.iso8601(3) }

      invoice = {total: '1', subtotal: '1'}

      activity = Wix::Hive::Activity.new(
          type: FACTORY::HOTELS_CANCEL.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: { cancelDate: day_ago, refund: refund, guests: guest,
                  stay: stay, invoice: invoice })

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'HOTELS_PURCHASE' do
      guest = { total: 1, adults: 1, children: 0 }

      day_ago = (Time.now - (60 * 60 * 24)).iso8601(3)
      stay = { checkin: day_ago, checkout: Time.now.iso8601(3) }

      invoice = {total: '1', subtotal: '1'}

      payment = {total: '1', subtotal: '1', currency: 'EUR', source: 'Cash'}

      activity = Wix::Hive::Activity.new(
          type: FACTORY::HOTELS_PURCHASE.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: { source: 'GUEST', guests: guest, stay: stay, invoice: invoice, payment: payment })


      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'HOTELS_PURCHASE_FAILED' do
      guest = { total: 1, adults: 1, children: 0 }

      day_ago = (Time.now - (60 * 60 * 24)).iso8601(3)
      stay = { checkin: day_ago, checkout: Time.now.iso8601(3) }

      invoice = {total: '1', subtotal: '1'}

      payment = {total: '1', subtotal: '1', currency: 'EUR', source: 'Cash', error: {errorCode: '-2801'}}

      activity = Wix::Hive::Activity.new(
          type: FACTORY::HOTELS_PURCHASE_FAILED.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: { source: 'GUEST', guests: guest, stay: stay, invoice: invoice, payment: payment })

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end

    it 'SCHEDULER_APPOINTMENT' do
      activity = Wix::Hive::Activity.new(
          type: FACTORY::SCHEDULER_APPOINTMENT.type,
          locationUrl: 'http://www.wix.com',
          details: {summary: 'test', additionalInfoUrl: 'http://www.wix.com'},
          info: { title: 'test', description: 'test' })

      new_activity_result = client.new_activity(session_id, activity)

      expect(new_activity_result.activityId).to be_truthy
    end
  end
end