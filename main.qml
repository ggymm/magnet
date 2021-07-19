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
            url: "test"
            name: "测试网站"
        }
        ListElement {
            url: "test1"
            name: "测试网站1"
        }
    }

    ListModel {
        id: result_data
        ListElement {
            name: "蜘蛛侠：英雄归来.2017.1080p.国英双语.中英字幕￡CMCT梦幻"
            hot: "99"
            time: "2020-07-19 10:43"
            size: "12.00GB"
        }
        ListElement {
            name: "蜘蛛侠：英雄归来.2017.1080p.国英双语.中英字幕￡CMCT梦幻"
            hot: "99"
            time: "2020-07-19 10:43"
            size: "12.00GB"
        }
        ListElement {
            name: "蜘蛛侠：英雄归来.2017.1080p.国英双语.中英字幕￡CMCT梦幻"
            hot: "99"
            time: "2020-07-19 10:43"
            size: "12.00GB"
        }
        ListElement {
            name: "蜘蛛侠：英雄归来.2017.1080p.国英双语.中英字幕￡CMCT梦幻"
            hot: "99"
            time: "2020-07-19 10:43"
            size: "12.00GB"
        }
        ListElement {
            name: "蜘蛛侠：英雄归来.2017.1080p.国英双语.中英字幕￡CMCT梦幻"
            hot: "99"
            time: "2020-07-19 10:43"
            size: "12.00GB"
        }
        ListElement {
            name: "蜘蛛侠：英雄归来.2017.1080p.国英双语.中英字幕￡CMCT梦幻"
            hot: "99"
            time: "2020-07-19 10:43"
            size: "12.00GB"
        }
        ListElement {
            name: "蜘蛛侠：英雄归来.2017.1080p.国英双语.中英字幕￡CMCT梦幻"
            hot: "99"
            time: "2020-07-19 10:43"
            size: "12.00GB"
        }
        ListElement {
            name: "蜘蛛侠：英雄归来.2017.1080p.国英双语.中英字幕￡CMCT梦幻"
            hot: "99"
            time: "2020-07-19 10:43"
            size: "12.00GB"
        }
        ListElement {
            name: "蜘蛛侠：英雄归来.2017.1080p.国英双语.中英字幕￡CMCT梦幻"
            hot: "99"
            time: "2020-07-19 10:43"
            size: "12.00GB"
        }
        ListElement {
            name: "蜘蛛侠：英雄归来.2017.1080p.国英双语.中英字幕￡CMCT梦幻"
            hot: "99"
            time: "2020-07-19 10:43"
            size: "12.00GB"
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
            textRole: "name"
            valueRole: "url"
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
        id: result_data
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

        model: result_data

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