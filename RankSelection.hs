module RankSelection where

import Data.List
import Data.List.Split
import Control.Applicative

selectRank :: Ord a => [a] -> Int -> a
selectRank xs k
 | k < length xs && k >= 0 = select k xs
 | otherwise               = error "rank doesn't exist"
 where middle xs = length xs `div` 2
       select k xs
         | length xs < 6 = sort xs!!k
         | k < l         = select k     lt
         | otherwise     = select (k-l) gt
          where sample        = map (liftA2 (!!) sort middle) (chunksOf 5 xs)
                pivot         = (select =<< middle) sample
                (l,(lt, gt))  = (,) =<< length . fst $ partition (< pivot) xs
