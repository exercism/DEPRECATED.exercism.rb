(ns fake-submission.test (:require [clojure.test :refer :all]))
(load-file "fake_submission.clj")

(deftest this-is-true
  (is (fake-submission/this-is-true)))

(run-tests)
