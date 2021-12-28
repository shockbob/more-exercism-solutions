(ns elyses-destructured-enchantments)

(defn first-card
  "Returns the first card from deck."
  [[d1 & r]]
  d1
)

(defn second-card
  "Returns the second card from deck."
  [[d1 d2 & r]]
  d2
)

(defn swap-top-two-cards
  "Returns the deck with first two items reversed."
  [[d1 d2 & r]]
  (concat [d2 d1] r)
)

(defn discard-top-card
  "Returns a vector containing the first card and
   a vector of the remaining cards in the deck."
  [[d1 & r]]
  [d1 r]
)

(def face-cards
  ["jack" "queen" "king"])

(defn insert-face-cards
  "Returns the deck with face cards between its head and tail."
  [[d1 & r]]
  (if (nil? d1) 
      face-cards
      (concat [d1] face-cards r)))

(comment
  )
