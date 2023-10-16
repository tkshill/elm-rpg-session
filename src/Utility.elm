module Utility exposing
    ( flip
    , sortByDescending
    , thunk
    , withCmd
    , withModel
    , withNoCmd
    )


sortByDescending : (a -> comparable) -> List a -> List a
sortByDescending f =
    List.sortBy f >> List.reverse



{-
   Returns a tuple with the empty Cmd as the second value.
-}


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


thunk : a -> b -> a
thunk value =
    \_ -> value



{-
   Inverts the order of arguments of a two parameter function.
-}


flip : (a -> b -> c) -> b -> a -> c
flip f a b =
    f b a
