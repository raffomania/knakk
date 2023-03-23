# Export the project

export-web:
    rm -rf export/web
    mkdir -p export/web
    godot --headless --export-release "Web" export/web/index.html 
export-linux:
    rm -rf export/linux
    mkdir -p export/linux
    godot --headless --export-release "Linux/X11" export/linux/knakk.x86_64 
export-osx:
    rm -rf export/osx
    mkdir -p export/osx
    godot --headless --export-release "OSX" export/osx/knakk.app

export-android:
    rm -rf export/android
    mkdir -p export/android
    godot --headless --export-release "Android" export/android/knakk.aab

export: export-web export-linux export-osx

# Upload exported files to various distribution platforms

release-web: export-web
    butler push export/web raffomania/knakk:web
    netlify deploy --dir export/web --prod

release-linux: export-linux
    butler push export/linux raffomania/knakk:linux

release-osx: export-osx
    butler push export/osx raffomania/knakk:osx

release-android: export-android
    butler push export/android/knakk.aab raffomania/knakk:android

release: release-web release-linux release-osx release-android

generate-card-images:
    fd png$ GameScreen/Card/source_images -x magick convert {} -resize 295x410 -background transparent -gravity center -extent 295x410 GameScreen/Card/images/{/}