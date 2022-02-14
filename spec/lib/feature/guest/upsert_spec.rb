require 'rails_helper'
require 'faker'

RSpec.describe Feature::Guest::Upsert do
    describe 'call' do
        def call_service(payload)
            Feature::Guest::Upsert.new(payload).call
        end

        describe 'have guest payload' do
            guest_payload = { 
                'first_name': Faker::Name.first_name,
                'last_name':  Faker::Name.last_name,
                'phone_1':    Faker::PhoneNumber.cell_phone_in_e164,
                'phone_2':    Faker::PhoneNumber.cell_phone_in_e164,
                'email':      Faker::Internet.unique.email
            }

            context 'same with all Guest fields' do
                before do
                    call_service(guest_payload)
                end

                it 'create a Guest' do
                    expect(Guest.count).to eq(1)
                    guest = Guest.take
                    expect(guest.first_name).to eq(guest_payload[:first_name])
                    expect(guest.last_name).to eq(guest_payload[:last_name])
                    expect(guest.phone_1).to eq(guest_payload[:phone_1])
                    expect(guest.phone_2).to eq(guest_payload[:phone_2])
                    expect(guest.email).to eq(guest_payload[:email])
                end 
            end

            context 'with Guest email only' do
                email_guest_payload = { 
                    'email': Faker::Internet.unique.email
                }
                before do
                    call_service(email_guest_payload)
                end

                it { expect(Guest.count).to eq(1) }
            end

            context 'same with Guest fields without email' do
                before do
                    guest_payload.tap { |gp| gp.delete(:email) }
                end

                it do 
                    expect { call_service(guest_payload) }.to \
                    raise_error(ActiveRecord::NotNullViolation)
                    expect(Guest.count).to eq(0)
                end
            end

            context 'NOT same with Guest fields' do
                not_guest_payload = {
                    'random_key': Faker::Lorem.word
                }

                it do 
                    expect { call_service(not_guest_payload) }.to \
                    raise_error(ActiveModel::UnknownAttributeError)
                    expect(Guest.count).to eq(0)
                end
            end

            context 'NOT same with Guest fields but with email' do
                not_guest_payload_with_email = {
                    'random_key': Faker::Lorem.word,
                    'email': Faker::Internet.unique.email
                }

                it do 
                    expect { call_service(not_guest_payload_with_email) }.to \
                    raise_error(ActiveModel::UnknownAttributeError)
                    expect(Guest.count).to eq(0)
                end
            end
        end

        describe 'without payload' do
            it { expect { call_service() }.to raise_error(ArgumentError) }
        end
    end
end
