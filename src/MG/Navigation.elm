module MG.Navigation exposing (forwardLink, backLink)

{-|


# Navigation

@docs forwardLink, backLink

-}

import Element exposing (..)
import MG.Icons as Icons
import Url exposing (Url)


type Link
    = Forward
    | Back


link : Link -> Url -> String -> Element msg
link linkType url labelStr =
    Element.link []
        { url = Url.toString url
        , label =
            row [ spacing 10 ]
                [ case linkType of
                    Forward ->
                        none

                    Back ->
                        el [] <| Icons.leftArrow 22
                , el [] <| text labelStr
                , case linkType of
                    Forward ->
                        el [] <| Icons.rightArrow 22

                    Back ->
                        none
                ]
        }


{-| -}
forwardLink : Url -> String -> Element msg
forwardLink =
    link Forward


{-| -}
backLink : Url -> String -> Element msg
backLink =
    link Back
