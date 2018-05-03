"use strict";

// module Projections

exports.when = function(eventname) {
  return function(eventhandler){
    var obj = {};
    obj[eventname] = function(state, event) {
      return eventhandler(state)(event);
    };
    return obj;
  };
};

exports.whenAny = function(eventhandler) {
  return {$any : function(s,e) {
    return eventhandler(s)(e);
  }};
};

exports.foreignAppend = function(folderA){
  return function(folderB){
    return mergeObjects(folderA, folderB);
  }
}

exports.runProjection = function(eventSource){
  return function(initialState){
    return function(opts){
      return function(folder){
        var handlers = mergeObjects({$init: function(){return initialState;}},folder);
        options(getOptions(opts,eventsource))
        return function() {
          var proj = getEventsource(eventSource).when(handlers);
          if(shouldOutputState(opts)){
            proj.outputState();
          }
        };
      };
    };
  };
};

var getOptions = function(opts, eventsource){
  if(isEventsourcetype(eventsource, exports.FromStreams)){
    return {
      resultStreamName: opts.resultStreamName,
      reorderEvents: eventsource.value0.reorderEvents,
      processingLag: eventsource.value0.processingLag 
    };
  }
  return {resultStreamName: opts.resultStreamName}
}

var shouldOutputState = function(opts){
  return opts.outputState;
};

var getEventsource = function (eventSource) {
  if(isEventsourcetype(eventSource, exports.FromStream)){
    return fromStream(eventSource.value0);
  } else if(isEventsourcetype(eventSource, exports.FromStreams)){
    return fromStreams(eventSource.value1);
  } else if(isEventsourcetype(eventSource, exports.ForEachInCategory)){
    return fromCategory(eventSource.value0).foreachStream();
  } else if(isEventsourcetype(eventSource, exports.FromCategory)){
    return fromCategory(eventSource.value0);
  } else if(isEventsourcetype(eventSource, exports.ForEach)){
    return fromAll().foreachStream();
  } 
  return fromAll();
};

var mergeObjects = function (obj1,obj2){
  var obj3 = {};
  for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
  for (var attrname2 in obj2) { obj3[attrname2] = obj2[attrname2]; }
  return obj3;
};

var isEventsourcetype = function(eventsource, expectedType) {
  return eventsource !== undefined && expectedType !== undefined && eventsource instanceof expectedType;
};
