# Technical Assessment for e-Core
This project is a technical assessment for a Senior Ruby on Rails Developer position on
[e-Core](https://www.e-core.com/). The test statement can be found [here](./docs/technical-test-statement.md)
in Markdown or [here](./docs/technical-test-statement.pdf) in PDF.

## Technical Info
This project uses these tools:
- Docker
- Ruby 3.2.2
- Rails 7.1.3.4
- PostgreSQL 16
- Redis 7

## Executing on your machine
All project is dockerized, so you only need to  have docker installed. After setting up with `docker compose up` you
can check that it is up on [localhost:3000](http://localhost:3000)

#### Docker Compose commands
- Prepare docker images and containers:
```sh
docker compose build
```

- Run all services:
```sh
docker compose up
```

- Populate database with some random data:
```sh
docker compose exec api bin/bundle exec rake db:populate_roles
# Note: When you run the application for the first time, there will be no data
#       persisted as we rely on the external API to populate it. Use can use
#       this rake task as a "custom seeds".
```

- Rails console:
```sh
docker compose exec api bin/rails c
```

- Run tests:
```sh
docker compose exec api bin/rspec
# This will also generate a coverage/index.html file.
# Access to check the project's test coverage.
```

- Watch jobs queue (with sidekiq) log:
```sh
tail -f log/sidekiq.log
```

## Testing
This project has 100% test coverage. You can check this by running
`docker compose exec api bin/rspec` and then accessing the generated
[coverage/index.html](./coverage/index.html)

### Using API client tools
You can check the endpoints with tools like [Postman](https://www.postman.com/) or
[Insomnia](https://insomnia.rest/). Use the command
`docker compose exec api bin/bundle exec rake db:populate_roles` to generate some random data and
have something to see on the endpoints.

#### Available endpoints
- `GET /roles` → List all roles
   ```sh
   # example with curl
   curl --request GET \
        --header 'Content-Type: application/json' \
        --url http://localhost:3000/roles
   ```
- `POST /roles` → Create a role
   ```sh
   # example with curl
   curl --request POST \
        --url http://localhost:3000/roles \
        --header 'Content-Type: application/json' \
        --data '{"role": {"team_id": "7676a4bf-adfe-415c-941b-1739af07039b", "user_id": "b12fa35a-9c4c-4bf9-8f32-27cf03a1f190", "ability": "Developer"}}'
   ```
- `GET /roles/:id` → Find a role by its id
   ```sh
   # example with curl
   curl --request GET \
        --header 'Content-Type: application/json' \
        --url http://localhost:3000/roles/1
   ```
- `PUT/PATCH /roles/:id` → Update a role
   ```sh
   # example with curl
   curl --request POST \
        --url http://localhost:3000/roles/1 \
        --header 'Content-Type: application/json' \
        --data '{"role": {"ability": "Tester"}}'
   ```
- `DELETE /roles/:id` → Delete a role
   ```sh
   # example with curl
   curl --request DELETE \
        --header 'Content-Type: application/json' \
        --url http://localhost:3000/roles/1
   ```
- `GET /roles/team/:team_id` → List roles related with a specific Team
   ```sh
   # example with curl
   curl --request GET \
        --header 'Content-Type: application/json' \
        --url http://localhost:3000/roles/team/7676a4bf-adfe-415c-941b-1739af07039b
   ```
- `GET /roles/user/:user_id` → List roles related with a specific User
   ```sh
   # example with curl
   curl --request GET \
        --header 'Content-Type: application/json' \
        --url http://localhost:3000/roles/user/ee91a519-fefa-48a7-bdf7-672bde38aef9
   ```
- `GET /roles/ability/:ability` → List roles with a specific ability
   ```sh
   # example with curl
   curl --request GET \
        --header 'Content-Type: application/json' \
        --url http://localhost:3000/roles/ability/Product%20Owner
   ```
- `GET /roles/membership/:team_id/:user_id` → Find a role by its User and Team
   ```sh
   # example with curl
   curl --request GET \
        --header 'Content-Type: application/json' \
        --url http://localhost:3000/roles/membership/7676a4bf-adfe-415c-941b-1739af07039b/ee91a519-fefa-48a7-bdf7-672bde38aef9
   ```

## A little explaining
In the test statement, we have "Follow the case instructions; they are intentionally vague to allow
for your interpretation". So here are some interpretations and decisions that I made for this project.

### Model structure
A `Role` is Rails model that needs a `team_id`, a `user_id` and a `ability`, which is an enum also
defined in PostgreSQL, as you can see in the [migration](./db/migrate/20240627190019_create_roles.rb).
These three attributes must be unique for each `Role`.

With this, a member (User) of a Team can be a "Developer", a "Product Owner", a "Tester" or a
combination of these three (they can have one or more roles per Team).

### Users that belong to a Team
When we hit the external API for a specific team, we get something like:
```json
{
  "id": "7676a4bf-adfe-415c-941b-1739af07039b",
  "name": "Ordinary Coral Lynx",
  "teamLeadId": "b12fa35a-9c4c-4bf9-8f32-27cf03a1f190",
  "teamMemberIds": [
    "371d2ee8-cdf4-48cf-9ddb-04798b79ad9e",
    "54383a18-425c-4f50-9424-1c4c27e776dd",
    "e0dba3dc-313d-4648-bd9c-4ddc8b189e84",
    "b047d3f4-3469-47ce-a03f-1637a6de036b",
    "ee91a519-fefa-48a7-bdf7-672bde38aef9",
    "197c2b23-1218-44d0-b6b8-d757ba004515",
    "e947058e-2d5f-47d9-925b-27bcab14c38e"
  ]
}
```
Since a Team Leader is also a member of their team, I've also considered them as a member.

### Required actions via REST
In the test statement, we have:
> The new Roles service should be able to do the following actions via REST:
> - Create a new role
> - Assign a role to a team member
> - Look up a role for a membership
>
> 3) A membership is defined by a user ID and a team ID
> - Look up memberships for a role

These actions are served by the following endpoints:
- Create a new role: `POST /roles`
- Assign a role to a team member: `POST /roles`
- Look up a role for a membership: `GET /roles/user/:user_id`
- Look up memberships for a role: `GET /roles/ability/:ability` and `GET /roles/ability/:ability/:team_id` (###MISSING!)

"Create a new role" and "Assign a role to a team member" share the same endpoint because of the
model structure I'm using - you always need a `team_id` and a `user_id` to assign/create a role.

### "What happens if the data you are using gets deleted?"
To address this question, I've created a Sidekiq Job that runs every 5 minutes (this scheduling can
be changed in [config/schedule.yml](./config/schedule.yml)).

This job, `ExternalDataSyncJob`, goes through all existing roles and checks the following:
- if `user_id` still exists on the external application,
- if `team_id` still exists on the external application,
- and if `user_id` is still part of its `team_id`.

It removes the role if it fails in one or more of these checks.
