module Model exposing (..)

-- MODEL


type alias ApiResponse =
    { name : String }


type alias WithLoaded a =
    { a | loaded : Bool, downloaded : Bool }


type alias ModelData =
    WithLoaded ApiResponse


type Model
    = Failure
    | Loading
    | Success { models : List ModelData }