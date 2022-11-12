# Export the project

export-web:
    rm -rf export/web
    mkdir -p export/web
    godot4 --export "Web" export/web/index.html --headless

export-linux:
    rm -rf export/linux
    mkdir -p export/linux
    godot4 --export "Linux/X11" export/linux/clever-solitaire.x86_64 --headless

export-osx:
    rm -rf export/osx
    mkdir -p export/osx
    godot4 --export "OSX" export/osx/clever-solitaire.app --headless

export: export-web export-linux export-osx

# Upload exported files to various distribution platforms

release-web: export-web
    butler push export/web raffomania/clever-solitaire:web
    netlify deploy --dir export/web --prod

release-linux: export-linux
    butler push export/linux raffomania/clever-solitaire:linux

release-osx: export-osx
    butler push export/osx raffomania/clever-solitaire:osx

release: release-web release-linux release-osx

generate-card-images:
    fd png$ Card/source_images -x convert {} -resize 30% Card/images/{/}