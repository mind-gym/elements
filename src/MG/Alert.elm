module MG.Alert exposing (Alert, error, success, render)

{-|


# Alerts

Alert messages, used to display errors and other important information.

@docs Alert, error, success, render

-}

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import MG.Colours exposing (colours)
import MG.Icons as Icons
import MG.Typography as Typography
import MG.Viewport exposing (Viewport)


{-| -}
type Alert
    = Alert { content : List String } AlertType


{-| -}
type AlertType
    = Error
    | Success


view : Viewport -> Alert -> Element msg
view viewport (Alert { content } alertType) =
    let
        ( baseStyles, icon ) =
            case alertType of
                Error ->
                    ( [ Background.color colours.red600
                      ]
                    , Icons.warning 20
                    )

                Success ->
                    ( [ Font.color colours.black
                      , Background.color colours.green
                      ]
                    , Icons.success 20
                    )

        styles =
            baseStyles
                ++ [ padding 24
                   , Border.rounded 10
                   , width fill
                   ]
                ++ Typography.noteS.regular viewport
    in
    el
        styles
    <|
        row
            [ spacing 8
            , width fill
            ]
            [ el [ alignTop ] icon
            , column
                [ width fill
                , spacing 10
                ]
                (content
                    |> List.indexedMap
                        (\i str ->
                            paragraph [ alignTop ]
                                [ el
                                    [ if i == 0 then
                                        Font.bold

                                      else
                                        Font.regular
                                    ]
                                  <|
                                    text str
                                ]
                        )
                )
            ]


{-|

    Because we generally expect alerts to be displayed conditionally, this function takes a `Maybe Alert`. If the value is `Nothing`, then no alert is rendered.

-}
render : Viewport -> Maybe Alert -> Element msg
render viewport maybeAlert =
    case maybeAlert of
        Just alert ->
            view viewport alert

        Nothing ->
            none


{-| -}
error : List String -> Alert
error content =
    Alert { content = content } Error


{-| -}
success : List String -> Alert
success content =
    Alert { content = content } Success
