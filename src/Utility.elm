module Utility exposing
    ( State
    , fst
    , snd
    , sortByDescending
    , thunk
    , withCmd
    , withModel
    , withNoCmd
    )


type alias State a b =
    ( a, Cmd b )


snd : ( a, b ) -> b
snd ( x, y ) =
    y


fst : ( a, b ) -> a
fst ( x, y ) =
    x


sortByDescending : (a -> comparable) -> List a -> List a
sortByDescending f =
    List.sortBy f >> List.reverse


withNoCmd : a -> ( a, Cmd msg )
withNoCmd value =
    ( value, Cmd.none )


withModel : a -> Cmd msg -> ( a, Cmd msg )
withModel value cmd =
    ( value, cmd )


withCmd : Cmd msg -> a -> ( a, Cmd msg )
withCmd cmd value =
    ( value, cmd )



{-
   Delays a computation until it is needed.
-}


thunk : a -> () -> a
thunk value =
    \_ -> value
