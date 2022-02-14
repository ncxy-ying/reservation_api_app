require 'rails_helper'
require 'faker'

RSpec.describe Feature::Reservation::BookcomParse do
    describe 'call' do
        def call_service(payload)
            Feature::Reservation::BookcomParse.new(payload).call
        end

        describe 'have bookcom payload' do
            bookcom_full_payload = {
                "reservation": {
                    "code": "WWW123",
                    "start_date": "2022-03-12",
                    "end_date": "2022-03-16",
                    "expected_payout_amount": "3000.00",
                    "guest_details": {
                        "localized_description": "7 guests",
                        "number_of_adults": 4,
                        "number_of_children": 2,
                        "number_of_infants": 1
                    },
                    "guest_email": Faker::Internet.unique.email,
                    "guest_first_name": Faker::Name.first_name,
                    "guest_last_name": Faker::Name.last_name,
                    "guest_phone_numbers": [
                        Faker::PhoneNumber.cell_phone_in_e164,
                        Faker::PhoneNumber.cell_phone_in_e164
                    ],
                    "listing_security_price_accurate": "500.00",
                    "host_currency": "AUD",
                    "nights": 3,
                    "number_of_guests": 7,
                    "status_type": "accepted",
                    "total_paid_amount_accurate": "3500.00"
                }
            }

            context 'with all data' do
                it 'parse it same with Reservation and Guest fields' do
                    reservation = bookcom_full_payload[:reservation]
                    expected_guest_json = {
                        'first_name': reservation[:guest_first_name],
                        'last_name':  reservation[:guest_last_name],
                        'phone_1':    reservation[:guest_phone_numbers][0],
                        'phone_2':    reservation[:guest_phone_numbers][1],
                        'email':      reservation[:guest_email]
                    }
                    expected_reservation_json = {
                        'code':           reservation[:code],
                        'start_date':     reservation[:start_date],
                        'end_date':       reservation[:end_date],
                        'total_nights':   reservation[:nights],
                        'total_guests':   reservation[:number_of_guests],
                        'reserve_status': reservation[:status_type],
                        'currency':       reservation[:host_currency],
                        'payout_price':   reservation[:expected_payout_amount],
                        'security_price': reservation[:listing_security_price_accurate],
                        'total_price':    reservation[:total_paid_amount_accurate],
                        'total_adults':   reservation[:guest_details][:number_of_adults],
                        'total_children': reservation[:guest_details][:number_of_children],
                        'total_infants':  reservation[:guest_details][:number_of_infants]
                    }
                    info = call_service(bookcom_full_payload)
                    expect(info[:guest].present?).to eq(true)
                    expect(info[:reservation].present?).to eq(true)
                    expect(info[:guest]).to eq(expected_guest_json)
                    expect(info[:reservation]).to eq(expected_reservation_json)
                end 
            end

            context 'without reservation data' do
                it 'parse with nil' do
                    bookcom_guest_payload = {
                        'without_reservation': {
                            'code': Faker::Lorem.word,
                            'start_date': Faker::Lorem.word,
                            'end_date': Faker::Lorem.word,
                        }
                    }
                    info = call_service(bookcom_guest_payload)
                    expect(info).to eq({ 'guest': {}, 'reservation': {} } )
                end
            end

            context 'without [:reservation][:guest_details]' do
                it 'parse with nil' do
                    bookcom_full_payload[:reservation][:guest_details] = {}
                    reservation = bookcom_full_payload[:reservation]
                    expected_guest_json = {
                        'first_name': reservation[:guest_first_name],
                        'last_name':  reservation[:guest_last_name],
                        'phone_1':    reservation[:guest_phone_numbers][0],
                        'phone_2':    reservation[:guest_phone_numbers][1],
                        'email':      reservation[:guest_email]
                    }
                    expected_reservation_json = {
                        'code':           reservation[:code],
                        'start_date':     reservation[:start_date],
                        'end_date':       reservation[:end_date],
                        'total_nights':   reservation[:nights],
                        'total_guests':   reservation[:number_of_guests],
                        'reserve_status': reservation[:status_type],
                        'currency':       reservation[:host_currency],
                        'payout_price':   reservation[:expected_payout_amount],
                        'security_price': reservation[:listing_security_price_accurate],
                        'total_price':    reservation[:total_paid_amount_accurate],
                        'total_adults':   nil,
                        'total_children': nil,
                        'total_infants':  nil
                    }
                    info = call_service(bookcom_full_payload)
                    expect(info[:guest].present?).to eq(true)
                    expect(info[:reservation].present?).to eq(true)
                    expect(info[:guest]).to eq(expected_guest_json)
                    expect(info[:reservation]).to eq(expected_reservation_json)
                end
            end

        end

        describe 'without payload' do
            it { expect { call_service() }.to raise_error(ArgumentError) }
        end
    end
end