Helpers.EJS ||= {}

Helpers.EJS.classFromAttendStatus =
  undefined: 'btn-primary'
  'attending': 'btn-success'
  'unsure': 'btn-warning'
  'declined': 'btn-danger'

Helpers.EJS.displayAttendStatus =
  undefined: 'Attend'
  'attending': 'Going'
  'unsure': 'Maybe'
  'declined': 'Not Going'
