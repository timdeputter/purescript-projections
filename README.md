purescript-projections [![License](http://img.shields.io/hexpm/l/Rendezvous.svg?style=flat)](https://github.com/timdeputter/purescript-projections/blob/master/LICENSE)
==========

Purescript bindings to the [geteventstore](http://geteventstore.com) projections library.

## Why
Purescript is a pure functional strongly typed programming language which compiles to javascript. 
With purescript-projections you can write your eventstore projections in a pure functional and typesafe
manner to guarantee more correctness and safety. And to make awesomeness more awesome, purescript ships
with a haskell style quickcheck implementation, which means you can leverage property-based tests to
make working with projections even more awesome!

## Installation
Install purescript-projections with bower:

```sh
$ bower install purescript-projections
```

## Getting started

To write an eventstore projection in purescript first of all you have to model your events and your state:
```purescript
  type UserJoined = {username:: String, id:: Int}
  type State = {count:: Int}
```
then write a function which takes an event and a state and produces a new state:
```purescript
  handler :: State -> UserJoined -> State
  handler s e = {count: s.count+1}
```
In main call runProjection with name of the eventstream, the inital state and the handler like this:
```purescript
  main = runProjection (fromStream "chatroom") {count:0} $ when "UserJoined" handler 
```

Now build the project to a single javascript output file and upload the file as projection
to your eventstore installation:

```sh
$ pulp build -O --to projection.js
$ curl -i -d @projection.js http://127.0.0.1:2113/projections/transient?enabled=yes -u admin:changeit -H "Content-Type: application/json"
```

## Selecting streams

There is a variaty of ways to select events from different streams.

### Single stream
To select events from a single stream call fromStream with the name of the stream to select the events from:
```purescript
  fromStream "chatroom"
```

### Multiple streams
To select events from multiple streams call fromStreams with an Array of the names of the streams:
```purescript
  fromStreams ["chatroom", "lobby"]
```

### From category
To select the events from a category call fromCategory with the name of the category. The projection is
run for each stream in the category.
```purescript
  fromCategory "category"
```

### From all streams
The function fromAll simply runs the projection for all streams in the database.

## Handling events
Once the source of events is defined we can specifiy how to derive state from them, or - to say it in other words - 
how to 'fold' the events

### When
When produces eventhandler for events of the given eventname by applying a given function which takes a state s, an event e and produces a new state s.
```purescript
  when("accountCreated", \s e -> s + e)
```

## License

Check [LICENSE](LICENSE) file for more information.
