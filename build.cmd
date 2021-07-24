pip install nuitka
nuitka --mingw64 --standalone  --follow-imports --enable-plugin=pyside6 --include-qt-plugins=all --output-dir=build main.py

pip3 install pyinstaller
pyinstaller --distpath build -F main.py