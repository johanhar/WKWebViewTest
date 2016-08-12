'use strict';

angular.module('myApp.view2', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/view2', {
    templateUrl: 'view2/view2.html',
    controller: 'View2Ctrl'
  });
}])

.controller('View2Ctrl', ['$scope', 'SwiftBrigde', function($scope, SwiftBrigde) {
  
  $scope.doMagic = function() {

    var message = 'Some message to swift';
    var data = {
      'stuff': 'very important stuff that needs to be delivered to swift'
    };

    SwiftBrigde.callOnSwift(message, data).then(function(data) {
      console.log('Promise returned', data);
    });

  }

}]);