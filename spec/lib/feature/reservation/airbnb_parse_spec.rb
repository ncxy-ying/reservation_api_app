require 'rails_helper'
require 'faker'

RSpec.describe Feature::Reservation::AirbnbParse do
    describe 'call' do
        def call_service(payload)
            Feature::Reservation::AirbnbParse.new(payload).call
        end

        describe 'have airbnb payload' do
            airbnb_full_payload = {
                'reservation_code': 'AAA123',
                'start_date': '2021-04-14',
                'end_date': '2021-04-18',
                'nights': 2,
                'guests': 9,
                'adults': 6,
                'children': 2,
                'infants': 1,
                'status': 'accepted',
                'currency': 'SGD',
                'payout_price': '5200.00',
                'security_price': '500',
                'total_price': '5700.00',
                'guest': {
                    'first_name': Faker::Name.first_name,
                    'last_name': Faker::Name.last_name,
                    'phone': Faker::PhoneNumber.cell_phone_in_e164,
                    'email': Faker::Internet.unique.email
                }
            }

            context 'with all data' do
                it 'parse it same with Reservation and Guest fields' do
                    expected_guest_json = {
                        'first_name': airbnb_full_payload[:guest][:first_name],
                        'last_name':  airbnb_full_payload[:guest][:last_name],
                        'phone_1':    airbnb_full_payload[:guest][:phone],
                        'email':      airbnb_full_payload[:guest][:email]
                    }
                    expected_reservation_json = {
                        'code':           airbnb_full_payload[:reservation_code],
                        'start_date':     airbnb_full_payload[:start_date],
                        'end_date':       airbnb_full_payload[:end_date],
                        'total_nights':   airbnb_full_payload[:nights],
                        'total_guests':   airbnb_full_payload[:guests],
                        'reserve_status': airbnb_full_payload[:status],
                        'currency':       airbnb_full_payload[:currency],
                        'payout_price':   airbnb_full_payload[:payout_price],
                        'security_price': airbnb_full_payload[:security_price],
                        'total_price':    airbnb_full_payload[:total_price],
                        'total_adults':   airbnb_full_payload[:adults],
                        'total_children': airbnb_full_payload[:children],
                        'total_infants':  airbnb_full_payload[:infants]
                    }
                    info = call_service(airbnb_full_payload)
                    expect(info[:guest].present?).to eq(true)
                    expect(info[:reservation].present?).to eq(true)
                    expect(info[:guest]).to eq(expected_guest_json)
                    expect(info[:reservation]).to eq(expected_reservation_json)
                end 
            end

            context 'without guest data' do
                it 'parse with nil' do
                    expected_guest_json = {
                                            'first_name': nil,
                                            'last_name':  nil,
                                            'phone_1':    nil,
                                            'email':      nil
                                        }
                    airbnb_full_payload.tap { |gp| gp.delete(:guest) }
                    info = call_service(airbnb_full_payload)
                    expect(info[:guest].present?).to eq(true)
                    expect(info[:guest]).to eq(expected_guest_json)
                end
            end

            context 'without reservation data' do
                it 'parse with nil' do
                    airbnb_guest_payload = {
                        'guest': {
                            'first_name': Faker::Name.first_name,
                            'last_name': Faker::Name.last_name,
                            'phone': Faker::PhoneNumber.cell_phone_in_e164,
                            'email': Faker::Internet.unique.email
                        }
                    }
                    expected_guest_json = {
                        'first_name': airbnb_guest_payload[:guest][:first_name],
                        'last_name':  airbnb_guest_payload[:guest][:last_name],
                        'phone_1':    airbnb_guest_payload[:guest][:phone],
                        'email':      airbnb_guest_payload[:guest][:email]
                    }
                    expected_reservation_json = {
                                                    'code':           nil,
                                                    'start_date':     nil,
                                                    'end_date':       nil,
                                                    'total_nights':   nil,
                                                    'total_guests':   nil,
                                                    'reserve_status': nil,
                                                    'currency':       nil,
                                                    'payout_price':   nil,
                                                    'security_price': nil,
                                                    'total_price':    nil,
                                                    'total_adults':   nil,
                                                    'total_children': nil,
                                                    'total_infants':  nil
                                                }
                    info = call_service(airbnb_guest_payload)
                    expect(info[:guest].present?).to eq(true)
                    expect(info[:guest]).to eq(expected_guest_json)
                    expect(info[:reservation].present?).to eq(true)
                    expect(info[:reservation]).to eq(expected_reservation_json)
                end
            end
        end

        describe 'without payload' do
            it { expect { call_service() }.to raise_error(ArgumentError) }
        end
    end
end
