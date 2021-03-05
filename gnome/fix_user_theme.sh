#!/usr/bin/env bash

# noted: don't run it if you never seen : No such schema “org.gnome.shell.extensions.user-theme”

# reference : https://gist.github.com/atiensivu/fcc3183e9a6fd74ec1a283e3b9ad05f0
# think you atiensivu
sudo cp $HOME/.local/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com/schemas/org.gnome.shell.extensions.user-theme.gschema.xml /usr/share/glib-2.0/schemas && sudo glib-compile-schemas /usr/share/glib-2.0/schemas
