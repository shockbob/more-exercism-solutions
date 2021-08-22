module SpaceAge (Planet(..), ageOn) where

data Planet = Mercury
            | Venus
            | Earth
            | Mars
            | Jupiter
            | Saturn
            | Uranus
            | Neptune deriving (Eq)

planetYearToEarthYears :: Planet -> Float
planetYearToEarthYears planet
      | planet == Mercury = 0.2408467 
      | planet == Venus = 0.61519726 
      | planet == Earth = 1 
      | planet == Mars = 1.8808158 
      | planet == Jupiter = 11.862615 
      | planet == Saturn = 29.447498 
      | planet == Uranus = 84.016846 
      | planet == Neptune = 164.79132
      | otherwise = -1 
secondsToYear :: Float -> Float
secondsToYear secs = secs/(3600*24*365.25)
ageOn :: Planet -> Float -> Float
ageOn planet seconds = secondsToYear seconds/planetYearToEarthYears planet  
