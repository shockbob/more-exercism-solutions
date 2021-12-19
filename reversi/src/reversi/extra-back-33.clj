(ns reversi.extra
  (:gen-class))
(def blank \-)
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

(defn make-grid [grid-data]
  (reduce
   (fn [g [r c val]] (assoc-in g [r c] val))
   blank-grid
   grid-data))

(def start-grid
  (make-grid [[3 3 black] [4 4 black] [3 4 white] [4 3 white]]))

(def all-coords
  (for [row (range 8) col (range 8)]
    [row col]))

(defn blank-neighbors [grid coord]
  (filter (fn [coord] (= blank (get-in grid coord)))
          (neighbors coord)))

(defn find-color [grid color]
  (filter (fn [coord] (= color (get-in grid coord)))
          all-coords))

(defn countem [[f & r] color total]
  (cond
    (nil? f) 0
    (= color f) total
    (= (opp color) f) (countem r color (inc total))
    :else 0))

(defn count-flips [colors color]
  (countem colors color 0))

(defn make-move [grid [coord flips] color]
  (let [new-grid (assoc-in grid coord color)
        new-grid (reduce (fn [g c] (assoc-in g c color)) new-grid flips)]
    new-grid))

(defn get-moves-at-direction [grid color [r c] [dr dc]]
  (let [diffs (map (fn [mult] [(* dr mult) (* dc mult)]) (range 1 9))
        coords (map (fn [[dr dc]] [(+ r dr) (+ c dc)]) diffs)
        valid-coords (filter in-range-coord? coords)
        colors (map (partial get-in grid) valid-coords)
        flip-size (count-flips colors color)
        flips (take flip-size valid-coords)]
    flips))

(defn get-all-flips [grid color coord]
  (mapcat
   (fn [dir] (get-moves-at-direction grid color coord dir))
   dirs))

(defn possible-moves [grid color]
  (let [opps (find-color grid (opp color))
        blanks (distinct (mapcat (partial blank-neighbors grid) opps))]
    (sort blanks)))

(defn get-all-moves [grid color]
  (let [moves (possible-moves grid color)
        flips (map (fn [coord] [coord (get-all-flips grid color coord)]) moves)
        flips (filter (fn [[c fs]] (not (empty? fs))) flips)]
    flips))

(defn scores [grid]
  (frequencies (flatten grid)))

(defn play-next-move [grid color chooser]
  (let [all-moves (get-all-moves grid color)
        best-move (chooser all-moves)
        grid (if (empty? all-moves) grid (make-move grid best-move color))]
    grid))

(defn printable [grid]
  (apply str (interpose "\r\n"
                        (map (partial apply str) grid))))

(println (printable start-grid))
