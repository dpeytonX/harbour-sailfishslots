import QtQuick 2.2

SequentialAnimation {
    id: spinAnim
    property variant target
    property int duration

    NumberAnimation {
        target: spinAnim.target
        property: "opacity"
        from: 1
        to: 0.1
        duration: spinAnim.duration / 2
        easing.type: Easing.InOutQuad
    }
    NumberAnimation {
        target: spinAnim.target
        property: "opacity"
        from: 0.1
        to: 1
        duration: spinAnim.duration / 2
        easing.type: Easing.OutInExpo
    }
}
