require 'rails_helper'
require 'faker'

RSpec.describe Feature::Reservation::Upsert do
    describe 'call' do
        def call_service(email, payload)
            Feature::Reservation::Upsert.new(email, payload).call
        end

        describe 'have reservation payload' do
            guest_email = Faker::Internet.unique.email
            reservation_payload = { 
                'code': Faker::Invoice.unique.creditor_reference,
                'start_date': Faker::Date.forward(days: 5),
                'end_date': Faker::Date.forward(days: 8),
                'total_nights': 3,
                'total_guests': 10,
                'reserve_status': 'accepted',
                'currency': Faker::Currency.code,
                'payout_price': '5000',
                'security_price': '300',
                'total_price': '5300',
                'total_adults': 5,
                'total_children': 3,
                'total_infants': 2
            }

            context 'same with all Reservation fields' do
                before do
                    guest = Guest.create({email: guest_email})
                    call_service(guest_email, reservation_payload)
                end

                it 'create a Reservation' do
                    guest = Guest.take
                    expect(Reservation.count).to eq(1)
                    reservation = Reservation.take
                    expect(reservation.guest_id).to eq(guest.id)
                    expect(reservation.code).to eq(reservation_payload[:code])
                    expect(reservation.start_date).to eq(reservation_payload[:start_date])
                    expect(reservation.end_date).to eq(reservation_payload[:end_date])
                    expect(reservation.total_nights).to eq(reservation_payload[:total_nights])
                    expect(reservation.total_guests).to eq(reservation_payload[:total_guests])
                    expect(reservation.reserve_status).to eq(reservation_payload[:reserve_status])
                    expect(reservation.currency).to eq(reservation_payload[:currency])
                    expect(reservation.payout_price).to eq(0.5e4)
                    expect(reservation.security_price).to eq(0.3e3)
                    expect(reservation.total_price).to eq(0.53e4)
                    expect(reservation.total_adults).to eq(reservation_payload[:total_adults])
                    expect(reservation.total_children).to eq(reservation_payload[:total_children])
                    expect(reservation.total_infants).to eq(reservation_payload[:total_infants])
                end 
            end

            context 'only have code' do
                reservation_code_payload = { 
                    'code': Faker::Invoice.unique.creditor_reference
                }

                before do
                    Guest.create({email: guest_email})
                    call_service(guest_email, reservation_code_payload)
                end

                it { expect(Reservation.count).to eq(1) }
            end

            context 'invalid email' do

                it do 
                    Guest.create({email: guest_email})
                    expect { call_service("invalid_email.example.com", reservation_payload) }.to \
                    raise_error(RuntimeError)
                    expect(Reservation.count).to eq(0)
                end
            end

            context 'same with Reservation fields without code' do
                before do
                    reservation_payload.tap { |gp| gp.delete(:code) }
                end

                it do 
                    Guest.create({email: guest_email})
                    expect { call_service(guest_email, reservation_payload) }.to \
                    raise_error(ActiveRecord::NotNullViolation)
                    expect(Reservation.count).to eq(0)
                end
            end

            context 'NOT same with Reservation fields' do
                not_reservation_payload = {
                    'random_key': Faker::Lorem.word
                }

                it do 
                    Guest.create({email: guest_email})
                    expect { call_service(guest_email, not_reservation_payload) }.to \
                    raise_error(ActiveModel::UnknownAttributeError)
                    expect(Reservation.count).to eq(0)
                end
            end

            context 'NOT same with Reservation fields but with code' do
                not_reservation_payload_with_code = {
                    'random_key': Faker::Lorem.word,
                    'code': Faker::Invoice.unique.creditor_reference,
                }

                it do 
                    Guest.create({email: guest_email})
                    expect { call_service(guest_email, not_reservation_payload_with_code) }.to \
                    raise_error(ActiveModel::UnknownAttributeError)
                    expect(Reservation.count).to eq(0)
                end
            end
        end

        describe 'without payload' do
            it { expect { call_service() }.to raise_error(ArgumentError) }
        end
    end
end
