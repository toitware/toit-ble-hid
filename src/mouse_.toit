// Copyright (C) 2025 Toit contributors.
// Use of this source code is governed by an MIT-style license that can be
// found in the package's LICENSE file.

import .ble-hid

import .appearances as appearances

/** A mouse device. */
class Mouse extends HidDevice:
  static REPORT-ID_ ::= 2

  static HID-REPORT-MAP_ ::= #[
    0x05, 0x01,        // Usage Page (Generic Desktop).
    0x09, 0x02,        // Usage (Mouse).
    0xA1, 0x01,        // Collection (Application).

    // The report ID must be the first byte, as BLE HID automatically prepends
    // the ID. The actual report must not contain it. See HOGP section 4.8.1.
    0x85, 0x02,        //   Report ID.

    0x09, 0x01,        //   Usage (Pointer).
    0xA1, 0x00,        //   Collection (Physical).

    // Buttons (3 bits in one byte).
    0x05, 0x09,        //     Usage Page (Buttons).
    0x19, 0x01,        //     Usage Minimum (Button 1).
    0x29, 0x03,        //     Usage Maximum (Button 3).
    0x15, 0x00,        //     Logical Minimum (0).
    0x25, 0x01,        //     Logical Maximum (1).
    0x95, 0x03,        //     Report Count (3).
    0x75, 0x01,        //     Report Size (1).
    0x81, 0x02,        //     Input (Data, Var, Abs).

    // Padding to make a full byte.
    0x95, 0x01,        //     Report Count (1).
    0x75, 0x05,        //     Report Size (5).
    0x81, 0x01,        //     Input (Const, Arr, Abs).

    // X and Y (signed 8-bit).
    0x05, 0x01,        //     Usage Page (Generic Desktop).
    0x09, 0x30,        //     Usage (X).
    0x09, 0x31,        //     Usage (Y).
    0x15, 0x81,        //     Logical Minimum (-127).
    0x25, 0x7F,        //     Logical Maximum (127).
    0x75, 0x08,        //     Report Size (8).
    0x95, 0x02,        //     Report Count (2).
    0x81, 0x06,        //     Input (Data, Var, Rel).

    0xC0,              //   End Collection.
    0xC0               // End Collection.
  ]

  constructor --name/string:
    super.from-sub_
        --name=name
        --appearance=appearances.MOUSE
        --report-map=HID-REPORT-MAP_
        --report-id=REPORT-ID_

  /**
  Moves the mouse pointer by the given $dx and $dy.

  The $dx and $dy values must be in the range -127 to 127.
  */
  move dx/int dy/int:
    report --dx=dx --dy=dy

  /**
  Clicks the mouse buttons.

  Waits for the given $delay before releasing the buttons.
  */
  click
      --left/bool=false
      --right/bool=false
      --middle/bool=false
      --delay/Duration=(Duration --ms=20):
    report --left-button=left --right-button=right --middle-button=middle --dx=0 --dy=0
    sleep delay
    report --dx=0 --dy=0

  /**
  Sends a report.

  The report includes the current state of the mouse buttons and the mouse position.

  The parameters $dx and $dy must be in the range -127 to 127.
  */
  report
      --left-button/bool=false
      --right-button/bool=false
      --middle-button/bool=false
      --dx/int
      --dy/int
  :
    if not (-127 <= dx <= 127) or not (-127 <= dy <= 127):
      throw "dx and dy must be in the range -127 to 127"
    button-byte := 0
    if left-button: button-byte |= 1
    if right-button: button-byte |= 2
    if middle-button: button-byte |= 4
    report-characteristic_.write #[button-byte, dx, dy]
