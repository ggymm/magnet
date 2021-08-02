import os
import shutil


def build_dev():
    # 执行打包
    os.system('pyinstaller --upx-dir build/ -y --specpath build --distpath build/debug/ --workpath build/cache/ main.py')

    # 拷贝规则文件
    shutil.copytree('rule/', 'build/debug/main/rule', dirs_exist_ok = True)

    # 拷贝配置文件
    shutil.copytree('config/', 'build/debug/main/config', dirs_exist_ok = True)


def build_prod():
    # 使用resource.qrc方式加载
    # pyside6-rcc resource.qrc -o resource.py
    # pip3 install pyinstaller
    # 执行打包
    os.system('pyinstaller --noconsole --upx-dir build/ -y --specpath build --distpath build/release/ --workpath build/cache/ main.py')

    # 拷贝规则文件
    shutil.copytree('rule/', 'build/release/main/rule', dirs_exist_ok = True)

    # 拷贝配置文件
    shutil.copytree('config/', 'build/release/main/config', dirs_exist_ok = True)


if __name__ == '__main__':
    # pip install nuitka
    # nuitka --mingw64 --standalone  --follow-imports --enable-plugin=pyside6 --include-qt-plugins=all --output-dir=build main.py

    pass
