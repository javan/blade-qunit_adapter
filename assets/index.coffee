#= require ./vendor/qunit

QUnit.config.hidepassed = true
QUnit.config.testTimeout = 5000

QUnit.begin (suiteDetails) ->
  Blade.suiteBegin(total: suiteDetails.totalTests)

failedAssertions = []

QUnit.testStart (testDetails) ->
  failedAssertions = []

QUnit.log (assertionDetails) ->
  unless assertionDetails.result
    failedAssertions.push(assertionDetails)

QUnit.testDone (testDetails) ->
  name = "#{testDetails.module}: #{testDetails.name}"
  pass = testDetails.failed is 0
  message = formatAssertions(failedAssertions)
  Blade.testResult({name, pass, message})

QUnit.done (suiteDetails) ->
  window.global_test_results = suiteDetails
  Blade.suiteEnd(suiteDetails)

formatAssertions = (assertions = []) ->
  if assertions.length
    (formatAssertion(assertion) for assertion in assertions).join("\n---\n")

formatAssertion = ({message, actual, expected, source}) ->
  lines = []
  if message
    lines.push("Message: #{JSON.stringify(message)}")
  if expected
    lines.push("Expected: #{JSON.stringify(expected)}")
  if actual
    lines.push("Actual: #{JSON.stringify(actual)}")
  if source
    lines.push("Source:")
    for sourceLine in source.split("\n").slice(0,3)
      lines.push("  #{sourceLine.trim()}")
  lines.join("\n")
