module MG.Input exposing
    ( enabledEmail, disabledEmail, newPassword, currentPassword, plainEmailField
    , primaryButton, secondaryButton, radioButton
    , OptionParams, ratingScale
    )

{-|


# Input fields

@docs enabledEmail, disabledEmail, newPassword, currentPassword, plainEmailField


# Controls

@docs primaryButton, secondaryButton, radioButton


# Misc.

@docs OptionParams, ratingScale

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
import MG.Viewport as Viewport exposing (Viewport)
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
                [ Input.username
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


{-| A plain white e-mail field with no animations
-}
plainEmailField : { onChange : String -> msg, value : String } -> Element msg
plainEmailField { onChange, value } =
    Input.email
        [ Border.rounded 20
        , padding 16
        , Border.width 0
        ]
        { onChange = onChange
        , text = value
        , placeholder = Just <| Input.placeholder [] <| text "email@example.com"
        , label = Input.labelHidden "Email address"
        }


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


{-| New password field with animated placeholder with optional note below the input field.
-}
newPassword : { note : Maybe String } -> PasswordFieldParams msg -> Element msg
newPassword note =
    password (New note)


{-| Current password field with animated placeholder
-}
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


{-| Needed for use with ratingScale
-}
type alias OptionParams ratingValue =
    { rating : ratingValue
    , name : Maybe String
    , description : Maybe String
    }


largeViewportScaleBorderRadius : Int
largeViewportScaleBorderRadius =
    16


ratingSelectedBorderColour : Color
ratingSelectedBorderColour =
    rgb255 0 227 184


{-| A simple radio button
-}
radioButton : Input.OptionState -> Element msg
radioButton state =
    let
        styles =
            { border =
                if state == Input.Selected then
                    5

                else
                    1
            , padding =
                if state == Input.Selected then
                    6

                else
                    10
            }
    in
    el
        [ paddingEach
            { top = 0
            , right = 2
            , left = 16
            , bottom = 0
            }
        ]
    <|
        el
            [ Border.rounded 100
            , Border.width styles.border
            , padding styles.padding
            ]
        <|
            none


renderOption :
    Viewport.Viewport
    -> OptionParams ratingValue
    -> Input.OptionState
    -> Element msg
renderOption viewport option state =
    let
        below1024 =
            row
                [ Attributes.transition
                , width fill
                , Background.color colours.white
                , padding 16
                , Border.rounded 8
                , Border.width 2
                , Border.color <|
                    if state == Input.Selected then
                        ratingSelectedBorderColour

                    else
                        colours.white
                , spacing 10
                , mouseOver
                    [ scale <|
                        if state == Input.Selected then
                            1

                        else
                            1.02
                    ]
                ]
                [ radioButton state
                , column
                    [ width fill
                    , spacing 8
                    ]
                    [ el
                        (Typography.headingXS viewport
                            ++ [ Font.light ]
                        )
                      <|
                        text <|
                            Maybe.withDefault "" option.name
                    , Element.paragraph
                        (Typography.noteL.medium viewport
                            ++ [ Font.color colours.black400
                               , Font.light
                               ]
                        )
                        [ text <| Maybe.withDefault "" option.description
                        ]
                    ]
                ]

        above1024 =
            el
                [ width fill
                , Background.color colours.white
                , Border.rounded largeViewportScaleBorderRadius
                ]
            <|
                column
                    [ width fill
                    , padding 24
                    , spacing 10
                    , Attributes.transition
                    , mouseOver
                        [ scale <|
                            if state == Input.Selected then
                                1

                            else
                                1.1
                        ]
                    ]
                    [ el
                        [ centerX
                        ]
                      <|
                        radioButton state
                    , el
                        (Typography.noteL.medium viewport
                            ++ [ Font.light
                               ]
                        )
                      <|
                        text <|
                            Maybe.withDefault "" option.name
                    ]
    in
    case viewport.size of
        Viewport.Default360 ->
            below1024

        Viewport.AtLeast768Wide ->
            below1024

        _ ->
            above1024


{-| A rating scale - can handle any type as a value. Vertically displayed on smaller viewports, and horizontally displayed on larger viewports.
-}
ratingScale :
    { viewport : Viewport.Viewport
    , options :
        List (OptionParams ratingValue)
    , selected :
        Maybe (OptionParams ratingValue)
    , onSelect : OptionParams ratingValue -> msg
    }
    -> Element msg
ratingScale { options, viewport, onSelect, selected } =
    let
        optionsToRender =
            options
                |> List.map
                    (\o ->
                        Input.optionWith o (renderOption viewport o)
                    )

        requiresColumn =
            case viewport.size of
                Viewport.Default360 ->
                    True

                Viewport.AtLeast768Wide ->
                    True

                _ ->
                    False

        borderWidths =
            { top = 2
            , right = 2
            , bottom = 2
            , left = 2
            }
    in
    column
        [ width fill
        ]
        [ (if requiresColumn then
            Input.radio

           else
            Input.radioRow
          )
            [ width fill
            , if requiresColumn then
                spacing 10

              else
                spaceEvenly
            , Background.color <|
                if requiresColumn then
                    colours.bone

                else
                    colours.white
            , Border.widthEach <|
                if requiresColumn || selected == Nothing then
                    borderWidths

                else
                    { borderWidths | bottom = 0 }
            , Border.color <|
                if requiresColumn then
                    colours.bone

                else
                    case selected of
                        Just _ ->
                            ratingSelectedBorderColour

                        Nothing ->
                            colours.white
            , if requiresColumn || selected == Nothing then
                Border.rounded largeViewportScaleBorderRadius

              else
                Border.roundEach
                    { topLeft = largeViewportScaleBorderRadius
                    , topRight = largeViewportScaleBorderRadius
                    , bottomLeft = 0
                    , bottomRight = 0
                    }
            ]
            { onChange = onSelect
            , selected = selected
            , options = optionsToRender
            , label =
                Input.labelHidden "Rating"
            }
        , case selected of
            Nothing ->
                none

            Just selectedOption ->
                if requiresColumn then
                    none

                else if selectedOption.description == Nothing then
                    el
                        [ width fill
                        , Border.widthEach { borderWidths | top = 0 }
                        , Border.roundEach
                            { topLeft = 0
                            , topRight = 0
                            , bottomLeft = largeViewportScaleBorderRadius
                            , bottomRight = largeViewportScaleBorderRadius
                            }
                        , height <| px largeViewportScaleBorderRadius
                        , Background.color colours.white
                        , Border.color ratingSelectedBorderColour
                        ]
                    <|
                        none

                else
                    paragraph
                        (Typography.noteL.medium viewport
                            ++ [ Font.light
                               , width fill
                               , Background.color colours.bone300
                               , Border.roundEach
                                    { topLeft = 0
                                    , topRight = 0
                                    , bottomLeft = largeViewportScaleBorderRadius
                                    , bottomRight = largeViewportScaleBorderRadius
                                    }
                               , Border.widthEach
                                    { top = 0
                                    , right = 2
                                    , bottom = 2
                                    , left = 2
                                    }
                               , Border.color ratingSelectedBorderColour
                               , padding 24
                               ]
                        )
                        [ text <|
                            Maybe.withDefault "" selectedOption.description
                        ]
        ]
