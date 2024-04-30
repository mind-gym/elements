module MG.Content exposing
    ( pageHeading, pageSubHeading, title, paragraph, titleAndTextContent
    , progressBar
    )

{-|


# Text Content

@docs pageHeading, pageSubHeading, title, paragraph, titleAndTextContent


# Misc.

@docs progressBar

-}

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import MG.Attributes as Attributes
import MG.Colours exposing (colours)
import MG.Typography as Typography
import MG.Viewport as Viewport


{-| A progress bar that fills from left to right.
-}
progressBar : { viewport : Viewport.Viewport, totalSteps : Int, currentStep : Int } -> Element msg
progressBar { totalSteps, currentStep, viewport } =
    let
        commonStyle =
            [ height <|
                px <|
                    case viewport.size of
                        Viewport.AtLeast1440Wide ->
                            18

                        _ ->
                            12
            , width fill
            , Border.rounded 10
            , Background.color colours.bone200
            ]
    in
    row commonStyle
        [ el
            (commonStyle
                ++ [ Background.color colours.green
                   , width <| fillPortion currentStep
                   , Attributes.transition
                   ]
            )
          <|
            none
        , el
            [ width <|
                fillPortion <|
                    totalSteps
                        - currentStep
            ]
            none
        ]


{-| -}
pageHeading : { viewport : Viewport.Viewport, text : String } -> Element msg
pageHeading params =
    Element.paragraph
        (Typography.headingL params.viewport ++ [ Font.light ])
        [ el [] <|
            text params.text
        ]


{-| -}
pageSubHeading : { viewport : Viewport.Viewport, text : String } -> Element msg
pageSubHeading params =
    Element.paragraph
        (Typography.headingL params.viewport
            ++ [ Font.color colours.black500
               , Font.light
               ]
        )
        [ el [] <|
            text params.text
        ]


{-| -}
title : { viewport : Viewport.Viewport, title : String } -> Element msg
title params =
    Element.paragraph
        (Typography.leadS params.viewport
            ++ [ Font.color colours.black600
               , Font.bold
               ]
        )
        [ text params.title ]


{-| -}
paragraph : { viewport : Viewport.Viewport, paragraph : List (Element msg) } -> Element msg
paragraph params =
    Element.paragraph
        (Font.color colours.black600
            :: Typography.leadS params.viewport
        )
    <|
        List.intersperse
            (text " ")
            params.paragraph


{-| We regularly find ourselves wanting to group titles and a paragraph, which is what this element is for.
-}
titleAndTextContent : { viewport : Viewport.Viewport, title : String, content : List (Element msg) } -> Element msg
titleAndTextContent params =
    column
        [ spacing 16
        , width fill
        ]
        [ title
            { viewport = params.viewport
            , title = params.title
            }
        , paragraph
            { viewport = params.viewport
            , paragraph = params.content
            }
        ]
