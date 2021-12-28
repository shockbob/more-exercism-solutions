(ns reversi.core-test
  (:require [clojure.test :refer :all]
            [reversi.extra :refer :all]
            [reversi.core :refer :all]))

(deftest make-diffs-1
  (testing "make-diffs works"
    (is (= {{:dr 1 :dc 1} {:dr 2 :dc 2} {:dr 3 :dc 3} {:dr 4 :dc 4} {:dr 5 :dc 5} {:dr 6 :dc 6} {:dr 7 :dc 7} {:dr 8 :dc 8}} (make-diffs {:dr 1 :dc 1})))))

(deftest make-coords-1
  (testing "make-coords works"
    (is (= [{ :row 2 :col 2} { :row 3 :col 3}] (make-coords { :row 1 :col 1} [{ :dr 1 :dc 1} { :dr 2 :dc 2}])))))

(deftest get-valid-coords-in-dir-1
  (testing "get-valid-coords-in-dir works"
    (is (= [{ :dr 2 :dr 2} { :dr 3 :dr 3} { :dr 4 :dr 4} { :dr 5 :dr 5} { :dr 6 :dr 6} { :dr 7 :dr 7}] (get-valid-coords-in-dir { :dr 1 :dr 1} { :dr 1 :dr 1})))))

(deftest count-stables-1
  (testing "simple case for count-stables"
    (is (= 0 (count-stables [] white)))))

(deftest count-stables-2
  (testing "simple case for count-stables"
    (is (= 2 (count-stables [white white] white)))))

(deftest count-stables-3
  (testing "simple case for count-stables"
    (is (= 1 (count-stables [white black] white)))))

(deftest count-stables-4
  (testing "simple case for count-stables"
    (is (= 0 (count-stables [black white] white)))))

(def test-find-stables-grid
  (make-grid [[0 0 black] [1 1 black] [0 1 black] [0 2 black] [1 0 black]]))

(deftest find-stables-test-1
  (testing "find-stables works for simple case"
    (is (= #{{ :dr 0 :dr 0} { :dr 0 :dr 1} { :dr 0 :dr 2} { :dr 1 :dr 0} { :dr 1 :dr 1}} (find-stables test-find-stables-grid black)))))

(def test-grid-corner (make-grid [[0 0 black]]))

;(def get-value-test-1
;  (testing "get-value different for corner exists vs not"
;    (is (> (get-value { :dr 1 :dr 1} test-grid-corner) (get-value { :dr 1 :dr 1} start-grid)))))

(def max-by-test-2
  (testing "max-by works for sum"
    (is (= [10 2] (max-by (partial reduce +) [[10 2] [1 2 3] [] { :dr 1 :dr 1}])))))

(def max-by-test-1
  (testing "max-by works for count"
    (is (= [1 2 3] (max-by count [{ :dr 1 :dr 2} [1 2 3] [] { :dr 1 :dr 1}])))))

(deftest quick-test
  (testing "dirs size is 8"
    (is (= 8 (count (get-dirs))))))

;(deftest play-game-1
;  (testing "play games works"
;    (is (= (play-game start-grid [] first first) []))))
(deftest scores-1
  (testing "scores returns correct result"
    (is (= {blank 60 white 2 black 2} (scores start-grid)))))
(def next-grid (make-grid [[3 3 black] [4 4 black] [4 3 white] [3 4 black] [2 4 black]]))
;(println next-grid)
(defn fst [mvs grd] (first mvs))
;(deftest play-next-move-1
;  (testing "play-next-move works"
;    (is  (= (play-next-move start-grid black fst) next-grid))))

(deftest get-all-moves-1
  (testing "get-all-moves works"
    (is (= (get-all-moves start-grid white)  '([{ :dr 2 :dr 3} ({ :dr 3 :dr 3})] [{ :dr 3 :dr 2} ({ :dr 3 :dr 3})] [{ :dr 4 :dr 5} ({ :dr 4 :dr 4})] [{ :dr 5 :dr 4} ({ :dr 4 :dr 4})])))))

(def count-flips-1
  (testing
   (is (= 0 (count-flips [] white)))))

(def count-flips-2
  (testing
   (is (= 0 (count-flips [black blank] white)))))

(def count-flips-3
  (testing
   (is (= 0 (count-flips [blank black] white)))))

(def count-flips-4
  (testing
   (is (= 1 (count-flips [black white] white)))))

(def count-flips-5
  (testing
   (is (= 0 (count-flips [white black] white)))))

(def count-flips-6
  (testing
   (is (= 4 (count-flips [black black black black white] white)))))

(def new-grid (make-move start-grid [{ :dr 2 :dr 3} [{ :dr 3 :dr 3}]] white))
(deftest get-all-moves-2
  (testing "get-all-moves works against other case"
    (is (= (get-all-moves new-grid black) '([{ :dr 2 :dr 2} ({ :dr 3 :dr 3})] [{ :dr 2 :dr 4} ({ :dr 3 :dr 4})] [{ :dr 4 :dr 2} ({ :dr 4 :dr 3})])))))

(deftest make-move-1
  (testing "make-move returns correct results"
    (is (= (make-move [[blank white] [white white]] [{ :dr 0 :dr 0} [{ :dr 0 :dr 1} { :dr 1 :dr 0} { :dr 1 :dr 1}]] black) [[black black] [black black]]))))

(deftest blank-neighbors-1
  (testing "blank-neighbors and neighbors return same result"
    (is (= (blank-neighbors blank-grid { :dr 3 :dr 3}) (neighbors { :dr 3 :dr 3})))))

(deftest blank-neighbors-2
  (testing "blank-neighbors and neighbors returns different result"
    (is (not= (blank-neighbors start-grid { :dr 3 :dr 3}) (neighbors { :dr 3 :dr 3})))))

(deftest blank-neighbors-3
  (testing "blank-neighbors returns correct result"
    (is (= (sort (blank-neighbors start-grid { :dr 3 :dr 3})) [{ :dr 2 :dr 2} { :dr 2 :dr 3} { :dr 2 :dr 4} { :dr 3 :dr 2} { :dr 4 :dr 2}]))))

(deftest find-color-1
  (testing "find-color returns correct results"
    (is (= (find-color start-grid black) [{ :dr 3 :dr 3} { :dr 4 :dr 4}]))))

(deftest find-color-2
  (testing "find-color returns correct results"
    (is (= (find-color start-grid white) [{ :dr 3 :dr 4} { :dr 4 :dr 3}]))))

(deftest neighbors-1
  (testing "neighbors on corner"
    (is (= 3 (count (neighbors { :dr 0 :dr 0}))))))

(deftest neighbors-2
  (testing "neighbors in middle"
    (is (= 8 (count (neighbors { :dr 3 :dr 3}))))))

(deftest neighbors-3
  (testing "neighbors in edge"
    (is (= 5 (count (neighbors { :dr 3 :dr 0}))))))

(deftest in-range-1
  (testing "inrange fails"
    (is (= false (in-range? 99)))))

(deftest in-range-2
  (testing "inrange succeeds"
    (is (= true (in-range? 3)))))

(deftest in-range-coord-1
  (testing "inrange-coord fails"
    (is (= false (in-range-coord? { :dr 8 :dr 3})))))

(deftest in-range-coord-2
  (testing "inrange-coord succeeds"
    (is (= true (in-range-coord? { :dr 3 :dr 3})))))

(deftest a-test
  (testing "FIXME, I fail."
    (is (= 1 1))))
