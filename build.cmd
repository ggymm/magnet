pip install nuitka
nuitka --mingw64 --standalone  --follow-imports --enable-plugin=pyside6 --include-qt-plugins=all --output-dir=build main.py

pip3 install pyinstaller
pyinstaller --noconsole --upx-dir build/ -y --specpath build --distpath build/dist/ --workpath build/build/ main.py