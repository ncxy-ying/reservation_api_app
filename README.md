# Reservation API app

## Setup

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

POST to this API end point (`/api/v1/reservations/book/`) with payload to create or update reservation infomation.

Example payload format:

payload 1:
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

payload 2:
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

## Find related files at

End point API controller:

`app/controllers/api/v1/reservations_controller.rb`


Upsert Guest Service:

`app/lib/feature/guest/upsert.rb`


Reservation Services:

`app/lib/feature/reservation/`
* `airbnb_parse.rb`
* `book.rb`
* `bookcom_parse.rb`
* `upsert.rb`


Guest Service Test files:

`spec/lib/feature/guest/`


Reservation Service Test files:

`spec/lib/feature/reservation/`
* `airbnb_parse_spec.rb`
* `book_spec.rb`
* `bookcom_parse_spec.rb`
* `upsert_spec.rb`


