Repox
=====

This is a "practicing project" and a try to implement the
repository pattern with Elixir.

Please stay tuned for further (massive) changes.

## Github

  * [On Github](https://github.com/iboard/repox)

## Installation

    git clone https://github.com/iboard/repox.git
    cd repox
    cp config/dev.sample_exs config/dev.exs
    mix deps.get
    mix test --trace

## Configuration

There should be an environment file for each defined environment
(MIX_ENV, :test, :dev, :production.

Application specific configuration is done in section :repox

> (By now, only the Mongo db-connection is defined here)

### example config/dev.ex

    use Mix.Config

    config :repox,
      mongo_db_name: "dev",
      mongo_collection: "dev_collection"

All keys in this config definition are accessible through
`Repox.config(:key)` where valid keys are:

| Key name          | possible values & meaning              | example       |
|-------------------|----------------------------------------|---------------|
| :mongo_db_name    | any string valid as a mongo db-name    | 'addressbook' |
| :mongo_collection | any string valid as a mongo collection | 'people'      |


## Documentation

Run `mix docs` will generate documentation in `doc`
Then open `doc/index.html`

You may find an online-version of docs on
[static.iboard.cc](http://static.iboard.cc/repox/index.html)

## Concept

    +-----------------+                  +----------------+
    | GatewayProtocol | <--------------- | GatewayService |<<<<-API->>
    +-----------------+                  +----------------+
            ^
            |
            |---------------+--------------+
    +-------------+   +-------------+   +------+
    | ListGateway |   | FileGateway |   | .... |
    +-------------+   +-------------+   +------+

The _GatewayProtocol_ defines all functions needed for a persistence gateway.
_ListGateway_, _FileGateway_, and others (eg SQLGateway, MongoDBGateway,...)
must implement the functions defined in the _GatewayProtocol_.

The _GatewayService_ is an OTP _GenServer_ and implements mostly the same
functions as defined in the _GatewayProtocol_. It gets initialized with a
concrete _GatewayImplementation_ (_ListGateway_, ...).

The user of the _GatewayService_ then calls functions on the service doesn't
have to know how the _GatewayImplementation_ handles the persistence layer.

### Example:

    in_memory_store = %ListGateway{}
    file_store      = %FileGateway{path: "/path/to/file"}

    entry           = "Some data of any kind"

    {:ok, in_memory_service} = GatewayService.start_service(in_memory_store)
    {:ok, file_service}      = GatewayService.start_service(file_store)

    # Now save the entry to both services
    GatewayService.put(in_memory_service, entry)
    GatewayService.put(file_service, entry)

    # And get it back from the gateway
    enttries = GatewayService.where(in_memory_service, &( &1 != nil ))
    # or
    entries  = GatewayService.where(file_service, &( &1 != nil ))

As you can see there is no difference in using the service with either a
_ListGateway_ or _FileGateway_, or any other implementation.

"&(&1 != nil)" if you new to Elixir this definition will confuse you a bit.
`&()` defines an anonymous function and `&1` in `&1 != nil` means the first
parameter passed to the function.
This anonymous function gets passed through to the gateway's filter function.
The gateway implementation iterates all entries and will filter all of them
where the entry (`&1`) fulfills the condition ` != nil`.

Assuming our `entry` is a structure like `%{ id: 12, value: "something" }` you
can pass a filter like `&1( &1.id == 12 )`

## Benchmarks

To run benchmarks do

    mix bench

    ## BenchmarksBench
    [21:07:46] 0/3: 100x put to a Mongo collection
    [21:07:58] 0/3: 100x put to a Memory List
    [21:07:59] 0/3: 100x put to a File List

    Finished in 16.89 seconds

    ## BenchmarksBench
    100x put to a Memory List             1000   1498.35 µs/op
    100x put to a Mongo collection         500   22170.77 µs/op
    100x put to a File List                  1   3204996.00 µs/op


## License

Copyright (C) 2015 Andreas Altendorfer, <andreas@altendorfer.at>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


