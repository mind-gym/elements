module MG.Input exposing
    ( email
    , primaryButton, secondaryButton
    )

{-|


# Input fields

@docs email


# Controls

@docs primaryButton, secondaryButton

-}

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import MG.Attributes as Attributes
import MG.Colours exposing (colours)
import MG.Typography as Typography
import MG.Viewport exposing (Viewport)


placeholder :
    { viewport : Viewport
    , fieldIsFocused : Bool
    , fieldHasValue : Bool
    , str : String
    }
    -> Element.Attribute msg
placeholder { viewport, fieldIsFocused, fieldHasValue, str } =
    inFront <|
        el
            (Typography.bodyS.regular viewport
                ++ [ paddingXY 20 0
                   , Font.color colours.black300
                   , Attributes.transition
                   ]
                ++ (if
                        fieldIsFocused
                            || fieldHasValue
                    then
                        [ scale 0.7
                        , moveLeft 21
                        ]

                    else
                        [ moveDown 14 ]
                   )
            )
        <|
            text str


{-| Common email field with animated placeholder
-}
email :
    { onChange : String -> msg
    , value : String
    , errorStr : Maybe String
    , onSubmit : Maybe msg
    , isFocused : Bool
    , viewport : Viewport
    }
    -> Element msg
email { value, errorStr, onSubmit, onChange, isFocused, viewport } =
    let
        baseAttrs =
            case onSubmit of
                Just submitMsg ->
                    [ Attributes.onEnter submitMsg ]

                Nothing ->
                    []

        errorColour =
            colours.red500
    in
    column
        [ width fill
        , spacing 10
        ]
        [ Input.email
            (baseAttrs
                ++ [ Background.color colours.black700
                   , Border.rounded 10
                   , Border.width 1
                   , Border.color <|
                        case errorStr of
                            Just _ ->
                                errorColour

                            Nothing ->
                                if isFocused then
                                    colours.green

                                else
                                    colours.black700
                   , paddingXY 20 16
                   , Font.size 14
                   , placeholder
                        { viewport = viewport
                        , fieldIsFocused = isFocused
                        , fieldHasValue = not <| String.isEmpty value
                        , str = "Your email address"
                        }
                   ]
            )
            { label = Input.labelHidden "Your email address"
            , onChange = onChange
            , placeholder = Nothing
            , text = value
            }
        , el [ height <| px 20 ] <|
            case errorStr of
                Nothing ->
                    none

                Just str ->
                    el (Font.color errorColour :: Typography.noteS.regular viewport) <|
                        text str
        ]


type Button
    = Primary
    | Secondary { transparent : Bool }


type alias ButtonParams msg =
    { labelText : String
    , testId : String
    , msg : msg
    }


button : Button -> ButtonParams msg -> Element msg
button buttonType { msg, labelText, testId } =
    let
        buttonFontSize : Element.Attribute msg
        buttonFontSize =
            Font.size 16
    in
    Input.button
        (case buttonType of
            Primary ->
                [ width fill
                , Background.color colours.green400
                , padding 16
                , Border.rounded 50
                , Font.color colours.black
                , buttonFontSize
                , Font.medium
                , Attributes.transition
                , Attributes.testIdentifier testId
                , mouseOver
                    [ Background.color colours.white
                    , scale 1.1
                    ]
                ]

            Secondary { transparent } ->
                let
                    attributes =
                        [ width fill
                        , padding 14
                        , Border.rounded 50
                        , Border.color colours.black300
                        , Border.width 1
                        , buttonFontSize
                        , Font.medium
                        , Attributes.transition
                        , Attributes.testIdentifier testId
                        , mouseOver
                            [ Background.color colours.green400
                            , Font.color colours.white
                            ]
                        ]
                in
                if transparent then
                    Background.color colours.transparent :: attributes

                else
                    Background.color colours.bone :: attributes
        )
        { onPress = Just msg
        , label = el [ centerX ] <| text labelText
        }


{-| Common primary button
-}
primaryButton : ButtonParams msg -> Element msg
primaryButton =
    button Primary


{-| Common secondary button
-}
secondaryButton : ButtonParams msg -> Element msg
secondaryButton =
    button <| Secondary { transparent = False }
