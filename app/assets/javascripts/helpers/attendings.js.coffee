Helpers.EJS ||= {}

Helpers.EJS.classFromAttendStatus =
  undefined: 'btn-primary'
  'YES': 'btn-success'
  'MAYBE': 'btn-warning'
  'NO': 'btn-danger'

Helpers.EJS.displayAttendStatus =
  undefined: 'Attend'
  'YES': 'Going'
  'MAYBE': 'Maybe'
  'NO': 'Not Going'
