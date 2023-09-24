module Players exposing
    ( Hunter(..)
    , Keeper(..)
    , PlaybookName(..)
    , Player(..)
    , PlayerName
    , playbookNameToString
    )

import Monstrous exposing (MonstrousName)
import UUID exposing (UUID)


type alias PlayerName =
    String


type alias PlayerID =
    UUID


type Keeper
    = Keeper PlayerID PlayerName


type Hunter
    = Hunter PlayerID PlayerName


type Player
    = K Keeper
    | H Hunter


type PlaybookName
    = M MonstrousName


playbookNameToString : PlaybookName -> String
playbookNameToString playbook =
    case playbook of
        M name ->
            Monstrous.toString name
