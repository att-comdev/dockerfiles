#!/bin/bash

eval "cat <<EOF
$(</slack-irc/config.json.txt)
EOF
" > /slack-irc/config.json