import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import FailingSubmission ( thisIsFalse )

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

test_thisFails :: Assertion
test_thisFails = True @=? thisIsFalse

failingSubmissionTests :: [Test]
failingSubmissionTests = [ testCase "this fails" test_thisFails ]

main :: IO ()
main = void (runTestTT (TestList failingSubmissionTests))