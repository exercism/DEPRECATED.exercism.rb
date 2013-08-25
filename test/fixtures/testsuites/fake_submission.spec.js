var FakeSubmission = require('./fake_submission');

describe("FakeSubmission", function() {
  var fakeSubmission = new FakeSubmission();

  it("passes", function() {
    var result = fakeSubmission.thisIsTrue();
    expect(result).toBeTruthy();
  });
});
