module Utility exposing
    ( fst
    , snd
    , sortByDescending
    )


snd : ( a, b ) -> b
snd ( x, y ) =
    y


fst : ( a, b ) -> a
fst ( x, y ) =
    x


sortByDescending : (a -> comparable) -> List a -> List a
sortByDescending f =
    List.sortBy f >> List.reverse
