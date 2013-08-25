try:
    import failing_submission
except ImportError:
    raise SystemExit('Could not find failing_submission.py. Does it exist?')

import unittest

class FailingSubmissionTests(unittest.TestCase):

    def test_this_fails(self):
        self.failing_submission = failing_submission.FailingSubmission()
        self.assertTrue(
            self.failing_submission.this_is_false()
        )

if __name__ == '__main__':
    unittest.main()
