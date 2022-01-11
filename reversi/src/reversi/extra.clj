(ns reversi.extra
  (:gen-class))

(def blank \-)
(def black \B)
(def white \W)
(def dirs (map (fn [[dr dc]] {:dr dr :dc dc})  [[-1 -1] [-1 1] [-1 0] [1 -1] [1 1] [1 0] [0 1] [0 -1]]))
(defn get-dirs [] dirs)
(def blank-grid {})
(def opposite {white black black white})

(defn char-to-entry [ch i]
  (if (or (= ch \W) (= ch \B))
    [{:row (quot i 8) :col (mod i 8)} ch]
    nil))

(defn str-to-grid [s]
  (apply hash-map
         (mapcat
          (fn [i] (char-to-entry (get s i) i))
          (range (count s)))))

(defn max-by [keyfn coll]
  (if (empty? coll)
    nil
    (let [grouped (group-by keyfn coll)
          keys (keys grouped)
          mx (apply max keys)]
      (grouped mx))))

(def value-grid-x [[:corner :corner-adj :side :side :side :side :corner-adj :corner]
                   [:corner-adj :corner-adj :side-adj :side-adj :side-adj :side-adj :corner-adj :corner-adj]
                   [:side :side-adj :center :center :center :center :side-adj :side]
                   [:side :side-adj :center :center :center :center :side-adj :side]
                   [:side :side-adj :center :center :center :center :side-adj :side]
                   [:side :side-adj :center :center :center :center :side-adj :side]
                   [:corner-adj :corner-adj :side-adj :side-adj :side-adj :side-adj :corner-adj :corner-adj]
                   [:corner :corner-adj :side :side :side :side :corner-adj :corner]])

(def value-map {:corner 40 :corner-adj 1 :center 10 :side 20 :side-adj 1})

(defn vec-grid [grid]
  (vec
   (map
    vec
    (partition 8
               (for [row (range 8) col (range 8)]
                 (grid {:row row :col col} \-))))))

(defn printable [grid]
  (apply str (interpose
              "\r\n"
              (map (partial apply str) (vec-grid grid)))))

(defn printable-grids [grids]
  (interpose "\r\n\r\n" (map printable grids)))

(defn printable-single-line [grid]
  (apply str (flatten (vec-grid grid))))

(defn printable-grids-single-line [grids]
  (interpose "\r\n\r\n" (map printable-single-line grids)))

(defn in-range? [val]
  (< -1 val 8))

(defn in-range-coord? [{row :row col :col}]
  (and (in-range? row) (in-range? col)))

(defn make-diffs
  ([dir] (make-diffs dir 1))
  ([{dr :dr dc :dc} start]
   (map
    (fn [mult] {:dr (* dr mult) :dc (* dc mult)})
    (range start 9))))

(defn make-coords [{r :row c :col} diffs]
  (map (fn [{dr :dr dc :dc}] {:row (+ r dr) :col (+ c dc)}) diffs))

(defn get-valid-coords-in-dir
  ([coord dir] (get-valid-coords-in-dir coord dir 1))
  ([coord dir start]
   (let [diffs (make-diffs dir start)
         coords (make-coords coord diffs)
         valid-coords (filter in-range-coord? coords)]
     valid-coords)))

(defn count-stables [colors color]
  (count (take-while (partial = color) colors)))

(def corners
  {{:row 0 :col 0} {:port {:dr 0 :dc 1} :forward {:dr 1 :dc 0}}
   {:row 0 :col 7} {:port {:dr 1 :dc 0} :forward {:dr 0 :dc -1}}
   {:row 7 :col 0} {:port {:dr 0 :dc 1} :forward {:dr -1 :dc 0}}
   {:row 7 :col 7} {:port {:dr 0 :dc -1} :forward {:dr -1 :dc 0}}})

(defn stable-chunk [grid coord forward-dir color max-size]
  (let [forward-coords (get-valid-coords-in-dir coord forward-dir 0)
        colors (map grid forward-coords)
        stable-size (count-stables colors color)]
    (take (min stable-size max-size) forward-coords)))

(defn adjust-chunk-size [chunk-size]
  (cond
    (= chunk-size 8) 8
    (= chunk-size 1) 1
    :else (dec chunk-size)))

(defn stable-section
  ([grid forward-dir edge-coords color]
   (stable-section grid forward-dir edge-coords color 8 []))
  ([grid forward-dir [f & r] color mx coll]
   (if (or (nil? f) (zero? mx))
     coll
     (let [chunk (stable-chunk grid f forward-dir color mx)
           mx (adjust-chunk-size (count chunk))]
       (recur grid forward-dir r color mx (concat coll chunk))))))

(defn stables-from-corner [grid corner-coord color]
  (let [port-dir (get-in corners [corner-coord :port])
        forward-dir (get-in corners [corner-coord :forward])
        valid-edges (get-valid-coords-in-dir corner-coord port-dir 0)
        stables (stable-section grid forward-dir valid-edges color)]
    stables))

(defn stables-on-grid [grid color]
  (let [stable-vec (mapcat
                    (fn [corner-coord] (stables-from-corner grid corner-coord color))
                    (keys corners))]
    (set stable-vec)))

(defn neighbors [coord]
  (filter in-range-coord?
          (make-coords coord (get-dirs))))

(defn make-grid [grid-data]
  (reduce
   (fn [g [r c val]] (assoc g {:row r :col c} val))
   blank-grid
   grid-data))

(defn get-best-stable-change [new-grid-map count-stables]
  (max-by (fn [move] (- (count (stables-on-grid (new-grid-map move) (move :color)  count-stables))) (keys new-grid-map))))

(def start-grid
  (make-grid [[3 3 black] [4 4 black] [3 4 white] [4 3 white]]))

(def all-coords
  (for [row (range 8) col (range 8)]
    {:row row :col col}))

(defn blank-neighbors [grid coord]
  (filter (fn [coord] (nil? (grid coord)))
          (neighbors coord)))

(defn find-color [grid color]
  (map first
       (filter
        (fn [[k v]] (= v color))
        grid)))

(defn count-flips-x [colors color]
  (reduce (fn [[state count] e]
            (cond
              (= state :completed) [state count]
              (= state :found-opposite)
              (cond
                (= e color) [:completed count]
                :else [state (inc count)])
              (= state :looking-for-opposite)
              (cond
                (= e (opposite color))  [:found-opposite 1]
                :else [:invalid 0])
              :else [:invalid 0]))
          [:looking-for-opposite 0]
          colors))

(defn count-flips
  ([colors color] (count-flips colors color 0))
  ([[f & r] color total]
   (cond
     (nil? f) 0
     (= color f) total
     (= (opposite color) f) (recur r color (inc total))
     :else 0)))

(defn make-move [grid {coord :move flips :flips color :color}]
  (let [new-grid (assoc grid coord color)
        new-grid (reduce (fn [g c] (assoc g c color)) new-grid flips)]
    new-grid))

(defn get-moves-at-direction [grid color coord dir]
  (let [valid-coords (get-valid-coords-in-dir coord dir)
        colors (map grid valid-coords)
        flip-size (count-flips colors color)
        flips (take flip-size valid-coords)]
    flips))

(defn get-all-flips [grid color coord]
  (mapcat
   (fn [dir] (get-moves-at-direction grid color coord dir))
   (get-dirs)))

(defn possible-moves [grid color]
  (let [opps (find-color grid (opposite color))
        blanks (distinct (mapcat (partial blank-neighbors grid) opps))]
    blanks))

(defn create-moves [grid move-coords color]
  (map
   (fn [mv] {:color color :move mv :flips (get-all-flips grid color mv)})
   move-coords))

(defn get-valid-moves [moves]
  (filter
   (fn [{flips :flips}] (seq flips))
   moves))

(defn get-all-moves [grid color]
  (let [possible-moves (possible-moves grid color)
        all-moves (create-moves grid possible-moves color)
        valid-moves (get-valid-moves all-moves)]
    valid-moves))

(defn scores [grid]
  (frequencies (vals grid)))

(defn add-reversed [mp key coll]
  (reduce (fn [mp e] (assoc mp e key)) mp coll))

(defn make-normalized-groups [keyfn coll]
  (if (empty? coll)
    nil
    (let [grouped (group-by keyfn coll)
          keys (sort > (keys grouped))
          converter-map (apply hash-map (interleave keys (range)))]
      (reduce
       (fn [mp [k v]] (add-reversed mp (converter-map k) v))
       {}
       grouped))))


(def upper-left  {:row 0 :col 0})
(def upper-right {:row 0 :col 7})
(def lower-right {:row 7 :col 7})
(def lower-left  {:row 7 :col 0})
(def corner-map
  {{:row 0 :col 1} upper-left, {:row 1 :col 0} upper-left, {:row 1 :col 1} upper-left,
   {:row 6 :col 7} lower-right, {:row 7 :col 6} lower-right, {:row 6 :col 6} lower-right,
   {:row 0 :col 6} upper-right, {:row 1 :col 6} upper-right, {:row 1 :col 7} upper-right,
   {:row 6 :col 0} lower-left, {:row 6 :col 1} lower-left, {:row 7 :col 1} lower-left})

(defn square-type [{row :row col :col}]
  (get-in value-grid-x [row col]))

(defn value-calculate [mv]
  (value-map (square-type mv)))

(defn value-move [{mv :move flips :flips}]
  (reduce + (map value-calculate (conj flips mv))))

(defn value-chooser-2 [moves grid]
  (max-by value-move moves))

(defn find-by-square-type [type]
  (fn [moves] (filter (fn [mv] (= type (square-type (mv :move)))) moves)))

(defn get-value [grid mv]
  (let [corner-value (corner-map mv)]
    (if (or (nil? corner-value) (nil? (grid corner-value)))
      (value-calculate mv)
      (value-map :corner))))

(defn value-chooser [moves grid]
  (max-by (fn [{mv :move flips :flips}] (value-calculate mv)) moves))

(defn value-chooser-enh [moves grid]
  (max-by (fn [{mv :move flips :flips}] (get-value grid mv)) moves))

(defn screw-opp-chooser [moves grid])

(defn value-chooser-enh2 [moves grid]
  (max-by (fn [{mv :move flips :flips}] (reduce + (map (partial get-value grid) (conj flips mv)))) moves))

(defn size-chooser [moves grid]
  (max-by (fn [{mv :move flips :flips}] (count flips)) moves))

(defn rand-plus-chooser [moves grid]
  (if (empty? moves)
    nil
    (let [testers [(find-by-square-type :corner) (find-by-square-type :side) (find-by-square-type :center)]
          results (first (remove empty? (map (fn [x] (x moves)) testers)))
          best-moves (if (empty? results) (value-chooser-enh moves grid) results)]
      best-moves)))

(defn make-new-grids [grid moves]
  (reduce (fn [m move] (assoc m move (make-move grid move))) {} moves))

(defn rand-chooser [c grid] (shuffle c))
(defn stables-chooser [moves grid]
  (if (empty? moves)
    nil
    (let [existing-stables (stables-on-grid grid ((first moves) :color))
          count-stables (count existing-stables)
          new-grid-map (make-new-grids grid moves)
          [move score] (get-best-stable-change new-grid-map count-stables)
          best-move (if (> score 0) move)]
      best-move)))

(defn last-move-chooser [moves grid]
  (let [new-grid-map (make-new-grids grid moves)
        filtered-moves (filter
                        (fn [[mv new-grid]] (nil? ((scores new-grid) (opposite (mv :color)))))
                        new-grid-map)]
    filtered-moves))

(defn test-summary [all-scores]
  (reduce
   (fn [res score] (cond
                     (> (score black 0) (score white 0))  (assoc res black (inc (res black 0)))
                     (> (score white 0) (score black 0))  (assoc res white (inc (res white 0)))
                     :else (assoc res "tie" (inc (res "tie" 0)))))
   {}
   all-scores))

(defn play-next-move
  ([grid color chooser]
   (play-next-move grid color chooser shuffle))
  ([grid color chooser modifier]
   (let [all-moves (get-all-moves grid color)
         best-moves (chooser (modifier all-moves) grid)
         best-move (rand-nth best-moves)
         grid (if (empty? all-moves) grid (make-move grid best-move))]
     grid)))

(defn play-game [grid grids black-chooser white-chooser]
  (let [black-grid (play-next-move grid black black-chooser)
        white-grid (play-next-move black-grid  white white-chooser)]
    (if (= white-grid grid)
      grids
      (play-game white-grid (conj grids black-grid white-grid) black-chooser white-chooser))))

(defn dotest [n]
  (let [games (take n (repeatedly
                       #(play-game start-grid [] value-chooser-enh rand-plus-chooser)))
        all-scores (map scores (map last games))]
    (test-summary all-scores)))
;
;(println (dotest 1000))

;(def grids (play-game start-grid [] rand-xth rand-plus-chooser))
;(println (printable-grids grids))
;(println (scores (last grids)))
