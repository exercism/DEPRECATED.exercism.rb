import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts (failures, errors))
import Control.Monad (void)
import System.Exit (ExitCode (ExitSuccess, ExitFailure), exitWith)
import FailingSubmission ( thisIsFalse )

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

test_thisFails :: Assertion
test_thisFails = True @=? thisIsFalse

failingSubmissionTests :: [Test]
failingSubmissionTests = [ testCase "this fails" test_thisFails ]

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