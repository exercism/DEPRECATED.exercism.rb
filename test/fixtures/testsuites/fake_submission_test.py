try:
    import fake_submission
except ImportError:
    raise SystemExit('Could not find fake_submission.py. Does it exist?')

import unittest

class FakeSubmissionTests(unittest.TestCase):

    def test_this_passes(self):
        self.fake_submission = fake_submission.FakeSubmission()
        self.assertTrue(
            self.fake_submission.this_is_true()
        )

if __name__ == '__main__':
    unittest.main()
