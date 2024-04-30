module MG.Navigation exposing (forwardLink, backLink, textLink, buttonLink)

{-|


# Navigation

@docs forwardLink, backLink, textLink, buttonLink

-}

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import MG.Attributes as Attributes
import MG.Colours exposing (colours)
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


{-| An ordinary text link
-}
textLink : { text : String, url : String, testId : String } -> Element msg
textLink params =
    Element.link
        [ Font.color colours.green700
        , Font.underline
        ]
        { url = params.url
        , label = text params.text
        }


{-| A link styled to look like a button
-}
buttonLink : { text : String, url : String, testId : String } -> Element msg
buttonLink params =
    Element.link
        [ Background.color colours.green400
        , padding 16
        , Border.rounded 50
        , Border.color colours.green400
        , Border.width 2
        , Font.color colours.black
        , Font.size 16
        , Font.medium
        , Attributes.transition
        , Attributes.testIdentifier params.testId
        , mouseOver
            [ Background.color colours.white
            , scale 1.02
            ]
        ]
        { url = params.url
        , label = text params.text
        }
