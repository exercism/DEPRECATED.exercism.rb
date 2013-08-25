(ns fake-submission.test (:require [clojure.test :refer :all]))
(load-file "test/fixtures/testsuites/fake_submission.clj")

(deftest this-is-true
  (is (fake-submission/this-is-true)))

(when (not (successful? (run-tests)))
  (System/exit 1))
