(ns reversi.extra
  (:gen-class))
(def blank \X)
(def black \B)
(def white \W)
(def dirs [[-1 -1] [-1 1] [-1 0] [1 -1] [1 1] [1 0] [0 1] [0 -1]])
(def blank-row (apply vector (repeat 8 blank)))
(def blank-grid (apply vector (repeat 8 blank-row)))
(def opp {white black black white})

(defn in-range? [val]
  (< -1 val 8))

(defn in-range-coord? [[row col]]
  (and (in-range? row) (in-range? col)))

(defn neighbors [[row col]]
  (filter in-range-coord?
          (map (fn [[dr dc]] [(+ dr row) (+ dc col)])
               dirs)))

(def start-grid
  (reduce
   (fn [g [r c val]] (assoc-in g [r c] val))
   blank-grid
   [[3 3 black] [4 4 black] [3 4 white] [4 3 white]]))

(def all-coords
  (for [row (range 8) col (range 8)]
    [row col]))

(defn blank-neighbors [grid coord]
  (filter (fn [coord] (= blank (get-in grid coord)))
          (neighbors coord)))

(defn find-color [grid color]
  (filter (fn [coord] (= color (get-in grid coord)))
          all-coords))

(defn get-flips [grid coords color]
  (let [flips (take-while (fn [coord] (= (opp color) (get-in grid coord))) coords)]
    (if (= (count flips) (count coords))
      []
      flips)))

(defn make-move [grid coord flips color]
  (let [new-grid (assoc-in grid coord color)
        new-grid (reduce (fn [g c] (assoc-in g c color)) new-grid flips)]
    new-grid))

(defn valid-color [grid coord]
  (and (in-range-coord? coord)
       (not= blank (get-in grid coord))))

(defn get-moves-at-direction [grid color [r c] [dr dc]]
  (let [diffs (map (fn [mult] [(* dr mult) (* dc mult)]) (range 1 9))
        coords (map (fn [[dr dc]] [(+ r dr) (+ c dc)]) diffs)
        valid-coords (filter (partial valid-color grid) coords)
        flips (get-flips grid valid-coords color)]
    flips))

(defn get-all-flips [grid color [r c]]
  (mapcat
   (fn [dir] (get-moves-at-direction grid color [r c] dir))
   dirs))

(defn possible-moves [grid color]
  (let [opps (find-color grid (opp color))
        blanks (distinct (mapcat (partial blank-neighbors grid) opps))]
    (sort blanks)))
