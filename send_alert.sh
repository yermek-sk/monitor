#!/bin/bash

curl -s -X POST https://api.telegram.org/bot$TG_TOKEN/sendMessage \
	-d chat_id=$TG_CHAT_ID \
	-d text="$1" > /dev/null 2>&1

