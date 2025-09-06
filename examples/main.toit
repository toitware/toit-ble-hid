import ble-hid
import gpio

main:
  hid := ble-hid.HidDevice --name="Toit BLE HID Example"
  print "Advertising as '$hid.name'"
  hid.start

  boot-button := gpio.Pin 0 --input
  while true:
    print "Waiting for button press"
    boot-button.wait-for 0
    hid.keyboard.type-qwerty "Hello world!"
    hid.set-battery-level 75
    boot-button.wait-for 1
