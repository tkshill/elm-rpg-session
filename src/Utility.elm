module Utility exposing
    ( fst
    , snd
    )


snd : ( a, b ) -> b
snd ( x, y ) =
    y


fst : ( a, b ) -> a
fst ( x, y ) =
    x
