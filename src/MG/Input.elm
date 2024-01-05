module MG.Input exposing
    ( enabledEmail, disabledEmail
    , primaryButton, secondaryButton
    )

{-|


# Input fields

@docs enabledEmail, disabledEmail


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
                        , moveLeft 22
                        ]

                    else
                        [ moveDown 20 ]
                   )
            )
        <|
            text str


type EmailField msg
    = EmailField
        { viewport : Viewport
        , value : String
        , onSubmit : Maybe msg
        , isFocused : Bool
        }
        (EmailType msg)


type EmailType msg
    = Enabled (EnabledEmailParams msg)
    | Disabled


type alias EnabledEmailParams msg =
    { onChange : String -> msg
    , errorStr : Maybe String
    }


email :
    EmailField msg
    -> Element msg
email (EmailField { viewport, value, onSubmit, isFocused } emailType) =
    let
        baseAttrs =
            [ Background.color colours.black700
            , Border.rounded 10
            , Border.width 1
            , paddingXY 18 20
            ]
                ++ (case onSubmit of
                        Just submitMsg ->
                            [ Attributes.onEnter submitMsg ]

                        Nothing ->
                            []
                   )
                ++ Typography.bodyS.regular viewport
    in
    case emailType of
        Enabled { errorStr, onChange } ->
            let
                errorColour =
                    colours.red500

                specificStyles =
                    [ Background.color colours.black700
                    , width fill
                    , Border.color <|
                        case errorStr of
                            Just _ ->
                                errorColour

                            Nothing ->
                                if isFocused then
                                    colours.green

                                else
                                    colours.black700
                    , placeholder
                        { viewport = viewport
                        , fieldIsFocused = isFocused
                        , fieldHasValue = not <| String.isEmpty value
                        , str = "Your email address"
                        }
                    ]
            in
            column
                [ width fill
                , spacing 10
                ]
                [ Input.email
                    (baseAttrs
                        ++ specificStyles
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

        Disabled ->
            let
                specificStyles =
                    [ width fill
                    , placeholder
                        { viewport = viewport
                        , fieldIsFocused = isFocused
                        , fieldHasValue = True
                        , str = "Your email address"
                        }
                    , Font.color colours.black300
                    , Border.color <|
                        if isFocused then
                            colours.green

                        else
                            colours.black700
                    , inFront <|
                        Input.button
                            [ alignRight
                            , centerY
                            , Background.color colours.black700
                            , Font.size 14
                            , Font.color colours.white
                            , padding 20
                            , Border.rounded 10
                            , mouseOver
                                [ Font.color colours.black200
                                ]
                            ]
                            { label = text "Change"
                            , onPress = onSubmit
                            }
                    ]
            in
            row
                (baseAttrs
                    ++ specificStyles
                )
                [ el [] <| text value
                ]


{-| Common email field with animated placeholder
-}
enabledEmail :
    { onChange : String -> msg
    , value : String
    , errorStr : Maybe String
    , onSubmit : Maybe msg
    , isFocused : Bool
    , viewport : Viewport
    }
    -> Element msg
enabledEmail { onChange, value, errorStr, onSubmit, isFocused, viewport } =
    email <|
        EmailField
            { viewport = viewport
            , value = value
            , onSubmit = onSubmit
            , isFocused = isFocused
            }
            (Enabled
                { onChange = onChange
                , errorStr = errorStr
                }
            )


{-| An element that looks like an input field, but is disabled and contains a button to change the value. For use when a user has already entered their email address. `value` is a (Char, String) to ensure that this element can not be created with an empty value.
-}
disabledEmail :
    { value : ( Char, String )
    , enableMsg : msg
    , viewport : Viewport
    , isFocused : Bool
    }
    -> Element msg
disabledEmail { value, enableMsg, viewport, isFocused } =
    email <|
        EmailField
            { viewport = viewport
            , value = String.fromChar (Tuple.first value) ++ Tuple.second value
            , onSubmit = Just enableMsg
            , isFocused = isFocused
            }
            Disabled


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
