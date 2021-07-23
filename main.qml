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
        function onLoadStateChanged(state) {
            if (state === "loading") {
                search.text = "正在加载数据"
                search.enabled = false
            } else if (state === "loaded") {
                search.text = "搜索"
                search.enabled = true
            }
        }
    }

    ListModel {
        id: website_list
        ListElement {
            key: "all"
            value: "聚合搜索"
        }
        ListElement {
            key: "btgg"
            value: "BTGG"
        }
        ListElement {
            key: "btsow"
            value: "BTSOW(代理)"
        }
        ListElement {
            key: "btsow_shadow"
            value: "BTSOW(非代理)"
        }
    }

    Popup {
        id: myPopup
        x: (main.width-width)/2
        y: (main.height-height)/2
        width: 360
        height: 360
    }

     menuBar: MenuBar {
        Menu {
            title: "磁力链接搜索"
            MenuItem {
                text: "加载规则文件"
                onTriggered: console.log("加载规则文件");
            }
            MenuItem {
                text: "退出"
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: "设置"
            MenuItem {
                text: "抓取设置"
                onTriggered: console.log("抓取设置");
            }
            MenuItem {
                text: "代理设置"
                onTriggered: console.log("设置代理");
            }
        }
        Menu {
            title: "帮助"
            MenuItem {
                text: "使用手册"
                onTriggered: console.log("打开网页");
            }
            MenuItem {
                text: "关于"
                onTriggered: console.log("检查更新等");
            }
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
            currentIndex: 1
        }

        TextField {
            id: search_terms
            text: "龙珠"
            width: 520
            anchors {
                top: website.top
                left: website.right
                leftMargin: 20
            }
            hoverEnabled: false
            placeholderText: "搜索词"
            font.pointSize: 12
        }

        Button {
            id: search
            width: 120
            anchors {
                top: search_terms.top
                left: search_terms.right
                leftMargin: 20
            }
            text: "搜索"
            onClicked: {
                backend.search(website.currentValue, search_terms.text)
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
                        text: "热度: " + model.hot
                        color: "gray"
                        font.pixelSize: 12
                    }

                    Label {
                        text: "文件大小: " + model.size
                        color: "gray"
                        font.pixelSize: 12
                    }

                    Label {
                        text: "创建时间: " + model.time
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
                    onClicked: {
                        myPopup.open()
                    }
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
                    onClicked: {
                    }
                }
            }
        }
    }
}