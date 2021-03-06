module AhoCorasick ( Automaton(Node), buildAutomaton, match, match', isInfixOf) where
import           Control.Arrow (first)
import           Data.Function (on)
import           Data.List     (partition)
import           Data.Maybe    (fromMaybe)
import           Data.Monoid   (All (..), Monoid, getAll, mappend, mconcat,
                                mempty)
import           Utils         (equivalentClasses)
data Automaton a b = Node {delta  :: a -> Automaton a b,
                           output :: b
                         }

buildAutomaton :: (Monoid b,Eq a) => [([a],b)] -> Automaton a b
buildAutomaton xs = automaton
  where automaton = build (const automaton) xs mempty

build :: (Monoid b,Eq a)=> (a -> Automaton a b) -> [([a],b)] -> b -> Automaton a b
build trans xs out = node
  where node  = Node (\x->fromMaybe (trans x) (lookup x table)) out
        table =  map transPair $ equivalentClasses (on (==) (head . fst)) xs
        transPair xs = (a, build (delta (trans a)) ys out)
         where a  = head $ fst $ head xs
               (ys,zs) = partition (not . null . fst) $ map (first tail) xs
               out = mappend (mconcat $ map snd zs) (output $ trans a)

match :: Eq a => Automaton a b -> [a] -> [b]
match a xs = map output $ scanl delta a xs

match' :: Eq a => [[a]] -> [a] -> [[[a]]]
match' pat = match (buildAutomaton $ map (\x-> (x,[x])) pat)

isInfixOf :: Eq a => [a] -> [a] -> Bool
isInfixOf xs ys = getAll $ mconcat $ match (buildAutomaton [(xs, All True)]) ys
