# TimeTracking

Project to push all [Toggl](https://toggl.com) entries to [FastBill](https://www.fastbill.com).

## Caveats

This project solely works with the 2 mentioned service and it needs [Zapier](https://zapier.com) as a middle layer to push the changed.

It only works if the time slot that you push has a project and a client set.

Needs a paid subsciption for Toggl as the billable flag needs to be set to 'True'. [Ping me](http://twitter.com/leifg) if you need it working on the free plan of toggl.

## Zapier Request

This is a sample request from Zapier that needs to be posted to `/time_slots`

```json
{
  "duronly": "False",
  "wid": "1224731",
  "uid": "2210123",
  "stop": "2016-05-09T00:45:00+00:00",
  "pid": "16196625",
  "project": {
    "auto_estimates": "False",
    "wid": "1224731",
    "name": "Test Project",
    "cid": "18457982",
    "color": "4",
    "created_at": "2016-05-08T17:39:10+00:00",
    "actual_hours": "4",
    "client": {
      "at": "2016-05-04T15:49:58+00:00",
      "wid": "1224731",
      "id": "18457982",
      "name": "Zapier Test"
    },
    "at": "2016-05-08T17:39:10+00:00",
    "template": "False",
    "billable": "False",
    "active": "True",
    "id": "16196625",
    "is_private": "True"
  },
  "start": "2016-05-08T20:45:00+00:00",
  "duration_minutes": "240",
  "at": "2016-05-08T20:45:55+00:00",
  "workspace": {
    "profile": "0",
    "rounding_minutes": "0",
    "premium": "False",
    "name": "Leif's workspace",
    "default_hourly_rate": "0",
    "rounding": "1",
    "at": "2016-04-14T17:37:47+00:00",
    "admin": "True",
    "ical_enabled": "True",
    "only_admins_see_team_dashboard": "False",
    "only_admins_see_billable_rates": "False",
    "api_token": "68ef374f647d2ed597bdb0fb34e8f4e3",
    "projects_billable_by_default": "True",
    "default_currency": "USD",
    "only_admins_may_create_projects": "False",
    "id": "1224731",
    "subscription": {
      "vat_invalid_accepted_by": "",
      "workspace_id": "0",
      "vat_valid": "False",
      "created_at": "0001-01-01T00:00:00Z",
      "updated_at": "",
      "vat_applicable": "False",
      "vat_validated_at": "",
      "vat_invalid_accepted_at": "",
      "deleted_at": "",
      "description": "Free"
    }
  },
  "billable": "False",
  "duration": "14400",
  "duration_hours": "4.0",
  "guid": "61522395-2cc8-4258-b147-f360d0f8d598",
  "id": "328483967",
  "duration_readable": "04:00:00"
}
```

The following fields are relevant:

  - `start`: start time of time slot
  - `stop`: end time of time slot
  - `duration_minutes`: duration in minutes (will be set as 100% billable in FastBill)
  - `description`: description of activitiy
  - `project.id`: ID that will be used to look up existing project in FastBill
  - `project.name`: Name of project
  - `project.client.id`: Id that will be used to look up existing client in FasBill
  - `project.client.name`: Name of client

## Authentication

This service uses Basic Authentication. No need to set an extra passwort, it will use the FastBill email as user and the token as password (same authentication that [FastBill uses](https://www.fastbill.com/api/#authentification))

## Setup

### Project

You can just deploy this project to Heroku as long as you have the [Elixir](https://github.com/HashNuke/heroku-buildpack-elixir) and [Phoenix](https://github.com/gjaldon/heroku-buildpack-phoenix-static) buildpack installed.
It uses a [Semantic Release](https://github.com/semantic-release/semantic-release) Hook to deploy.

You need to however change thos details to customize to your needs:

  - Heroku Repo in [package.json](https://github.com/leifg/time_tracking/blob/master/package.json#L16)
  - SECRET_KEY_BASE env variable (you can create one via `mix phoenix.gen.secret`)
  - FASTBILL_EMAIL env variable
  - FASTBILL_TOKEN env variable
  - FASTBILL_TIMEZONE env variable (e.g. Europe/Berlin)

### Zapier

In order to receive changes you must configure a Zapier Webhook that pushes to time entries to your deployed application:

![Zapier Setup](/zapier-setup.png?raw=true)

Don't forget to set Basic Authentication User Password in the form `<FASTBILL_EMAIL>|<FASTBILL_TOKEN>`
