# 10 — Troubleshooting

| Symptom | Likely cause | What to do |
|---|---|---|
| Mac sees no gamepad over USB | No driver binds to the XInput interface | Use Bluetooth |
| `2DC8:310A` is present but you cannot tell dongle from controller | The dongle uses the same ID while the controller is connected through it | Plug in one device at a time; power the controller off and look again |
| Not listed in Bluetooth | Back switch is not in the BT position / not in pairing mode | Check the switch, press the pairing button |
| A terminal program sees 0 in `GCController` | Possibly a command-line limitation | Use the browser Gamepad test |
| A HID program gets no data at all | Input Monitoring permission | Allow it in System Settings → Privacy & Security |
| Toolkit says "firmware this app doesn't recognise" | Version is not 1.09/1.03 | The backup may be valid, but do not write |
| Pairing disappeared | After an update/reset | Pair again |
