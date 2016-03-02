# Server Status

[![Code Climate](https://codeclimate.com/github/jamesbrooks/server-status.png)](https://codeclimate.com/github/JamesBrooks/git-runner)
[![Gem Version](https://badge.fury.io/rb/server-status.png)](http://badge.fury.io/rb/git-runner)
[![Dependency Status](https://gemnasium.com/jamesbrooks/server-status.png)](https://gemnasium.com/JamesBrooks/git-runner)

Command line tool for quickly fetching and displaying vital host metrics.

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
