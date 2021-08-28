module School (School, add, empty, grade, sorted) where
import Data.List
data Student = Student { name:: String
                        ,gradeNum :: Int } deriving(Show)

newtype School = School { students::  [Student] } deriving(Show)

add :: Int -> String -> School -> School
add grd student school = School {students = Student{name=student,gradeNum=grd } : students school }

empty :: School 
empty = School { students = [] } 

grade :: Int -> School -> [String]
grade grd school = sort ( map name 
                        (filter (\ student -> gradeNum student == grd ) (students school))) 

sorted :: School -> [(Int, [String])]
sorted school = map (\ grd -> (grd,grade grd school)) sortedGrades
               where sortedGrades = sort (nub (map gradeNum (students school)))
 
