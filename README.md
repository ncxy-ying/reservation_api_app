# Reservation API app

This is a purely API reservation application written using Ruby on Rails. The main feature of this application is to parse data from different formats (currently it support 2 formats).

## Highlight

The features are written in a reusable manner. There are 2 models in this application, which is `Guest` and `Reservation`. `Guest` is to record guest information and `Reservation` is to record booking information for guests. For example, booking service is to differentiate payload format, parse the data and save into database. Upsert `Guest` and `Reservation` services are written in a reusable way which allow different payload to upsert information after data parsing.

## Setup and run the project

```
# create database
$ rake db:create

# run migration
$ rake db:migrate

# install gem
$ bundle install

# run test
bundle exec rspec

# start server
$ rails s
```

## Try it out

'POST' to this API end point (`/api/v1/reservations/book/`) with payload to create or update reservation infomation.

Example payload format:

payload format 1:

```
{
	"reservation_code": "YYY12345678",
	"start_date": "2021-04-14",
	"end_date": "2021-04-18",
	"nights": 4,
	"guests": 4,
	"adults": 2,
	"children": 2,
	"infants": 0,
	"status": "accepted",
	"guest": {
		"first_name": "Wayne",
		"last_name": "Woodbridge",
		"phone": "639123456789",
		"email": "wayne_woodbridge@bnb.com"
	},
	"currency": "AUD",
	"payout_price": "4200.00",
	"security_price": "500",
	"total_price": "4700.00"
}
```

payload format 2:

```
{
	"reservation": {
		"code": "XXX12345678",
		"start_date": "2021-03-12",
		"end_date": "2021-03-16",
		"expected_payout_amount": "3800.00",
		"guest_details": {
			"localized_description": "4 guests",
			"number_of_adults": 2,
			"number_of_children": 2,
			"number_of_infants": 0
		},
		"guest_email": "wayne_woodbridge@bnb.com",
		"guest_first_name": "Wayne2",
		"guest_last_name": "Woodbridge",
		"guest_phone_numbers": [
			"639123456789",
			"639123456789"
			],
		"listing_security_price_accurate": "500.00",
		"host_currency": "AUD",
		"nights": 4,
		"number_of_guests": 4,
		"status_type": "accepted",
		"total_paid_amount_accurate": "4300.00"
	}
}
```

Success response code is `200` while failed response code is return `422`

## Find related files at

1. End point API controller:

`app/controllers/api/v1/reservations_controller.rb`


2. Upsert Guest Service:

`app/lib/feature/guest/upsert.rb`


3. Reservation Services:

`app/lib/feature/reservation/`
* `airbnb_parse.rb`
* `book.rb`
* `bookcom_parse.rb`
* `upsert.rb`


4. Guest Service Test files:

`spec/lib/feature/guest/`


5. Reservation Service Test files:

`spec/lib/feature/reservation/`
* `airbnb_parse_spec.rb`
* `book_spec.rb`
* `bookcom_parse_spec.rb`
* `upsert_spec.rb`


