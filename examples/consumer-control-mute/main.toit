// Copyright (C) 2025 Toit contributors.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import ble-hid
import gpio

main:
  remote := ble-hid.ConsumerControl --name="Muter"

  boot-button := gpio.Pin 0 --input
  while true:
    // The 'boot' button is connected to GPIO 0 which is a strap pin,
    // pulled high. When pressed, it goes low.
    boot-button.wait-for 0
    remote.mute
    boot-button.wait-for 1
