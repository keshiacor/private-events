# Private Events

## Description

Private Events is a Rails application built as part of The Odin Project curriculum. The app allows users to create and attend private events much like Eventbrite.

## 🌟 Demo

- Coming soon – once deployed, a live demo link will be added here.

## Getting Started

- Clone the repository

```bash
git clone https://github.com/keshiacor/private-events.git
```

- Navigate into the project directory

```bash
cd private-events
```

- Install Ruby gems

```bash
bundle install
```

- Set up the database (create, migrate, and seed if needed)

```bash
bin/rails db:prepare
```

- Start the Rails server

```bash
bin/rails server
```

- Open the app in your browser

Visit `http://localhost:3000` and sign up for an account to start creating events.

## Technologies

- Ruby on Rails 8.1 – Web framework used to build the application.
- SQLite3 – Default development and test database.
  TDB

## Features

- Users can create multiple events.
- Users can attend events they've created or events they've been invited to.
- A user can invite other users to their events.
- A user can only see events they have created or events they are attending.
- A user can rescind an invitation they have sent to another user.
- A user can edit or delete an event they have created.
- An event has multiple attendees.
- An event has a date and a location displayed as a string.
- Authentication system for users to sign up and log in using Devise.

## Important Dependencies

- Devise – Used for user authentication and management.
- RSpec – Used for testing the application.
- Stymulus – Used for styling the application.
