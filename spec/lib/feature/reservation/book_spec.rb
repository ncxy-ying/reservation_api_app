require 'rails_helper'
require 'faker'

RSpec.describe Feature::Reservation::Book do
    describe 'call' do
        def call_service(payload)
            Feature::Reservation::Book.new(payload).call
        end

        describe 'airbnb payload' do
            airbnb_code_only_payload = { 'reservation_code': 'AAA123' }
            airbnb_code_and_email_only_payload = {
                'reservation_code': 'AAA123',
                'guest': {
                    'email': Faker::Internet.unique.email
                }
            }
            airbnb_guest_only_payload = { 
                'guest': {
                    'first_name': Faker::Name.first_name,
                    'last_name': Faker::Name.last_name,
                    'phone': Faker::PhoneNumber.cell_phone_in_e164,
                    'email': Faker::Internet.unique.email
                }
            }
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

            context 'with reservation code only' do
                before do
                    call_service(airbnb_code_only_payload)
                end

                it { expect(Guest.count).to eq(0) }
                it { expect(Reservation.count).to eq(0) }
            end

            context 'with guest data only' do                
                it do 
                    expect { call_service(airbnb_guest_only_payload) }.to \
                    raise_error(RuntimeError)
                end
            end

            context 'with reservation & guest email only' do                
                before do
                    call_service(airbnb_code_and_email_only_payload)
                end

                it { expect(Guest.count).to eq(1) }
                it { expect(Reservation.count).to eq(1) }
            end

            context 'with full guest and reservation data' do
                before do
                    call_service(airbnb_full_payload)
                end

                it { expect(Guest.count).to eq(1) }
                it { expect(Reservation.count).to eq(1) }
            end

            context 'with existing guest and new reservation data' do
                before do
                    existing_guest = Guest.create({ email:'guest_1@example.com' })
                    airbnb_full_payload[:guest][:email] = existing_guest.email
                    call_service(airbnb_full_payload)
                end

                it { expect(Guest.count).to eq(1) }
                it { expect(Reservation.count).to eq(1) }
            end

            context 'with existing guest and existing reservation data' do
                before do
                    existing_guest = Guest.create({ email:'guest_1@example.com' })
                    existing_reservation = Reservation.create(
                        { code: 'ZZZ123', guest_id: existing_guest.id }
                    )
                    airbnb_full_payload[:guest][:email] = existing_guest.email
                    airbnb_full_payload[:reservation_code] = existing_reservation.code
                    call_service(airbnb_full_payload)
                end

                it { expect(Guest.count).to eq(1) }
                it { expect(Reservation.count).to eq(1) }
            end

            context 'with existing guest and new reservation data' do
                before do
                    existing_guest = Guest.create({ email:'guest_1@example.com' })
                    existing_reservation = Reservation.create(
                        { code: 'TTT123', guest_id: existing_guest.id }
                    )
                    airbnb_full_payload[:guest][:email] = existing_guest.email
                    call_service(airbnb_full_payload)
                end

                it { expect(Guest.count).to eq(1) }
                it { expect(Reservation.count).to eq(2) }
            end
        end

        describe 'bookcom payload' do
            bookcom_code_only_payload = {
                'reservation': { 'code': 'AAA123' }
            }
            bookcom_code_and_email_only_payload = {
                'reservation': {
                    'code': 'AAA123',
                    'guest_email': Faker::Internet.unique.email
                },
            }
            bookcom_guest_only_payload = {
                'reservation': {
                    'guest_email': Faker::Internet.unique.email
                },
            }
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

            context 'with reservation code only' do
                before do
                    call_service(bookcom_code_only_payload)
                end

                it { expect(Guest.count).to eq(0) }
                it { expect(Reservation.count).to eq(0) }
            end

            context 'with guest data only' do                
                it { expect(Guest.count).to eq(0) }
                it { expect(Reservation.count).to eq(0) }
            end

            context 'with reservation & guest email only' do                
                before do
                    call_service(bookcom_code_and_email_only_payload)
                end

                it { expect(Guest.count).to eq(1) }
                it { expect(Reservation.count).to eq(1) }
            end

            context 'with full guest and reservation data' do
                before do
                    call_service(bookcom_full_payload)
                end

                it { expect(Guest.count).to eq(1) }
                it { expect(Reservation.count).to eq(1) }
            end

            context 'with existing guest and new reservation data' do
                before do
                    existing_guest = Guest.create({ email:'guest_2@example.com' })
                    bookcom_full_payload[:reservation][:guest_email] = existing_guest.email
                    call_service(bookcom_full_payload)
                end

                it { expect(Guest.count).to eq(1) }
                it { expect(Reservation.count).to eq(1) }
            end

            context 'with existing guest and existing reservation data' do
                before do
                    existing_guest = Guest.create({ email:'guest_2@example.com' })
                    existing_reservation = Reservation.create(
                        { code: 'UUU123', guest_id: existing_guest.id }
                    )
                    bookcom_full_payload[:reservation][:guest_email] = existing_guest.email
                    bookcom_full_payload[:reservation][:code] = existing_reservation.code
                    call_service(bookcom_full_payload)
                end

                it { expect(Guest.count).to eq(1) }
                it { expect(Reservation.count).to eq(1) }
            end

            context 'with existing guest and new reservation data' do
                before do
                    existing_guest = Guest.create({ email:'guest_2@example.com' })
                    existing_reservation = Reservation.create(
                        { code: 'PPP123', guest_id: existing_guest.id }
                    )
                    bookcom_full_payload[:reservation][:guest_email] = existing_guest.email
                    call_service(bookcom_full_payload)
                end

                it { expect(Guest.count).to eq(1) }
                it { expect(Reservation.count).to eq(2) }
            end
        end

        describe 'same guest with bookcom & airbnb payload' do
            guest_email = 'guest_2@example.com'
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
                    'email': guest_email
                }
            }
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
                    "guest_email": guest_email,
                    "guest_first_name": Faker::Name.first_name,
                    "guest_last_name": Faker::Name.last_name,
                    "guest_phone_numbers": [
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
            context 'with new guest' do
                before do
                    call_service(airbnb_full_payload)
                    call_service(bookcom_full_payload)
                end

                it { expect(Guest.count).to eq(1) }
                it { expect(Reservation.count).to eq(2) }
            end

            context 'same email with existing guest' do
                before do
                    Guest.create({ email: guest_email })
                    call_service(airbnb_full_payload)
                    call_service(bookcom_full_payload)
                end

                it { expect(Guest.count).to eq(1) }
                it { expect(Reservation.count).to eq(2) }
            end

            context 'different email with existing guest' do
                before do
                    Guest.create({ email: 'abc@example.com' })
                    call_service(airbnb_full_payload)
                    call_service(bookcom_full_payload)
                end

                it { expect(Guest.count).to eq(2) }
                it { expect(Reservation.count).to eq(2) }
            end
        end

        describe 'without payload' do
            it { expect { call_service() }.to raise_error(ArgumentError) }
        end
    end
end