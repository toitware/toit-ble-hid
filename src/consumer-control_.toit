// Copyright (C) 2025 Toit contributors.
// Use of this source code is governed by an MIT-style license that can be
// found in the package's LICENSE file.

import .ble-hid

import .appearances as appearances

/**
Support for a consumer control device.

A consumer control device is a remote control for multimedia devices. These devices typically
  include buttons for play, pause, volume control, and other media functions.

# Example

Use an ESP32 to mute the audio when the boot button is pressed.
```
import ble-hid
import gpio

main:
  pin := gpio.Pin --input 0
  remote := ble-hid.ConsumerControl --name="Muter"
  while true:
    pin.wait-for 0
    remote.mute
    pin.wait-for 1
```
*/

/**
A consumer control device.

These remotes come with media keys, volume keys, etc.
They can also be useful to control desktops or phones. For example, the volume-up
  button can be used to trigger a photo capture when the phone camera app is open.

Similarly, a screenshot can be triggered by sending the volume up + volume-down keys
  simultaneously.
*/
class ConsumerControl extends HidDevice:
  static REPORT-ID_ ::= 1

  static HID-REPORT-MAP_ ::= #[
    0x05, 0x0C,        // Usage Page (Consumer).
    0x09, 0x01,        // Usage (Consumer Control).
    0xA1, 0x01,        // Collection (Application).

    // The report ID must be the first byte, as BLE HID automatically prepends
    // the ID. The actual report must not contain it. See HOGP section 4.8.1.
    0x85, 0x01,        // Report ID.

    0x19, 0x00,        // Usage Minimum (0).
    0x2A, 0x3C, 0x02,  // Usage Maximum (572).
    0x15, 0x00,        // Logical Minimum (0).
    0x26, 0x3C, 0x02,  // Logical Maximum (572).
    0x95, 0x01,        // Report Count (1).
    0x75, 0x10,        // Report Size (16).
    0x81, 0x00,        // Input (Data, Array, Abs).
    0xC0               // End Collection.
  ]

  /**
  Creates a consumer control device.

  The $name is typically shown on the host when listing connected devices and must
    be relatively short (preferably <= 10 characters).

  The $appearance is one of the values in the 'appearances' library. See
    $appearances.PRESENTATION-REMOTE for an example.
  */
  // TODO(floitsch): the presentation remote doesn't seem to have an icon on
  // Linux and Android. Maybe we need to replace it with a different one.
  constructor --name/string --appearance/ByteArray=appearances.PRESENTATION-REMOTE:
    super.from-sub_
        --name=name
        --appearance=appearance
        --report-map=HID-REPORT-MAP_
        --report-id=REPORT-ID_

  /**
  Sends the given consumer control usage $code.
  See HID Usage Tables, section 15 (Consumer Page) for usage codes:
    https://usb.org/sites/default/files/hut1_21.pdf

  If $release is true, a key release event is sent after $release-delay
      (default 10ms).
  */
  report code/int --release/bool=false --release-delay/Duration?=null:
    report-characteristic_.write #[code & 0xFF, (code >> 8) & 0xFF]
    if release:
      if not release-delay:
        sleep --ms=10
      else:
        sleep release-delay
      this.release

  release -> none:
    report-characteristic_.write #[0x00, 0x00]

  /** Reports a 'play' button press. */
  play -> none: report 0xB0 --release

  /** Reports a 'pause' button press. */
  pause -> none: report 0xB1 --release

  /** Reports a 'play-pause' button press. */
  play-pause -> none: report 0xCD --release

  /** Reports a 'next track' button press. */
  next-track -> none: report 0xB5 --release

  /** Reports a 'previous track' button press. */
  previous-track -> none: report 0xB6 --release

  /** Reports a 'volume up' button press. */
  volume-up -> none: report 0xE9 --release

  /** Reports a 'volume down' button press. */
  volume-down -> none: report 0xEA --release

  /** Reports a 'mute' button press. */
  mute -> none: report 0xE2 --release
