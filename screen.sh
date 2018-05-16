# If you error for screen "Cannot open your terminal '/dev/pts/7' - please check."
# Put in your .bashrc following function:

function screen() {
  /usr/bin/script -q -c "/usr/bin/screen ${*}" /dev/null
}
