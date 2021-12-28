(ns elyses-destructured-enchantments)

(defn first-card
  "Returns the first card from deck."
  [[d1 & r]] d1
)

(defn second-card
  "Returns the second card from deck."
  [[d1 dx & r]] dx
)

(defn swap-top-two-cards 
  "Returns the deck with first two items reversed."
  [[d1 d2 & r]] (concat [d2 d1] (vec r))
)

(defn discard-top-card
  "Returns a vector containing the first card and
   a vector of the remaining cards in the deck."
  [[d1  & r]] [d1 (vec r)]
)

(def face-cards
  ["jack" "queen" "king"])

(defn insert-face-cards
  "Returns the deck with face cards between its head and tail."
  [[d1 & r]] (concat [d1] face-cards (vec r))
)
)

(comment
  )