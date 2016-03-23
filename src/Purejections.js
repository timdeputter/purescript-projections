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

var merge_objects = function (obj1,obj2){
  var obj3 = {};
  for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
  for (var attrname in obj2) { obj3[attrname] = obj2[attrname]; }
  return obj3;
}

exports.foreignAppend = function(folderA){
  return function(folderB){
    return merge_objects(folderA, folderB);
  }
}


exports.runProjection = function(eventSource){
  return function(initialState){
    return function(folder){
      var handlers = merge_objects({$init: function(){return initialState;}},folder);
      return function() {
        if(exports.FromStream != undefined && eventSource instanceof exports.FromStream){
          fromStream(eventSource.value0).when(handlers);
        } else {
          fromAll().when(handlers)
        }
      }
    }
  }
}
