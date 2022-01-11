(ns reversi.core-test
  (:require [clojure.test :refer :all]
            [reversi.extra :refer :all]
            [reversi.core :refer :all]))
(def test-grid (make-grid (for [i (range 8) j (range 2)] [i j white])))

(deftest test-stables-on-grid-1
  (testing
   (is (= 16 (count (stables-on-grid test-grid white))))))

(def test-stable-grid (make-grid [[0 0 white] [0 1 white] [0 2 white]
                                  [1 0 white] [1 1 white]]))

(deftest test-stable-chunk-1
  (testing
   (is (= [{:row 0 :col 0} {:row 0 :col 1} {:row 0 :col 2}]
          (stable-chunk test-stable-grid {:row 0 :col 0} {:dr 0 :dc 1} white 8)))))
(deftest make-diffs-1
  (testing "make-diffs works"
    (is (= [{:dr 1 :dc 1} {:dr 2 :dc 2} {:dr 3 :dc 3} {:dr 4 :dc 4} {:dr 5 :dc 5} {:dr 6 :dc 6} {:dr 7 :dc 7} {:dr 8 :dc 8}] (make-diffs {:dr 1 :dc 1})))))

(deftest make-coords-1
  (testing "make-coords works"
    (is (= [{:row 2 :col 2} {:row 3 :col 3}] (make-coords {:row 1 :col 1} [{:dr 1 :dc 1} {:dr 2 :dc 2}])))))

(deftest get-valid-coords-in-dir-1
  (testing "get-valid-coords-in-dir works"
    (is (= [{:row 2 :col 2} {:row 3 :col 3} {:row 4 :col 4} {:row 5 :col 5} {:row 6 :col 6} {:row 7 :col 7}] (get-valid-coords-in-dir {:row 1 :col 1} {:dr 1 :dc 1})))))

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

(def corners-test [{:move {:row 0 :col 0}} {:move {:row 7 :col 7}}])
(def sides-test [{:move {:row 0 :col 3}}])
(def find-by-moves (concat corners-test sides-test))

(deftest find-by-square-type-test
  (testing "find by square type for corners works"
    (is (= corners-test ((find-by-square-type :corner) find-by-moves)))))

(deftest find-by-square-type-test
  (testing "find by square type for sides works"
    (is (= sides-test ((find-by-square-type :side) find-by-moves)))))

(def test-find-stables-grid
  (make-grid [[0 0 black] [1 1 black] [0 1 black] [0 2 black] [1 0 black]]))

(def test-grid-corner (make-grid [[0 0 black]]))

(deftest get-value-test-1
  (testing "get-value different for corner exists vs not"
    (is (> (get-value test-grid-corner {:row 1 :col 1}) (get-value start-grid {:row 1 :col 1})))))

(deftest max-by-test-3
  (testing "max-by works for empty coll"
    (is (= nil (max-by (partial reduce +) [])))))

(deftest max-by-test-2
  (testing "max-by works for sum"
    (is (= [[10 2] [12]] (max-by (partial reduce +) [[10 2] [12] [1 2 3] [] [1 1]])))))

(deftest max-by-test-1
  (testing "max-by works for count"
    (is (= [[1 2 3]] (max-by count [[1 2] [1 2 3] [] [1 1]])))))

(deftest quick-test
  (testing "dirs size is 8"
    (is (= 8 (count (get-dirs))))))

;(deftest play-game-1
;  (testing "play games works"
;    (is (= (play-game start-grid [] first first) []))))
(deftest scores-1
  (testing "scores returns correct result"
    (is (= {white 2 black 2} (scores start-grid)))))
(def next-grid  {{:row 3, :col 3} \B, {:row 4, :col 4} \B, {:row 3, :col 4} \B, {:row 4, :col 3} \W, {:row 2, :col 4} \B})
(defn fst [mvs grd] [(first mvs)])
(deftest play-next-move-1
  (testing "play-next-move works"
    (is  (= (play-next-move start-grid black fst identity) next-grid))))

(deftest get-all-moves-1
  (testing "get-all-moves works"
    (is (= (set (get-all-moves start-grid white))
           #{{:move {:row 2 :col 3} :color white :flips [{:row 3 :col 3}]}
             {:move {:row 3 :col 2} :color white :flips [{:row 3 :col 3}]}
             {:move {:row 4 :col 5} :color white :flips [{:row 4 :col 4}]}
             {:move {:row 5 :col 4} :color white :flips [{:row 4 :col 4}]}}))))

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

(def new-grid (make-move start-grid {:move {:row 2 :col 3} :color white :flips [{:row 3 :col 3}]}))
(deftest get-all-moves-2
  (testing "get-all-moves works against other case"
    (is (= (set (get-all-moves new-grid black))
           #{{:color black :move {:row 2 :col 2} :flips [{:row 3 :col 3}]}
             {:color black :move {:row 2 :col 4} :flips [{:row 3 :col 4}]}
             {:color black :move {:row 4 :col 2} :flips [{:row 4 :col 3}]}}))))
(def move-start {{:row 0 :col 1} white
                 {:row 1 :col 0} white {:row 1 :col 1} white})

(def move-end {{:row 0 :col 0} black {:row 0 :col 1} black
               {:row 1 :col 0} black {:row 1 :col 1} black})
(deftest make-move-1
  (testing "make-move returns correct results"
    (is (= (make-move move-start {:color black :move {:row 0 :col 0} :flips [{:row 0 :col 1} {:row 1 :col 0} {:row 1 :col 1}]}) move-end))))

(deftest blank-neighbors-1
  (testing "blank-neighbors and neighbors return same result"
    (is (= (blank-neighbors blank-grid {:row 3 :col 3}) (neighbors {:row 3 :col 3})))))

(deftest blank-neighbors-2
  (testing "blank-neighbors and neighbors returns different result"
    (is (not= (blank-neighbors start-grid {:row 3 :col 3}) (neighbors {:row 3 :col 3})))))

(deftest blank-neighbors-3
  (testing "blank-neighbors returns correct result"
    (is (= (blank-neighbors start-grid {:row 3 :col 3})) [{:row 2 :col 2} {:row 2 :col 3} {:row 2 :col 4} {:row 3 :col 2} {:row 4 :col 2}])))

(deftest find-color-1
  (testing "find-color returns correct results"
    (is (= (find-color start-grid black) [{:row 3 :col 3} {:row 4 :col 4}]))))

(deftest find-color-2
  (testing "find-color returns correct results"
    (is (= (find-color start-grid white) [{:row 3 :col 4} {:row 4 :col 3}]))))

(deftest neighbors-1
  (testing "neighbors on corner"
    (is (= 3 (count (neighbors {:row 0 :col 0}))))))

(deftest neighbors-2
  (testing "neighbors in middle"
    (is (= 8 (count (neighbors {:row 3 :col 3}))))))

(deftest neighbors-3
  (testing "neighbors in edge"
    (is (= 5 (count (neighbors {:row 3 :col 0}))))))

(deftest in-range-1
  (testing "inrange fails"
    (is (= false (in-range? 99)))))

(deftest in-range-2
  (testing "inrange succeeds"
    (is (= true (in-range? 3)))))

(deftest in-range-coord-1
  (testing "inrange-coord fails"
    (is (= false (in-range-coord? {:row 8 :col 3})))))

(deftest in-range-coord-2
  (testing "inrange-coord succeeds"
    (is (= true (in-range-coord? {:row 3 :col 3})))))

(def last-move-chooser-grid
  (str-to-grid (apply str
                      ["--------"
                       "----B---"
                       "----WWB-"
                       "---BW---"
                       "----BBB-"
                       "--------"
                       "--------"
                       "--------"])))

(def last-move-possible-moves (get-all-moves last-move-chooser-grid black))
(deftest possible-moves-test-99
  (testing "get-all-moves for last-chooser-grid"
    (is (= 4 (count last-move-possible-moves)))))

(deftest last-move-chooser-test
  (testing "last-move-chooser works for simple case"
    (is (= 1 (count (last-move-chooser last-move-possible-moves last-move-chooser-grid))))))
