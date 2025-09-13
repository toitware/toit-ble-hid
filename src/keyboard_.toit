// Copyright (C) 2025 Toit contributors.
// Use of this source code is governed by an MIT-style license that can be
// found in the package's LICENSE file.

import .ble-hid

import .appearances as appearances
import .keys as keys

/** A keyboard device. */
class Keyboard extends HidDevice:
  static REPORT-ID_ ::= 6

  static HID-REPORT-MAP_ ::= #[
    0x05, 0x01,        // Usage Page (Generic Desktop).
    0x09, 0x06,        // Usage (Keyboard).
    0xA1, 0x01,        // Collection (Application).

    // The report ID must be the first byte, as BLE HID automatically prepends
    // the ID. The actual report must not contain it. See HOGP section 4.8.1.
    0x85, 0x06,        //   Report ID.

    // Modifier byte.
    0x05, 0x07,        //   Usage Page (Key Codes).
    0x19, 0xE0,        //   Usage Minimum (Keyboard Left Control).
    0x29, 0xE7,        //   Usage Maximum (Keyboard Right GUI).
    0x15, 0x00,        //   Logical Minimum (0).
    0x25, 0x01,        //   Logical Maximum (1).
    0x75, 0x01,        //   Report Size (1).
    0x95, 0x08,        //   Report Count (8).
    0x81, 0x02,        //   Input (Data, Var, Abs).

    // Reserved byte.
    0x75, 0x08,        //   Report Size (8)
    0x95, 0x01,        //   Report Count (1)
    0x81, 0x01,        //   Input (Cnst, Arr, Abs)

    // 6 Keycodes.
    0x05, 0x07,        //   Usage Page (Key Codes).
    0x19, 0x00,        //   Usage Minimum (0).
    0x29, 0xA4,        //   Usage Maximum (101).
    0x15, 0x00,        //   Logical Minimum (0).
    0x25, 0xA4,        //   Logical Maximum (101).
    0x75, 0x08,        //   Report Size (8).
    0x95, 0x06,        //   Report Count (6).
    0x81, 0x00,        //   Input (Data, Arr, Abs).

    0xC0               // End Collection.
  ]

  constructor --name/string:
    super.from-sub_
        --name=name
        --appearance=appearances.KEYBOARD
        --report-map=HID-REPORT-MAP_
        --report-id=REPORT-ID_

  /**
  Types the given $text assuming the device emulates a QWERTY layout.

  Waits $delay after report.
  */
  type-qwerty text/string --delay/Duration=(Duration --ms=50):
    old-key := -1
    text.do: | c/int? |
      code := map-ascii-to-qwerty_ c
      needs-shift := (code >> 8) != 0
      key := code & 0xff

      if old-key == key:
        // We need to release the key to be able to press it again.
        release
        sleep delay

      report --left-shift=needs-shift #[key]
      sleep delay
      old-key = key
    release

  /**
  Presses the given key and releases it.

  If $delay is provided, waits for that duration before releasing the key.
  */
  press
      --left-control/bool=false
      --left-shift/bool=false
      --left-alt/bool=false
      --left-gui/bool=false
      --right-control/bool=false
      --right-shift/bool=false
      --right-alt/bool=false
      --right-gui/bool=false
      code/int
      --delay/Duration=(Duration --ms=50):
    report
        --left-control=left-control
        --left-shift=left-shift
        --left-alt=left-alt
        --left-gui=left-gui
        --right-control=right-control
        --right-shift=right-shift
        --right-alt=right-alt
        --right-gui=right-gui
        #[code, 0, 0, 0, 0, 0]
    sleep delay
    release

  /**
  Maps the given ASCII character $c to the corresponding usage ID.
  */
  map-ascii-to-qwerty_ c/int -> int:
    orig-c := c
    if 'A' <= c <= 'Z': c = 'a' + (c - 'A')
    else if c == '!': c = '1'
    else if c == '@': c = '2'
    else if c == '#': c = '3'
    else if c == '$': c = '4'
    else if c == '%': c = '5'
    else if c == '^': c = '6'
    else if c == '&': c = '7'
    else if c == '*': c = '8'
    else if c == '(': c = '9'
    else if c == ')': c = '0'
    else if c == '_': c = '-'
    else if c == '+': c = '='
    else if c == '{': c = '['
    else if c == '}': c = ']'
    else if c == '|': c = '\\'
    else if c == ':': c = ';'
    else if c == '"': c = '\''
    else if c == '~': c = '`'
    else if c == '<': c = ','
    else if c == '>': c = '.'
    else if c == '?': c = '/'

    modifier := 0
    if orig-c != c:
      // Shift needed. We use the left shift.
      modifier = 0xe1 << 8

    if 'a' <= c <= 'z': return modifier + (c - 'a' + keys.A)
    else if '1' <= c <= '9': return modifier + (c - '1' + keys.ONE)
    else if c == '0': return modifier + keys.ZERO
    else if c == '\n': return modifier + keys.ENTER
    else if c == 27: return modifier + keys.ESCAPE
    else if c == '\b': return modifier + keys.BACKSPACE
    else if c == '\t': return modifier + keys.TAB
    else if c == ' ': return modifier + keys.SPACE
    else if c == '-': return modifier + keys.MINUS
    else if c == '=': return modifier + keys.EQUAL
    else if c == '[': return modifier + keys.LEFT-BRACKET
    else if c == ']': return modifier + keys.RIGHT-BRACKET
    else if c == '\\': return modifier + keys.BACKSLASH
    else if c == ';': return modifier + keys.SEMICOLON
    else if c == '\'': return modifier + keys.APOSTROPHE
    else if c == '`': return modifier + keys.GRAVE
    else if c == ',': return modifier + keys.COMMA
    else if c == '.': return modifier + keys.PERIOD
    else if c == '/': return modifier + keys.SLASH
    throw "NOT_ASCII"

  /** Release all keys. */
  release -> none:
    report-characteristic_.write #[
      0x00,  // Modifiers.
      0x00,  // Reserved.
      // 6 key codes.
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    ]

  /**
  Report a change in the keyboard state.

  See the 'keys' library ($keys.A and similar) for codes.
  */
  report
      --left-control/bool=false
      --left-shift/bool=false
      --left-alt/bool=false
      --left-gui/bool=false
      --right-control/bool=false
      --right-shift/bool=false
      --right-alt/bool=false
      --right-gui/bool=false
      codes/ByteArray:
    if codes.size > 6:
      // Too many keys pressed simultaneously.
      throw "INVALID_ARGUMENT"
    // The modifiers are encoded as a bit-field, from E0 (left-control), to
    // E7 (right gui).
    modifiers := 0
    if left-control: modifiers |= 0b0000_0001
    if left-shift: modifiers |= 0b0000_0010
    if left-alt: modifiers |= 0b0000_0100
    if left-gui: modifiers |= 0b0000_1000
    if right-control: modifiers |= 0b0001_0000
    if right-shift: modifiers |= 0b0010_0000
    if right-alt: modifiers |= 0b0100_0000
    if right-gui: modifiers |= 0b1000_0000
    // Pad the codes with zeros to always send 6 codes.
    padded-codes := codes + (ByteArray (6 - codes.size))
    report-characteristic_.write #[
      modifiers,  // Modifier.
      0x00,      // Reserved.
      // 6 key codes.
    ] + padded-codes

