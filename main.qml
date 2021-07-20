import QtQuick 6
import QtQuick.Window 2.5
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.5

ApplicationWindow {
    id: main
    title: "磁力链接搜索"
    width: 1280
    height: 720
    minimumWidth: 960
    minimumHeight: 540
    visible: true
    visibility: Window.Windowed

    Material.theme: Material.Dark

    Connections {
        target : backend
    }

    ListModel {
        id: website_list
        ListElement {
            key: "zhongzisou"
            value: "种子搜"
        }
        ListElement {
            key: "btgg"
            value: "BTGG"
        }
        ListElement {
            key: "idope"
            value: "idope"
        }
        ListElement {
            key: "btsow"
            value: "BTSOW"
        }
        ListElement {
            key: "btdet"
            value: "BT蚂蚁"
        }
        ListElement {
            key: "bt4g"
            value: "BT4G"
        }
        ListElement {
            key: "btdb"
            value: " BTDB"
        }
        ListElement {
            key: "btdiguo"
            value: "BT目录"
        }
        ListElement {
            key: "cilibao"
            value: "磁力宝"
        }
        ListElement {
            key: "bthub"
            value: "BThub"
        }
        ListElement {
            key: "btdad"
            value: " Btdad"
        }
        ListElement {
            key: "alibt"
            value: " 阿里BT"
        }
        ListElement {
            key: "mag"
            value: "MAG磁力站"
        }
        ListElement {
            key: "clzz"
            value: "磁力蜘蛛"
        }
        ListElement {
            key: "ciligou"
            value: " 磁力狗"
        }
        ListElement {
            key: "ciliba"
            value: " 磁力吧"
        }
        ListElement {
            key: "btfox"
            value: " btfox"
        }
        ListElement {
            key: "kickass"
            value: "KickassTorrents"
        }
        ListElement {
            key: "zooqle"
            value: "Zooqle"
        }
        ListElement {
            key: "nyaa"
            value: "Nyaa"
        }
        ListElement {
            key: "sukebei"
            value: "Sukebei Nyaa"
        }
        ListElement {
            key: "sobt"
            value: " Sobt"
        }
        ListElement {
            key: "dmhy"
            value: "动漫花园"
        }
        ListElement {
            key: "thepiratebay_z"
            value: "The Pirate Bay"
        }
        ListElement {
            key: "extratorrent"
            value: "ExtraTorrent"
        }
        ListElement {
            key: "1337x"
            value: "1337X（英文）"
        }
    }

    Item {
        id: search_info
        height: 80

        ComboBox {
            id: website
            x: 40
            y: 20
            width: 200
            model: website_list
            textRole: "value"
            valueRole: "key"
        }

        TextField {
            id: keyword
            width: 520
            anchors {
                top: website.top
                left: website.right
                leftMargin: 20
            }
            placeholderText: "搜索词"
            font.pointSize: 12
        }

        Button {
            id: search
            width: 120
            anchors {
                top: keyword.top
                left: keyword.right
                leftMargin: 20
            }
            text: "搜索"
            onClicked: {
                backend.search(website.currentValue, keyword.text)
            }
        }
    }

    ListView {
        id: search_result
        anchors {
            top: search_info.bottom
            right: parent.right
            bottom: parent.bottom
            left: parent.left
            topMargin: 20
            rightMargin: 40
            bottomMargin: 20
            leftMargin: 40
        }
        spacing: 20
        clip: true
        ScrollBar.vertical: ScrollBar {}
        boundsBehavior: Flickable.StopAtBounds

        model: backend.search_result_list

        delegate: Item {
            width: main.width - 80
            height: 80

            Column {
                id: info
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                Label {
                    text: model.name
                    font.pixelSize: 16
                    bottomPadding: 20
                }

                Row {
                    spacing: 20

                    Label {
                        text: model.time
                        color: "gray"
                        font.pixelSize: 12
                    }

                    Label {
                        text: model.size
                        color: "gray"
                        font.pixelSize: 12
                    }

                    Label {
                        text: model.hot
                        color: "gray"
                        font.pixelSize: 12
                    }
                }
            }

            Row {
                anchors {
                    right: parent.right
                    rightMargin: 40
                    verticalCenter: parent.verticalCenter
                }
                spacing: 20

                Button {
                    id: qrcode
                    height: 40
                    text: "二维码"
                }

                Button {
                    id: download
                    height: 40
                    text: "迅雷下载"
                    onClicked: {
                        backend.download(model.magnet)
                    }
                }

                Button {
                    id: copy_url
                    height: 40
                    text: "复制链接"
                }
            }
        }
    }
}