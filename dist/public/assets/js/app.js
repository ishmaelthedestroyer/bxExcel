var app;

app = angular.module('App', ['ui.router', 'ui.bootstrap', 'ngToolboxx']);

app.run([
  '$rootScope', '$state', '$stateParams', function($rootScope, $state, $stateParams) {
    $rootScope.$state = $state;
    return $rootScope.$stateParams = $stateParams;
  }
]);

app.config(function($stateProvider, $urlRouterProvider, $locationProvider) {
  $urlRouterProvider.otherwise('/404');
  return $locationProvider.html5Mode(true);
});

angular.element(document).ready(function() {
  return angular.bootstrap(document, ['App']);
});

app.config(function($stateProvider) {
  return $stateProvider.state('404', {
    url: '/404',
    templateUrl: '/routes/404/views/404.html'
  });
});

app.config(function($stateProvider) {
  return $stateProvider.state('index', {
    url: '/',
    templateUrl: '/routes/index/views/index.html'
  });
});

app.controller('IndexCtrl', [
  '$scope', '$state', '$q', 'bxNotify', 'bxLogger', 'bxQueue', function($scope, $state, $q, Notify, Logger, bxQueue) {
    var apply, b64, handleDragover, handleDrop, init, parseJSON, process_wb, resize, setDataSource, spread, toCSV, toJSON, xlsxworker;
    spread = null;
    setDataSource = function(data) {
      var cols, rows, sheet;
      sheet = spread.getActiveSheet();
      Logger.debug('Got sheet.', sheet);
      cols = sheet.getColumnCount();
      rows = sheet.getRowCount();
      sheet.setCsv(0, 0, data, "\n", ",", $.wijmo.wijspread.TextFileOpenFlags.None);
      if (sheet.getColumnCount() < cols) {
        sheet.setColumnCount(cols);
      }
      if (sheet.getRowCount() < rows) {
        return sheet.setRowCount(rows);
      }
    };
    xlsxworker = function(data, cb) {
      var worker;
      worker = new Worker('/assets/vendor/js-xlsx/js/xlsxworker.js');
      worker.onmessage = function(e) {
        switch (e.data.t) {
          case 'ready':
            break;
          case 'e':
            return console.error(e.data.d);
          case 'xlsx':
            parseJSON(e.data.d).then(function(result) {
              return cb(result);
            });
            break;
        }
      };
      /*
      Logger.debug 'Debugging data.', data
      arr = ''
      uintarray = new Uint8Array data
      arr += btoa String.fromCharCode(str) for str in uintarray
      
      worker.postMessage arr
      */

      return b64(data).then(function(arr) {
        return worker.postMessage(arr);
      });
    };
    parseJSON = function(data) {
      var deferred, p;
      deferred = $q.defer();
      p = new Parallel(data);
      p.spawn(function(d) {
        return JSON.parse(d);
      }).then(function(d) {
        Logger.debug('Parallel JSON parsing operation finished.', d);
        return deferred.resolve(d);
      });
      return deferred.promise;
    };
    toJSON = function(workbook) {
      var result;
      result = {};
      workbook.SheetNames.forEach(function(sheetName) {
        var roa;
        roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
        if (roa.length > 0) {
          return result[sheetName] = roa;
        }
      });
      return result;
    };
    toCSV = function(workbook) {
      var result;
      result = [];
      workbook.SheetNames.forEach(function(sheetName) {
        var csv;
        csv = XLSX.utils.sheet_to_csv(workbook.Sheets[sheetName]);
        if (csv.length > 0) {
          csv = csv.toString();
          return result.push(csv);
        }
      });
      return result[0];
    };
    b64 = function(data) {
      /*
      convert = (d) ->
        arr = ''
        uintarray = new Uint8Array d
        arr += btoa String.fromCharCode(str) for str in uintarray
        return arr
      
      if typeof Worker isnt 'undefined'
      */

      var deferred, p;
      deferred = $q.defer();
      p = new Parallel(data);
      p.spawn(function(d) {
        var arr, str, uintarray, _i, _len;
        arr = '';
        uintarray = new Uint8Array(d);
        for (_i = 0, _len = uintarray.length; _i < _len; _i++) {
          str = uintarray[_i];
          arr += btoa(String.fromCharCode(str));
        }
        return arr;
      }).then(function(d) {
        Logger.debug('Parallel operation finished.', d);
        return deferred.resolve(d);
      });
      return deferred.promise;
    };
    process_wb = function(wb) {
      return setDataSource(toCSV(wb));
      /*
      output = toJSON(wb)
      
      console.log
        output: output,
        sheet: output['Sheet1']
      setDataSource output['Sheet1']
      */

      /*
      if out.innerText is 'undefined'
        out.textContent = output
      else
        out.innerText = output
      */

    };
    handleDragover = function(e) {
      e.preventDefault();
      e.stopPropagation();
      return e.dataTransfer.dropEffect = 'copy';
    };
    handleDrop = function(e) {
      var file, files, _fn, _i, _len;
      e = e || window.event;
      files = e.files || e.dataTransfer.files;
      e.preventDefault();
      e.stopPropagation();
      _fn = function(file) {
        var reader;
        reader = new FileReader();
        reader.onload = function(e) {
          var arr, data, wb;
          data = e.target.result;
          if (typeof Worker !== 'undefined') {
            Logger.debug('Passing to worker.');
            return xlsxworker(data, process_wb);
          } else {
            Logger.debug('Working in browser.');
            arr = [];
            arr = String.fromCharCode.apply(null, new Uint8Array(data));
            wb = XLSX.read(btoa(arr), {
              type: 'base64'
            });
            return process_wb(wb);
          }
        };
        return reader.readAsArrayBuffer(file);
      };
      for (_i = 0, _len = files.length; _i < _len; _i++) {
        file = files[_i];
        _fn(file);
      }
      return false;
    };
    resize = function() {
      $('#ss').css({
        height: ($(window).height() - 50) + 'px',
        width: '100%'
      });
      return console.log($(window).height());
    };
    init = function() {
      var body, sheet;
      resize();
      $('#ss').wijspread({
        sheetCount: 3
      });
      spread = $('#ss').wijspread('spread');
      spread.useWijmoTheme = true;
      sheet = spread.getActiveSheet();
      if (sheet.getColumnCount() < 26) {
        sheet.setColumnCount(26);
      }
      if (sheet.getRowCount() < 26) {
        sheet.setRowCount(26);
      }
      body = document.getElementById('body');
      body.addEventListener('dragenter', handleDragover, false);
      body.addEventListener('dragover', handleDragover, false);
      body.addEventListener('drop', handleDrop, false);
      return $(window).resize(function() {
        return resize();
      });
    };
    init();
    return apply = function(scope, fn) {
      if (scope.$$phase || scope.$root.$$phase) {
        return fn();
      } else {
        return scope.$apply(fn);
      }
    };
  }
]);
