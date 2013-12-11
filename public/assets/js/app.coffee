app = angular.module 'App', [
  'ui.router'
  'ui.bootstrap'
  'ngToolboxx'
]

app.run [
  '$rootScope'
  '$state'
  '$stateParams'
  ($rootScope, $state, $stateParams) ->
    $rootScope.$state = $state
    $rootScope.$stateParams = $stateParams
]
