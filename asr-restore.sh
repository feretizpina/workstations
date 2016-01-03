#!/bin/bash

USAGE="\
This script is designed to be invoked remotely.
It opens the script in a terminal window so that
the ASR can be monitored on that computer as it runs.
It must be invoked as the logged-in user."

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
TEMP_SCRIPT="$SCRIPT_DIR/.asr-restore-temp.sh"
PARTITION="/Volumes/AAStudent"
SERVER_ADDR=$1

if [[ -z "$1" ]]; then
 echo 'You must provide the server IP address as an argument.' >&2 && exit 1
fi

echo "
###### script ###### (this is here for debugging)
#!/bin/bash
cat $TEMP_SCRIPT

sudo asr restore --source asr://$SERVER_ADDR --target $PARTITION \
                 --erase --noprompt --noverify \
  && sudo bless -mount $PARTITION \
  && echo 'Restore completed. Rebooting to restored partition.' \
  && sudo shutdown -r now
##### /script ######

" > "$TEMP_SCRIPT"

chmod u+x "$TEMP_SCRIPT"
open -a Terminal "$TEMP_SCRIPT"
sleep 3 # give time for the script to load before removing
rm "$TEMP_SCRIPT"
