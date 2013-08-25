import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import FakeSubmission ( thisIsTrue )

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

test_thisPasses :: Assertion
test_thisPasses = True @=? thisIsTrue

fakeSubmissionTests :: [Test]
fakeSubmissionTests = [ testCase "this passes" test_thisPasses ]

main :: IO ()
main = void (runTestTT (TestList fakeSubmissionTests))