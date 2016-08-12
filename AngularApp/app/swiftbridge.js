'use strict';

angular.module('myApp.swiftbridge', []).factory('SwiftBrigde', ['$q', '$rootScope', function($q, $rootScope) {
    
    // with TypeScript, this should be an array of well-defined interfaces/objects
    var promises = {};

    var callOnSwift = function(message, data) {
        var deferred = $q.defer();

        try {
            var somethingUnique = new Date().getTime();
            promises[somethingUnique] = deferred; 
            console.log("Calling Swift with a message and some data, waiting on promise to resolve...");
            webkit.messageHandlers.callbackHandler.postMessage({
                'message': message,
                'data': data,
                'unique': somethingUnique
            });

        } catch (err) {
            console.log('The native context does not exist yet', err);
            // we need to reject the promise etc ... 
        }

        return deferred.promise;
    };

    $rootScope.$on('eventFromSwift', function(event, data) {
        var somethingUnique = data['unique'];
        var promise = promises[somethingUnique];
        promise.resolve(data);
        promises[somethingUnique] = undefined; // delete better?
    });

    return {
        callOnSwift: callOnSwift
    }
}]);