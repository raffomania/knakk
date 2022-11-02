export-web:
    mkdir -p export/web
    godot4 --export "Web" export/web/index.html --headless

export-linux:
    mkdir -p export/linux
    godot4 --export "Linux/X11" export/linux/clever-solitaire.x86_64 --headless

export: export-web export-linux

release-web: export-web
    butler push export/web raffomania/clever-solitaire:web

release-linux: export-linux
    butler push export/linux raffomania/clever-solitaire:linux

release: release-web release-linux