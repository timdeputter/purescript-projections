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
    return function(options){
      return function(folder){
        var handlers = mergeObjects({$init: function(){return initialState;}},folder);
        return function() {
          if(isOption(options,exports.OutputState)){
            options({resultStreamName: options.value0});
            getEventsource(eventSource).when(handlers).outputState();
          } else {
            getEventsource(eventSource).when(handlers);
          }
        };
      };
    };
  };
};

var isOption = function(options, expectedType){
  return options !== undefined && expectedType !== undefined && options instanceof expectedType;
};

var getEventsource = function (eventSource) {
  if(isEventsourcetype(eventSource, exports.FromStream)){
    return fromStream(eventSource.value0);
  } else if(isEventsourcetype(eventSource, exports.FromStreams)){
    return fromStreams(eventSource.value0);
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
