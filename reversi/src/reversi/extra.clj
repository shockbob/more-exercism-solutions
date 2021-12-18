(ns reversi.extra
  (:gen-class))
(def blank \-)
(def black \B)
(def white \W)
(def dirs [[-1 -1] [-1 1] [-1 0] [1 -1] [1 1] [1 0] [0 1] [0 -1]])
(def blank-row (vec (repeat 8 blank)))
(def blank-grid (vec (repeat 8 blank-row)))
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
        flips (filter (fn [[coord flips]] (not (empty? flips))) flips)]
    flips))

(defn scores [grid]
  (frequencies (flatten grid)))

(defn play-next-move [grid color chooser]
  (let [all-moves (get-all-moves grid color)
        best-move (chooser all-moves)
        grid (if (empty? all-moves) grid (make-move grid best-move color))]
    grid ))

(defn play-game [grid grids black-chooser white-chooser]
  (let [black-grid (play-next-move grid black black-chooser)
        white-grid (play-next-move black-grid  white white-chooser)]
    (if (= white-grid grid)
        grids
        (play-game white-grid (conj grids black-grid white-grid) black-chooser white-chooser))))

(def value-grid-x [[:corner :corner-adj :side :side :side :side :corner-adj :corner]
     [:corner-adj :corner-adj :side-adj :side-adj :side-adj :side-adj :corner-adj :corner-adj]
     [:side :side-adj :center :center :center :center :side-adj :side]
     [:side :side-adj :center :center :center :center :side-adj :side]
     [:side :side-adj :center :center :center :center :side-adj :side]
     [:side :side-adj :center :center :center :center :side-adj :side]
     [:corner-adj :corner-adj :side-adj :side-adj :side-adj :side-adj :corner-adj :corner-adj]
     [:corner :corner-adj :side :side :side :side :corner-adj :corner]])

(def value-map {:corner 40 :corner-adj 1 :center 10 :side 20 :side-adj 1})

(defn max-by [keyfn [f & r]] 
   (reduce 
     (fn [mx e] (if (> (keyfn e) (keyfn mx)) e mx)) 
     f 
     r))

(def corners {[0 1] [0 0], [1 0][0 0], [1 1][0 0],
              [6 7] [7 7], [7 6][7 7], [6 6][7 7],
              [0 6] [0 7], [1 6][0 7], [1 7][0 7],
              [6 0] [7 0], [6 1][7 0], [7 1][7 0]})

(defn value-calculate [mv]
  (value-map (get-in value-grid-x mv)))

(defn value-move [[mv flips]]
  (reduce + (map value-calculate (conj flips mv))))

(defn value-chooser-2 [moves]
  (max-by value-move moves))

;(defn get-value [mv grid]
;  (let [corner-value (corners mv)
;        real-value (if (nil? corner-value (get-in value-grid-x mv)) 
;  (get-in value-grid-x mv)) 

(defn value-chooser [moves]
  (max-by (fn [[mv flips]] (value-calculate mv)) moves))

(defn size-chooser [moves]
  (max-by (fn [[mv flips]] (count flips)) moves))

(defn printable [grid] 
      (apply str (interpose "\r\n" 
                            (map (partial apply str) grid))))

(defn rand-xth [c] (if (empty? c) nil (rand-nth c)))

(defn printablegrids [grid] (interpose "\r\n\r\n" (map printable grid)))
(def grids (play-game start-grid [] value-chooser rand-xth))
(def last-grid (last grids))
(println (printable last-grid))
(println (scores last-grid))

