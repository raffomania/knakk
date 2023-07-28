# Don't Add Your Release Keystore to Your Git Repository

If you've come across this when looking for a way to export your godot game for android - **do not publish your release keystore or export_credentials.cfg files**.

This repository uses [git-crypt](https://github.com/AGWA/git-crypt) to encrypt both the keystore and the `export_credentials.cfg` file. This way, the file contents remain private. 
As an alternative to git-crypt, you can add both of these files to your `.gitignore`.