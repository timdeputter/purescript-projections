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
  main = runProjection (fromStream "chatroom") {count:0} defaultOptions $ when "UserJoined" handler 
```

Now build the project to a single javascript output file and upload the file as projection
to your eventstore installation:

```sh
$ pulp build -O --to projection.js
$ curl -i -d @projection.js http://127.0.0.1:2113/projections/transient?enabled=yes -u admin:changeit -H "Content-Type: application/json"
```


## Projection properties
The projections behaviour is defined by four basic properties, these are:


| Property          | description                                   | default  |
| ----------------- | --------------------------------------------- | -------- |
| resultstream name | The name of the outputstate stream.            | $projections-{projection-name}-result |
| include links     | Links to events in the source stream are processed. |   false |
| reorder events    | Process events by storing a buffer of events ordered by their prepare position.     |    false |
| processinglag     | 	 	When reorderEvents is turned on, this value is used to compare the total milliseconds between the first and last events in the buffer and if the value is equal or greater, the events in the buffer will be processed. The buffer is an ordered list of events.  | 500ms |

These properties are either controled via an options parameter passed to runProjections for general configurations (like resultstream name) or they are directly passed to the functions whichs behaviour is altered by the configuration parameter.

### Default Options
If you just want the default behaviour of projections pass defaultOptions to runProjections:
```purescript
  runProjection source initialState defaultOptions fold
```

### Output state
This controls wether an outputstate stream should be created and which name this stream should have:
```purescript
  runProjection source initialState (outputState "projection-state") fold
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
To select the events from a category call fromCategory with the name of the category. 
To run a seperate projection for each category call forEachInCategory.
```purescript
  fromCategory "category"
  forEachInCategory "category"
```

### From all streams
The function fromAll simply runs the projection for all streams in the database.
ForEach runs a seperate projection for each category.

## Handling events
Once the source of events is defined we can specifiy how to derive state from them, or - to say it in other words - 
how to 'fold' the events

### When
When produces eventhandler for events of the given eventname by applying a given function which takes a state s, an event e and produces a new state s. The following example derives the number of created accounts from the 'accountCreated' event.
```purescript
  when "accountCreated" (\s e -> {count: s.count+1})
```

## License

Check [LICENSE](LICENSE) file for more information.
