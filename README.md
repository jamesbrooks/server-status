# Server Status

[![Gem Version](https://badge.fury.io/rb/server-status.svg)](http://badge.fury.io/rb/server-status)
[![Code Climate](https://codeclimate.com/github/jamesbrooks/server-status/badges/gpa.svg)](https://codeclimate.com/github/jamesbrooks/server-status)

Command line tool for quickly fetching and displaying vital host metrics.

![Screnshot](https://raw.github.com/jamesbrooks/server-status/master/screenshot.jpg)

## Installation

`gem install server-status`

## Usage

### Add a host

```sh
# Track a host (uses the host name as the friendly name)
server-status add ubuntu@server.net

# Track a host using a friendly name
server-status add ubuntu@server.net personal-server
```

### Remove a host

```sh
server-status remove personal-server
```

### List all hosts

```sh
server-status list
```

### Fetch statuses of all tracked hosts

```sh
server-status
```
