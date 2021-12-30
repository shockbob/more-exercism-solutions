(ns reversi.extra
  (:gen-class))
(def blank \-)
(def black \B)
(def white \W)
(def dirs (map (fn [[dr dc]] {:dr dr :dc dc})  [[-1 -1] [-1 1] [-1 0] [1 -1] [1 1] [1 0] [0 1] [0 -1]]))
(defn get-dirs [] dirs)
(def blank-grid {})
(def opposite {white black black white})
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
  (apply str (interpose "\r\n"
                        (map (partial apply str) (vec-grid grid)))))

(defn printable-grids [grid]
  (interpose "\r\n\r\n" (map printable grid)))

(defn in-range? [val]
  (< -1 val 8))

(defn in-range-coord? [{row :row col :col}]
  (and (in-range? row) (in-range? col)))

(defn make-diffs
  ([dir] (make-diffs dir 1))
  ([{dr :dr dc :dc} start]
   (map (fn [mult] {:dr (* dr mult) :dc (* dc mult)}) (range start 9))))

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

(defn stable-section
  ([grid forward-dir edge-coords color]
   (stable-section grid forward-dir edge-coords color 8 []))
  ([grid forward-dir [f & r] color mx coll]
   (if (or (nil? f)(zero? mx))
       coll
       (let [chunk (stable-chunk grid f forward-dir color mx)
             mx (dec (count chunk))]
         (recur grid forward-dir r color mx (concat coll chunk))))))



(defn stables [grid corner-coord color]
  (let [port-dir (get-in corners [corner-coord :port])
        forward-dir (get-in corners [corner-coord :forward])
        valid-edges (get-valid-coords-in-dir corner-coord port-dir 0)
        stables (stable-section grid forward-dir valid-edges color)]
    stables))

(defn stables-on-grid [grid color]
  (mapcat (fn [corner-coord] (stables grid corner-coord color))
     (keys corners)))
     
(defn neighbors [coord]
  (filter in-range-coord?
         (make-coords coord (get-dirs))))

(defn make-grid [grid-data]
  (reduce
   (fn [g [r c val]] (assoc g {:row r :col c} val))
   blank-grid
   grid-data))

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

(defn countem [[f & r] color total]
  (cond
    (nil? f) 0
    (= color f) total
    (= (opposite color) f) (countem r color (inc total))
    :else 0))

(defn count-flips [colors color]
  (countem colors color 0))

(defn make-move [grid [coord flips] color]
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

(defn get-all-moves [grid color]
  (let [moves (possible-moves grid color)
        flips (map (fn [coord] [coord (get-all-flips grid color coord)]) moves)
        flips (filter (fn [[coord flips]] (not (empty? flips))) flips)]
    flips))

(defn scores [grid]
  (frequencies (vals grid)))

(defn play-next-move [grid color chooser]
  (let [all-moves (get-all-moves grid color)
        best-move (chooser all-moves grid)
        grid (if (empty? all-moves) grid (make-move grid best-move color))]
    grid))

(defn max-by [keyfn [f & r]]
  (if (nil? f)
    nil
   (first
    (reduce
     (fn [[max-e max-fe] e]
       (let [fe (keyfn e)]
         (if (> fe max-fe)
           [e fe]
           [max-e max-fe])))
     [f (keyfn f)]
     r))))

(def upper-left  {:row 0 :col 0})
(def upper-right {:row 0 :col 7})
(def lower-right {:row 7 :col 7})
(def lower-left  {:row 7 :col 0})
(def corners-map
  {{ :row 0 :col 1 } upper-left, { :row 1 :col 0 } upper-left, { :row 1 :col 1 } upper-left,
   { :row 6 :col 7 } lower-right, { :row 7 :col 6 } lower-right, { :row 6 :col 6 } lower-right,
   { :row 0 :col 6 } upper-right, { :row 1 :col 6 } upper-right, { :row 1 :col 7 } upper-right,
   { :row 6 :col 0 } lower-left, { :row 6 :col 1 } lower-left, { :row 7 :col 1 } lower-left})

(defn value-calculate [mv]
  (value-map (get-in value-grid-x [(mv :row)(mv :col)])))

(defn value-move [[mv flips]]
  (reduce + (map value-calculate (conj flips mv))))

(defn value-chooser-2 [moves grid]
  (max-by value-move moves))

(defn get-value [grid mv]
  (let [corner-value (corners-map mv)]
    (if (or (nil? corner-value) (nil? (grid corner-value)))
      (value-calculate mv)
      (value-map :corner))))

(defn value-chooser [moves grid]
  (max-by (fn [[mv flips]] (value-calculate mv)) moves))

(defn value-chooser-enh [moves grid]
  (max-by (fn [[mv flips]] (reduce + (map (partial get-value grid) (conj flips mv)))) moves))

(defn size-chooser [moves grid]
  (max-by (fn [[mv flips]] (count flips)) moves))

(defn rand-xth [c grid] (if (empty? c) nil (rand-nth c)))

(defn test-summary [all-scores]
  (reduce
   (fn [res score] (if (> (score black 0) (score white 0))
                     (assoc res black (inc (res black 0)))
                     (assoc res white (inc (res white 0)))))
   {}
   all-scores))

(defn addem [a b] (+ a b))

(defn play-game [grid grids black-chooser white-chooser]
  (let [black-grid (play-next-move grid black black-chooser)
        white-grid (play-next-move black-grid  white white-chooser)]
    (if (= white-grid grid)
      grids
      (play-game white-grid (conj grids black-grid white-grid) black-chooser white-chooser))))

(defn dotest [n]
  (let [games (take n (repeatedly
                       #(play-game start-grid [] rand-xth rand-xth)))
        all-scores (map scores (map last games))]
    (test-summary all-scores)))

;(println (dotest 1000))

;(def grids (play-game start-grid [] size-chooser value-chooser-enh))
;(println (printable-grids grids))
;(println (scores (last grids)))
;
