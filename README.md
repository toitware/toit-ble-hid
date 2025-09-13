# BLE HID

A BLE HID (Human Interface Device) driver.

This package allows you to create BLE HID devices such as keyboards, mice, and
tablets. It provides a simple interface to send HID reports over Bluetooth
Low Energy (BLE).

## Example

```
import ble-hid
import ble-hid.keys
import gpio

main:
  keyboard := ble-hid.Keyboard --name="Toit Keyboard"
  keyboard.set-battery-level 75

  boot-button := gpio.Pin 0 --input

  print "Waiting for button press"
  boot-button.wait-for 0

  // Send key presses, assuming a QWERTY layout.
  keyboard.type-qwerty "Hello big world!"

  keyboard.close
```
