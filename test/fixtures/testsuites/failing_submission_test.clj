(ns failing-submission.test (:require [clojure.test :refer :all]))
(load-file "failing_submission.clj")

(deftest this-fails
  (is (failing-submission/this-is-false)))

(run-tests)
