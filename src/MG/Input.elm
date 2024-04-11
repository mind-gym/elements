module MG.Input exposing
    ( enabledEmail, disabledEmail
    , primaryButton, secondaryButton
    , currentPassword, newPassword
    )

{-|


# Input fields

@docs enabledEmail, disabledEmail, newPassword, currentPassword


# Controls

@docs primaryButton, secondaryButton

-}

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Events exposing (onSubmit)
import MG.Attributes as Attributes
import MG.Colours exposing (colours)
import MG.Icons as Icons
import MG.Typography as Typography
import MG.Viewport exposing (Viewport)
import Material.Icons exposing (password)


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
    , onEnter : msg
    }


baseFieldAttrs : Maybe msg -> Viewport -> List (Element.Attribute msg)
baseFieldAttrs onSubmit viewport =
    [ Background.color colours.black700
    , Border.rounded 10
    , Border.width 1
    , padding 18
    ]
        ++ (case onSubmit of
                Just submitMsg ->
                    [ Attributes.onEnter submitMsg ]

                Nothing ->
                    []
           )
        ++ Typography.bodyS.regular viewport


insetButtonStyles : List (Attribute msg)
insetButtonStyles =
    [ alignRight
    , centerY
    , Background.color colours.black700
    , Font.size 14
    , Font.color colours.white
    , height fill
    , paddingXY 18 0
    , Border.rounded 10
    , mouseOver
        [ Font.color colours.black200
        ]
    ]


email :
    EmailField msg
    -> Element msg
email (EmailField { viewport, value, onSubmit, isFocused } emailType) =
    case emailType of
        Enabled { errorStr, onChange, onEnter } ->
            let
                errorColour =
                    colours.red500

                specificStyles =
                    [ Attributes.onEnter onEnter
                    , Background.color colours.black700
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
                    (baseFieldAttrs onSubmit viewport
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
                            insetButtonStyles
                            { label = text "Change"
                            , onPress = onSubmit
                            }
                    ]
            in
            row
                (baseFieldAttrs onSubmit viewport
                    ++ specificStyles
                )
                [ el [] <| text value
                ]


{-| Common email field with animated placeholder
-}
enabledEmail :
    { onChange : String -> msg
    , onEnter : msg
    , value : String
    , errorStr : Maybe String
    , onSubmit : Maybe msg
    , isFocused : Bool
    , viewport : Viewport
    }
    -> Element msg
enabledEmail { onChange, value, errorStr, onEnter, onSubmit, isFocused, viewport } =
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
                , onEnter = onEnter
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


type PasswordField
    = New { note : Maybe String }
    | Current


type alias PasswordFieldParams msg =
    { onChange : String -> msg
    , value : String
    , showValue : Bool
    , togglePasswordVisibility : Bool -> msg
    , viewport : Viewport
    , onSubmit : Maybe msg
    , isFocused : Bool
    }


password :
    PasswordField
    -> PasswordFieldParams msg
    -> Element msg
password passwordField { onChange, value, showValue, onSubmit, viewport, isFocused, togglePasswordVisibility } =
    let
        labelText =
            case passwordField of
                New _ ->
                    "Set your password"

                Current ->
                    "Your password"
    in
    column
        [ width fill
        , spacing 10
        ]
        [ (case passwordField of
            Current ->
                Input.currentPassword

            New _ ->
                Input.newPassword
          )
            ([ Border.color <|
                if isFocused then
                    colours.green

                else
                    colours.black700
             , placeholder
                { viewport = viewport
                , fieldIsFocused = isFocused
                , fieldHasValue = not <| String.isEmpty value
                , str = labelText
                }
             , inFront <|
                Input.button
                    insetButtonStyles
                    { label =
                        row [ spacing 6 ] <|
                            if showValue then
                                [ el [] <| text "Hide"
                                , el [] <| Icons.hide 20
                                ]

                            else
                                [ el [] <| text "Show"
                                , el [] <| Icons.show 20
                                ]
                    , onPress =
                        Just <|
                            togglePasswordVisibility <|
                                not showValue
                    }
             ]
                ++ baseFieldAttrs onSubmit viewport
            )
            { label = Input.labelHidden labelText
            , onChange = onChange
            , placeholder = Nothing
            , text = value
            , show = showValue
            }
        , case passwordField of
            New { note } ->
                case note of
                    Just str ->
                        paragraph [ width fill ]
                            [ el (Font.color colours.white :: Typography.noteS.regular viewport) <|
                                text str
                            ]

                    Nothing ->
                        none

            Current ->
                none
        ]

{-| New password field with animated placeholder with optional note below the input field. -}
newPassword : { note : Maybe String } -> PasswordFieldParams msg -> Element msg
newPassword note =
    password (New note)


{-| Current password field with animated placeholder -}
currentPassword : PasswordFieldParams msg -> Element msg
currentPassword =
    password Current


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
