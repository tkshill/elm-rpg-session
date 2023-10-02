module Components exposing (LabelValue(..), viewBlockInput, viewCheckBox, viewSimpleInput)

import Element exposing (Element, text)
import Element.Input as Input exposing (defaultCheckbox, placeholder)


type alias PlaceholderText =
    String


type alias LabelText =
    String


type alias ModelText =
    String


type alias Updater a =
    String -> a


type alias CheckboxUpdater a =
    Bool -> a


type alias CheckboxValue =
    Bool


type LabelValue msg
    = ElementLabelValue (Element msg)
    | StringLabelValue String


viewSimpleInput : Updater a -> LabelText -> PlaceholderText -> ModelText -> Element a
viewSimpleInput updater labelText placeholderText modelText =
    Input.text []
        { onChange = updater
        , text = modelText
        , placeholder = Just <| placeholder [] <| text placeholderText
        , label = Input.labelAbove [] <| text labelText
        }


viewBlockInput : Updater a -> LabelText -> PlaceholderText -> ModelText -> Element a
viewBlockInput updater labelText placeholderText modelText =
    Input.multiline []
        { onChange = updater
        , text = modelText
        , placeholder = Just <| placeholder [] <| text placeholderText
        , label = Input.labelAbove [] <| text labelText
        , spellcheck = False
        }


viewCheckBox : CheckboxUpdater a -> LabelValue a -> CheckboxValue -> Element a
viewCheckBox updater labelvalue checkboxValue =
    let
        labelElement =
            case labelvalue of
                StringLabelValue labelText ->
                    text labelText

                ElementLabelValue element ->
                    element
    in
    Input.checkbox []
        { onChange = updater
        , icon = defaultCheckbox
        , checked = checkboxValue
        , label = Input.labelAbove [] <| labelElement
        }
