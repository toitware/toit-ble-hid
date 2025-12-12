// Copyright (C) 2025 Toit contributors.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import ble-hid

main:
  remote := ble-hid.ConsumerControl --name="Capture"

  while true:
    sleep (Duration --s=10)
    remote.volume-up
