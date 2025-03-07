# Pet Tracking Application

Application that calculates the number of pets (dogs and cats) outside of the
power saving zone based on data from different types of trackers. There are two types of
trackers for cats (small and big) and three for dogs (small, medium, big).

## Setup

1. Clone the repository
2. Run `bundle install`
3. Run `rails db:migrate`
4. Run `rails server` or `bin/dev`

## Testing

```bash
bundle exec rspec
```

## Linting

```bash
bin/rubocop -A
```

## Coverage

```bash
bundle exec rspec --format json --out coverage/coverage.json
```

## Usage

Create Pet - Cat

```bash
curl -X POST -H "Content-Type: application/json" -d '{
  "pet": {
    "pet_type": "Cat",
    "tracker_type": "small",
    "owner_id": 1,
    "in_zone": false,
    "lost_tracker": false
  }
}' http://localhost:3000/api/pets
```

Create Pet - Dog

```bash
curl -X POST -H "Content-Type: application/json" -d '{
  "pet": {
    "pet_type": "Dog",
    "tracker_type": "medium",
    "owner_id": 2,
    "in_zone": true
  }
}' http://localhost:3000/api/pets
```

List of Pets - `pets#index`

```bash
curl http://localhost:3000/api/pets
```

Single Pet - `pets#show`

```bash
curl http://localhost:3000/api/pets/1
```

Get number of Pets outside the power saving zone - `pets#outside_zone`

```bash
curl http://localhost:3000/api/pets/outside_zone
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
