import sys

from PySide6.QtCore import QAbstractListModel, Qt, QModelIndex, QObject, Slot, Property, Signal
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from crawler import run_crawler


class QDataListModel(QAbstractListModel):
    NAME = Qt.UserRole + 1000
    TIME = Qt.UserRole + 1001
    SIZE = Qt.UserRole + 1002
    HOT = Qt.UserRole + 1003
    MAGNET = Qt.UserRole + 1004

    def __init__(self, model):
        super().__init__()
        self.model = model

    def rowCount(self, parent=None) -> int:
        return len(self.model)

    def roleNames(self):
        return {
            self.NAME: b"name",
            self.TIME: b"time",
            self.SIZE: b"size",
            self.HOT: b"hot",
            self.MAGNET: b"magnet",
        }

    def data(self, index: QModelIndex, role: int = None):
        index = index.row()
        row = self.model[index]

        return row[str(self.roleNames()[role], 'utf-8')]


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)
        self._search_result_list = QDataListModel([])

    @Slot(str)
    def download(self, magnet):
        print("调用迅雷下载")
        print(magnet)

    @Slot(str, str)
    def search(self, key, search_terms):
        print(key)
        print(search_terms)
        print("执行搜索")

        infos = run_crawler(key, search_terms)
        print(infos)

        # 抓取数据
        data = []
        for i in range(1, 20):
            data.append({
                "name": "蜘蛛侠：英雄归来.2017.1080p.国英双语.中英字幕￡CMCT梦幻",
                "time": "2020-07-19 10:43",
                "size": "12.00GB",
                "hot": "99",
                "magnet": "111111",
            })
        self._search_result_list = QDataListModel(data)

        # 触发页面刷新
        # noinspection PyUnresolvedReferences
        self.search_result_changed.emit()

    search_result_changed = Signal()

    # 绑定QML数据
    @Property(QObject, constant=False, notify=search_result_changed)
    def search_result_list(self):
        return self._search_result_list


def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # 绑定视图
    backend = MainWindow()
    engine.rootContext().setContextProperty("backend", backend)
    engine.load("main.qml")

    if not engine.rootObjects():
        return -1

    return app.exec()


if __name__ == '__main__':
    sys.exit(main())
