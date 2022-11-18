# Export the project

export-web:
    rm -rf export/web
    mkdir -p export/web
    godot4 --headless --export "Web" export/web/index.html 
export-linux:
    rm -rf export/linux
    mkdir -p export/linux
    godot4 --headless --export "Linux/X11" export/linux/clever-solitaire.x86_64 
export-osx:
    rm -rf export/osx
    mkdir -p export/osx
    godot4 --headless --export "OSX" export/osx/clever-solitaire.app

export-android:
    rm -rf export/android
    mkdir -p export/android
    godot4 --headless --export-debug "Android" export/android/clever-solitaire.apk

export: export-web export-linux export-osx

# Upload exported files to various distribution platforms

release-web: export-web
    butler push export/web raffomania/clever-solitaire:web
    netlify deploy --dir export/web --prod

release-linux: export-linux
    butler push export/linux raffomania/clever-solitaire:linux

release-osx: export-osx
    butler push export/osx raffomania/clever-solitaire:osx

release-android: export-android
    butler push export/android raffomania/clever-solitaire:android

release: release-web release-linux release-osx release-android

generate-card-images:
    fd png$ Card/source_images -x convert {} -resize 30% Card/images/{/}