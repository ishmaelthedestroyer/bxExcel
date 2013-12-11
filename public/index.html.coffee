doctype 5
html 'ng-controller':'bxCtrl', ->
  head ->
    title 'Bears | Excel'
    meta name:'description', content:'Topolabs | 3D Rendering + Printing'
    meta 'http-equiv':'X-UA-Compatabile', content:'IE=edge,chrome=1'
    meta name:'keywords', content:''
    meta charset:'utf-8'
    base href:'/'
    link media:'screen', rel:'stylesheet', href:'/assets/css/app.css'
    link media:'screen', rel:'stylesheet', href:'/assets/vendor/bootstrap/dist/css/bootstrap.css'
    link media:'screen', rel:'stylesheet', href:'/assets/vendor/ngToolboxx/dist/css/ngToolboxx.css'

    link media:'screen', rel:'stylesheet', href:'http://cdn.wijmo.com/themes/aristo/jquery-wijmo.css'
    link media:'screen', rel:'stylesheet', href:'http://cdn.wijmo.com/spreadjs/jquery.wijmo.wijspread.1.20133.6.css'
    ###
    link media:'screen', rel:'stylesheet', href:'/assets/vendor/Wijmo-Spread/css/cobalt/jquery-wijmo.css'
    link media:'screen', rel:'stylesheet', href:'/assets/vendor/Wijmo-Spread/css/jquery.wijmo.wijsuperpanel.css'
    link media:'screen', rel:'stylesheet', href:'/assets/vendor/Wijmo-Spread/css/gcfilter-ui.css'
    ###

    script src:'http://code.jquery.com/jquery-1.9.1.min.js'
    script src:'http://code.jquery.com/ui/1.10.1/jquery-ui.min.js'

    script src:'/assets/vendor/bootstrap/dist/js/bootstrap.js'
    script src:'/assets/vendor/angular/angular.js'
    script src:'/assets/vendor/angular-ui-router/release/angular-ui-router.js'
    script src:'/assets/vendor/angular-resource/angular-resource.js'
    script src:'/assets/vendor/angular-bootstrap/ui-bootstrap.js'
    script src:'/assets/vendor/angular-bootstrap/ui-bootstrap-tpls.js'

    # script src:'/assets/vendor/Wijmo-Spread/scripts/jquery.wijmo.wijspread.full.min.js'
    script src:'http://cdn.wijmo.com/spreadjs/jquery.wijmo.wijspread.all.1.20133.6.min.js'

    script src:'/assets/vendor/js-xlsx/js/jszip.js'
    script src:'/assets/vendor/js-xlsx/js/xlsx.js'

    script src:'/assets/vendor/parallel.js/parallel.js'

    script src:'/assets/vendor/ngToolboxx/dist/js/ngToolboxx.js'
    script src:'/assets/js/app.js'
  body '#body', ->
    div '.notification-container.ng-cloak', ->
      div class:'alert alert-dismissable alert-{{notification.type}}',
      'ng-repeat':'notification in notifications', ->
        button '.close', type:'button', 'aria-hidden':'true',
        'ng-click':'removeNotification($index)', ->
          text '&times;'
        text '{{notification.message}}'

    div '.loading-container.ng-cloak', 'ng-class':'{hidden: queue.length == 0}', ->

    nav '.navbar.navbar-fixed-top', role: 'navigation', ->
      div '.navbar-header', ->
        button '.navbar-toggle', type: 'button', 'data-toggle': 'collapse', 'data-target': '#navbar-collapse-1', ->
          span '.sr-only', 'Toggle navigation'
          span '.icon-bar', ->
          span '.icon-bar', ->
          span '.icon-bar', ->
        a '.navbar-brand.text-white', href: '/', ->
          img '.logo', src:'/assets/img/logo.png'
          em 'Bears | Excel'
      div '#navbar-collapse-1.collapse.navbar-collapse', style:'padding: 0 10px 0 10px;', ->
        ul '.nav.navbar-nav.navbar-right', ->
          li ->
            a href: '/about', ->
              em 'about'
          li ->
            a href: '/contact', ->
              em 'contact'

    div '.clear-50', ->
    div 'ui-view':' ', ->
      div '.loading-large', ->

    div '.clear-20', ->
