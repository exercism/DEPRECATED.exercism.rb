var FailingSubmission = require('./failing_submission');

describe("FailingSubmission", function() {
  var failingSubmission = new FailingSubmission();

  it("passes", function() {
    var result = failingSubmission.thisIsFalse();
    expect(result).toBeTruthy();
  });
});
