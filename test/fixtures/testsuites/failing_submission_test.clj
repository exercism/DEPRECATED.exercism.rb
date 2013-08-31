(ns failing-submission.test (:require [clojure.test :refer :all]))
(load-file "test/fixtures/testsuites/failing_submission.clj")

(deftest this-fails
  (is (failing-submission/this-is-false)))

(when (not (successful? (run-tests)))
  (System/exit 1))
