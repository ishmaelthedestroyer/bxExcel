app.controller 'IndexCtrl', [
  '$scope', '$state', '$q', 'bxNotify', 'bxLogger', 'bxQueue',
  ($scope, $state, $q, Notify, Logger, bxQueue) ->
    spread = null

    setDataSource = (data) ->
      sheet = spread.getActiveSheet()

      Logger.debug 'Got sheet.', sheet

      cols = sheet.getColumnCount()
      rows = sheet.getRowCount()

      sheet.setCsv 0, 0, data, "\n", ",",
        $.wijmo.wijspread.TextFileOpenFlags.None

      # retain num cols + rows
      if sheet.getColumnCount() < cols
        sheet.setColumnCount cols

      if sheet.getRowCount() < rows
        sheet.setRowCount rows

      # Logger.debug 'Debugging sheet.', sheet

    xlsxworker = (data, cb) ->
      worker = new Worker '/assets/vendor/js-xlsx/js/xlsxworker.js'
      worker.onmessage = (e) ->
        switch e.data.t
          when 'ready'
            break
          when 'e'
            console.error e.data.d
          when 'xlsx'
            # cb JSON.parse(e.data.d)
            parseJSON(e.data.d).then (result) ->
              cb result
            break

      ###
      Logger.debug 'Debugging data.', data
      arr = ''
      uintarray = new Uint8Array data
      arr += btoa String.fromCharCode(str) for str in uintarray

      worker.postMessage arr
      ###

      #arr = btoa(String.fromCharCode.apply(null, new Uint8Array(data)))
      # arr = data

      b64(data).then (arr) ->
        worker.postMessage arr

    parseJSON = (data) ->
      deferred = $q.defer()

      p = new Parallel data
      p.spawn (d) ->
        return JSON.parse(d)
      .then (d) ->
        Logger.debug 'Parallel JSON parsing operation finished.', d
        deferred.resolve d

      return deferred.promise


    toJSON = (workbook) ->
      result = {}
      workbook.SheetNames.forEach (sheetName) ->
        roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName])
        if roa.length > 0
          result[sheetName] = roa

      return result

    toCSV = (workbook) ->
      result = []
      workbook.SheetNames.forEach (sheetName) ->
        csv = XLSX.utils.sheet_to_csv(workbook.Sheets[sheetName])

        if csv.length > 0
          # result.push "SHEET: " + sheetName
          # result.push ""
          csv = csv.toString()
          # csv = csv.toString().split "\n"
          # csv = csv.join ';'
          result.push csv
          #result.join ';'

      # result.join "\n"
      return result[0]

    b64 = (data) ->
      ###
      convert = (d) ->
        arr = ''
        uintarray = new Uint8Array d
        arr += btoa String.fromCharCode(str) for str in uintarray
        return arr

      if typeof Worker isnt 'undefined'
      ###
      deferred = $q.defer()

      p = new Parallel data
      p.spawn (d) ->
        arr = ''
        uintarray = new Uint8Array d
        arr += btoa String.fromCharCode(str) for str in uintarray
        return arr
      .then (d) ->
        Logger.debug 'Parallel operation finished.', d
        deferred.resolve d

      return deferred.promise

    process_wb = (wb) ->
      setDataSource toCSV wb
      # output = JSON.stringify toJSON(wb), 2, 2

      ###
      output = toJSON(wb)

      console.log
        output: output,
        sheet: output['Sheet1']
      setDataSource output['Sheet1']
      ###

      ###
      if out.innerText is 'undefined'
        out.textContent = output
      else
        out.innerText = output
      ###

    handleDragover = (e) ->
      e.preventDefault()
      e.stopPropagation()
      e.dataTransfer.dropEffect = 'copy'

    handleDrop = (e) ->
      e = e || window.event
      files = e.files || e.dataTransfer.files

      e.preventDefault()
      e.stopPropagation()

      for file in files
        ((file) ->
          reader = new FileReader()

          reader.onload = (e) ->
            data = e.target.result
            if typeof Worker isnt 'undefined'
              Logger.debug 'Passing to worker.'
              xlsxworker data, process_wb
            else
              Logger.debug 'Working in browser.'
              arr = []
              arr = String.fromCharCode.apply null, new Uint8Array(data)
              wb = XLSX.read(btoa(arr), {type: 'base64'})
              process_wb wb

          # read file
          reader.readAsArrayBuffer file
          # reader.readAsDataURL file
        ) file

      return false

    resize = () ->
      $('#ss').css
        height: ($(window).height() - 50) + 'px'
        width: '100%'

      console.log $(window).height()

    init = () ->
      # fit container to screen
      resize()

      # init spreadsheet
      $('#ss').wijspread
        sheetCount: 3

      spread = $('#ss').wijspread 'spread'
      spread.useWijmoTheme = true

      # set min columns + rows
      sheet = spread.getActiveSheet()

      if sheet.getColumnCount() < 26
        sheet.setColumnCount 26

      if sheet.getRowCount() < 26
        sheet.setRowCount 26

      # init drag + drop events
      body = document.getElementById 'body'
      body.addEventListener 'dragenter', handleDragover, false
      body.addEventListener 'dragover', handleDragover, false
      body.addEventListener 'drop', handleDrop, false

      # resize spreadsheet on window resize
      $(window).resize -> resize()

    # call initialize function
    init()

    apply = (scope, fn) ->
      if scope.$$phase or scope.$root.$$phase
        fn()
      else
        scope.$apply fn
]
