require 'spec_helper'

describe Wix::Hive::REST::Contacts do

  time_now = Time.now.to_i
  subject(:contacts) { (Class.new { include Wix::Hive::Util; include Wix::Hive::REST::Contacts }).new }

  it '.contacts' do
    expect(contacts).to receive(:perform_with_cursor).with(:get, '/v1/contacts', Wix::Hive::Contact).and_return(instance_double(Faraday::Response, body: 'mock'))
    contacts.contacts
  end

  it '.contact' do
    expect(contacts).to receive(:perform_with_object).with(:get, '/v1/contacts/id', Wix::Hive::Contact).and_return(instance_double(Faraday::Response, body: 'mock'))
    contacts.contact('id')
  end

  it '.create_contact' do
    contact = double('Contact')
    expect(contact).to receive(:to_json).and_return('mock')
    expect(contacts).to receive(:perform).with(:post, '/v1/contacts', body: 'mock').and_return(instance_double(Faraday::Response, body: 'mock'))
    contacts.create_contact(contact)
  end

  context '.update_contact' do
    it 'with id provided' do
      id = '1234'
      contact = double('Contact')
      expect(contact).to receive(:id).and_return(id).twice
      expect(contact).to receive(:to_json).and_return('mock')
      expect(contacts).to receive(:perform_with_object).with(:put, "/v1/contacts/#{id}", Wix::Hive::Contact, body: 'mock').and_return(instance_double(Faraday::Response, body: 'mock'))
      contacts.update_contact(contact)
    end

    it 'without id provided' do
      contact = double('Contact')
      expect(contact).to receive(:id).and_return(nil)
      expect { contacts.update_contact(contact) }.to raise_error(ArgumentError)
    end
  end

  context '.upsert_contact' do
    it 'with phone provided' do
      expect(contacts).to receive(:perform).with(:put, '/v1/contacts', body: '{"phone":"123456789"}').and_return(instance_double(Faraday::Response, body: 'mock'))
      contacts.upsert_contact(phone: '123456789')
    end

    it 'with email provided' do
      expect(contacts).to receive(:perform).with(:put, '/v1/contacts', body: '{"email":"alext@wix.com"}').and_return(instance_double(Faraday::Response, body: 'mock'))
      contacts.upsert_contact(email: 'alext@wix.com')
    end

    it 'without email or phone' do
      expect { contacts.upsert_contact(nothing: nil) }.to raise_error(ArgumentError)
    end
  end

  it '.update_contact_name' do
    contact_id = '1234'
    contact_name = double('ContactName')
    allow(Time).to receive(:now) { time_now }
    expect(contact_name).to receive(:to_json).and_return('mock')
    expect(contacts).to receive(:perform_with_object).with(:put, "/v1/contacts/#{contact_id}/name", Wix::Hive::Contact, body: 'mock', params: {modifiedAt: time_now}).and_return(instance_double(Faraday::Response, body: 'mock'))
    contacts.update_contact_name(contact_id, contact_name)
  end

  it '.update_contact_company' do
    contact_id = '1234'
    company = Wix::Hive::Company.new
    company.name = 'Wix'
    allow(Time).to receive(:now) { time_now }
    expect(contacts).to receive(:perform_with_object).with(:put, "/v1/contacts/#{contact_id}/company", Wix::Hive::Contact, body: company.to_json, params: {modifiedAt: time_now}).and_return(instance_double(Faraday::Response, body: 'mock'))
    contacts.update_contact_company(contact_id, company)
  end

  it '.update_contact_picture' do
    contact_id = '1234'
    picture = 'http://example.com/img1.jpg'
    allow(Time).to receive(:now) { time_now }
    expect(contacts).to receive(:perform_with_object).with(:put, "/v1/contacts/#{contact_id}/picture", Wix::Hive::Contact, body: picture.to_json, params: {modifiedAt: time_now}).and_return(instance_double(Faraday::Response, body: 'mock'))
    contacts.update_contact_picture(contact_id, picture)
  end

  it '.update_contact_address' do
    contact_id = '1234'
    address_id = '5678'
    address = Wix::Hive::Address.new
    address.address = 'Wix'
    allow(Time).to receive(:now) { time_now }
    expect(contacts).to receive(:perform_with_object).with(:put, "/v1/contacts/#{contact_id}/address/#{address_id}", Wix::Hive::Contact, body: address.to_json, params: {modifiedAt: time_now}).and_return(instance_double(Faraday::Response, body: 'mock'))
    contacts.update_contact_address(contact_id, address_id, address)
  end
end