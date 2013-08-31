import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts (failures, errors))
import Control.Monad (void)
import System.Exit (ExitCode (ExitSuccess, ExitFailure), exitWith)
import FakeSubmission ( thisIsTrue )

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

test_thisPasses :: Assertion
test_thisPasses = True @=? thisIsTrue

fakeSubmissionTests :: [Test]
fakeSubmissionTests = [ testCase "this passes" test_thisPasses ]

testsPass :: Counts -> Bool
testsPass testcounts = and [failures testcounts == 0,
                            errors   testcounts == 0]

exitStatus :: Counts -> ExitCode
exitStatus testcounts
  | testsPass testcounts = ExitSuccess
  | otherwise            = ExitFailure 1

main :: IO ()
main = do
  result <- runTestTT (TestList failingSubmissionTests)
  exitWith (exitStatus result)