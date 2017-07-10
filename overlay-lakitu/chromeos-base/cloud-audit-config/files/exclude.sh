# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# dont_exclude() adds a given msgtype into the list of allowed messages.
dont_exclude() {
  local msgtype=$1

  ALLOWED_MSGTYPE+=("${msgtype}")
}

# apply_exclude() adds a rule into "exclude" list that prohibits all
# msgtypes except those that has previously been marked as allowed
# with dont_exclude() function.
apply_exclude() {
  if [ ${#ALLOWED_MSGTYPE[@]} -eq 0 ]; then
    local filters=()
  else
    # Remove duplicates and format all filters.
    readarray -t filters < <(printf -- "-Fmsgtype!=%s\n" "${ALLOWED_MSGTYPE[@]}" | sort -u)
  fi

  auditctl -a never,exclude "${filters[@]}"
}
