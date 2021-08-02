import QtQuick 6
import QtQuick.Window 6
import QtQuick.Controls 6
import QtQuick.Layouts 6
import QtQuick.Controls.Material 6

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
        function onLoadStateChanged(state, page_num) {
            switch(state) {
                case "error":
                    search.text = "搜索"
                    search.enabled = true
                    message_info.text = "加载错误，请稍后重试"
                    message_timer.start()
                    break
                case "loading":
                    search.text = "正在搜索"
                    search.enabled = false
                    break
                case "loaded":
                    search.text = "搜索"
                    search.enabled = true
                    if (page_num > 0) {
                        var currentIndex = page.currentIndex
                        page_model.clear()
                        for (var i = 1; i <= page_num; i++) {
                            page_model.append({"key": i, "value": "第" + i + "页"})
                        }
                        page.currentIndex = currentIndex
                    }
                    break
            }
        }
    }

    ListModel {
        id: website_list_pro
        ListElement {
            key: "btsow"
            value: "BTSOW(优)"
        }
        ListElement {
            key: "btsow_proxy"
            value: "BTSOW(优)(代理)"
        }
    }

    ListModel {
        id: website_list
        ListElement {
            key: "bt113"
            value: "磁力多"
        }
        ListElement {
            key: "btgg"
            value: "BTGG(代理)"
        }
        ListElement {
            key: "btsow"
            value: "BTSOW(优)"
        }
        ListElement {
            key: "btsow_proxy"
            value: "BTSOW(优)(代理)"
        }
        ListElement {
            key: "cili"
            value: "无极磁链"
        }
        ListElement {
            key: "cursor"
            value: "光标网"
        }
        ListElement {
            key: "sofan"
            value: "搜番"
        }
    }

    Popup {
        id: qr_code_popup
        anchors.centerIn: parent
        width: 360
        height: 360
        Image {
            id: qr_code
            anchors.fill: parent
        }
    }

    Popup {
        id: message_popup
        x: (main.width-width)/2
        y: 0
        width: 200
        height: 36
        enter: Transition {
            PropertyAnimation {
                property: "y"
                to: 36
                duration: 200
            }
        }
        exit: Transition {
            PropertyAnimation {
                property: "y"
                to: 0
                duration: 200
            }
        }
        Label {
            id: message_info
            anchors.centerIn: parent
            font.pointSize: 10
            text: "消息提示"
        }
    }

    Timer {
        id: message_timer
        interval: 1000
        repeat: true
        triggeredOnStart: true
        property int message_show: 3
        onTriggered: {
            if (message_show == 3) {
                message_popup.open()
            }
            message_show -= 1
            if (message_show == 0) {
                message_show = 3
                message_timer.stop()
                message_popup.close()
            }
        }
    }

    ApplicationWindow {
        id: setting_window
        title: "设置"
        width: 800
        height: 600
        minimumWidth: 800
        minimumHeight: 600
        maximumWidth: 800
        maximumHeight: 600
        flags: Qt.Dialog
        modality: Qt.WindowModal

        Material.theme: Material.Dark
        visible: false

        Component.onCompleted: {
            console.log("请求后台数据")
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            focus: true
            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                ListModel {
                    id: setting_menu_list
                    ListElement {
                        name: "搜索设置"
                    }
                    ListElement {
                        name: "代理设置"
                    }
                    ListElement {
                        name: "缓存设置"
                    }
                }
                Component {
                    id: setting_menu_item
                    ItemDelegate {
                        width: parent.width
                        height: 36
                        highlighted: ListView.isCurrentItem

                        RowLayout {
                            anchors.fill: parent
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter

                            Label {
                                text: model.name
                                Layout.leftMargin: 8
                                Layout.rightMargin: 8
                                Layout.fillWidth: true
                            }
                        }

                        onClicked: {
                            setting_menu.currentIndex = index
                            setting_menu_content.currentIndex = index
                        }
                    }
                }

                ListView {
                    id: setting_menu
                    Layout.minimumWidth: 180
                    Layout.fillHeight: true
                    spacing: 8

                    model: setting_menu_list
                    delegate: setting_menu_item
                }
                ToolSeparator {
                    bottomPadding: -52
                    topPadding: 0
                    Layout.fillHeight: true
                }
                StackLayout {
                    id: setting_menu_content
                    currentIndex: 0
                    Layout.minimumWidth: 520
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Item {
                        Label {
                            text: "搜索设置"
                        }
                    }
                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        GridLayout {
                            rowSpacing: 16
                            columnSpacing: 20
                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right
                            }
                            columns: 2

                            Label { text: "代理类型" }
                            RowLayout {
                                width: 100
                                height: 100
                                RadioButton { hoverEnabled: false; text: "HTTP" }
                                RadioButton { hoverEnabled: false; text: "SOCKS5" }
                            }

                            Label { text: "代理地址" }
                            TextField {
                                Layout.fillWidth: true
                                hoverEnabled: false
                                selectByMouse: true
                            }

                            Label { text: "代理端口" }
                            TextField {
                                Layout.fillWidth: true
                                hoverEnabled: false
                                selectByMouse: true
                                validator: IntValidator {
                                    bottom: 0
                                    top: 65535
                                }
                            }

                            Label { text: "代理账号" }
                            TextField {
                                Layout.fillWidth: true
                                hoverEnabled: false
                                selectByMouse: true
                            }

                            Label { text: "代理密码" }
                            TextField {
                                Layout.fillWidth: true
                                hoverEnabled: false
                                selectByMouse: true
                                echoMode: TextInput.Password
                            }
                        }
                    }
                    Item {
                        Label {
                            text: "缓存设置"
                        }
                    }
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                Button {
                    text: "确定"
                    onClicked: {
                        console.log("保存")
                    }
                }
                Button {
                    text: "取消"
                    onClicked: close()
                }
            }
        }
    }

    menuBar: MenuBar {
        Menu {
            title: "磁力链接搜索"
            MenuItem {
                text: "搜索设置"
                onTriggered: {
                    setting_window.visible = true
                }
            }
            MenuItem {
                id: list_pro_ctrl
                text: "只加载优质代理"
                onTriggered: {
                    switch(text) {
                        case "只加载优质代理":
                            website.model = website_list_pro
                            list_pro_ctrl.text = "加载全部代理"
                            break
                        case "加载全部代理":
                            website.model = website_list
                            list_pro_ctrl.text = "只加载优质代理"
                            break
                    }
                }
            }
            MenuItem {
                text: "退出"
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: "扩展功能"
            MenuItem {
                text: "网盘搜索"
                onTriggered: {
                    console.log("网盘搜索")
                }
            }
            MenuItem {
                text: "视频下载"
                onTriggered: {
                    console.log("视频下载")
                }
            }
        }
        Menu {
            title: "帮助"
            MenuItem {
                text: "使用手册"
                onTriggered: console.log("打开网页")
            }
            MenuItem {
                text: "关于"
                onTriggered: console.log("检查更新等")
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
            width: 180
            model: website_list
            textRole: "value"
            valueRole: "key"
        }
        TextField {
            id: search_terms
            text: "龙珠"
            width: 480
            anchors {
                top: website.top
                left: website.right
                leftMargin: 20
            }
            hoverEnabled: false
            selectByMouse: true
            placeholderText: "搜索词"
            font.pointSize: 12
        }
        ComboBox {
            id: page
            x: 40
            y: 20
            width: 100
            anchors {
                top: search_terms.top
                left: search_terms.right
                leftMargin: 20
            }
            model: ListModel {
                id: page_model
                ListElement {
                    key: 1
                    value: "第一页"
                }
            }
            textRole: "value"
            valueRole: "key"
        }
        Button {
            id: search
            width: 80
            anchors {
                top: search_terms.top
                left: page.right
                leftMargin: 20
            }
            text: "搜索"
            onClicked: {
                backend.search(website.currentValue, search_terms.text, page.currentValue)
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

        model: backend.search_result_model

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
                        qr_code.source = backend.magnet_qr_code(model.magnet)
                        qr_code_popup.open()
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
                        backend.copy_to_clipboard(model.magnet)
                        message_info.text = "复制成功"
                        message_timer.start()
                    }
                }
            }
        }
    }
}