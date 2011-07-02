# Damper

## CodebaseHQ meets Campfire. With better messages.

### Configuration

The following environment variables need to be set:

  - `CAMPFIRE_SUBDOMAIN`

    The subdomain under campfirenow.com (e.g. 'example' for example.campfirenow.com)

  - `CAMPFIRE_TOKEN`

    The API token for the user you wish Damper to post under.

  - `CAMPFIRE_ROOM_NAME`

    The room name under your subdomain where you wish Damper to post. (e.g. Development)

  - `CAMPFIRE_SSL`

    A boolean SSL connection flag. Defaults to `false`. (Acceptable values: `true`, `false`)

  - `AUTH_USERNAME` and `AUTH_PASSWORD`

    The credentials that Codebase will use when POSTing to Damper
