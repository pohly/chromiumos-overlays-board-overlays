#!/bin/sh
# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

AUTH_DATA="$(curl -s -f -m 10 "http://metadata/computeMetadata/v1/instance/service-accounts/default/token" \
  -H "Metadata-Flavor: Google")"
R=$?
if [ ${R} -ne 0 ]; then
  echo "curl for auth token exited with status ${R}" >&2
  exit ${R}
fi

AUTH="$(echo "${AUTH_DATA}" \
| tr -d '{}' \
| sed 's/,/\n/g' \
| awk -F ':' '/access_token/ { print "_token:" $2 }' \
| tr -d '"\n' \
| base64 -w 0)"

if [ -z "${AUTH}" ]; then
  echo "Auth token not found in AUTH_DATA ${AUTH_DATA}" >&2
  exit 1
fi

cat > ~/.dockercfg <<EOF
{
 "https://container.cloud.google.com":{"email": "not@val.id","auth": "${AUTH}"},
 "https://gcr.io":{"email": "not@val.id","auth": "${AUTH}"},
 "https://b.gcr.io":{"email": "not@val.id","auth": "${AUTH}"},
 "https://us.gcr.io":{"email": "not@val.id","auth": "${AUTH}"},
 "https://eu.gcr.io":{"email": "not@val.id","auth": "${AUTH}"},
 "https://asia.gcr.io":{"email": "not@val.id","auth": "${AUTH}"},
 "https://beta.gcr.io":{"email": "not@val.id","auth": "${AUTH}"}
}
EOF
