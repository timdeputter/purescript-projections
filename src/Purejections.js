"use strict";

// module Projections

exports.when = function(eventname) {
  return function(eventhandler){
    var obj = {};
    obj[eventname] = function(state, event) {
      return eventhandler(state)(event);
    }
    return obj;
  };
};

exports.foreignAppend = function(folderA){
  return function(folderB){
    return mergeObjects(folderA, folderB);
  }
}

exports.runProjection = function(eventSource){
  return function(initialState){
    return function(folder){
      var handlers = mergeObjects({$init: function(){return initialState;}},folder);
      return function() {
        getEventsource(eventSource).when(handlers);
      }
    }
  }
}

var getEventsource = function (eventsource) {
  if(isEventsourcetype(eventSource, exports.FromStream)){
    return fromStream(eventSource.value0);
  } else if(isEventsourcetype(eventSource, exports.FromStreams)){
    return fromStreams(eventSource.value0);
  } else if(isEventsourcetype(eventSource, exports.ForEachInCategory)){
    return fromCategory(eventSource.value0).foreachStream();
  } 
  return fromAll().when(handlers);
}

var mergeObjects = function (obj1,obj2){
  var obj3 = {};
  for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
  for (var attrname in obj2) { obj3[attrname] = obj2[attrname]; }
  return obj3;
}

var isEventsourcetype = function(eventsource, expectedType) {
  return eventSource != undefined && eventSource instanceof expectedType;
}
