# My 320d Under the Hood

A learning app for a 2021 BMW 320d (G20, B47 diesel, 48 V mild hybrid): a see-through
map of the car, drawn close-ups of each part, how the engine works, warning lights,
maintenance and a quiz. It is one self-contained HTML page with no dependencies
except two web fonts.

The drawings are simplified and positions are approximate. This is a learning aid,
not a replacement for the owner's manual.

## Layout

| Path | What |
|---|---|
| `my320d/app.html` | The whole app: styles, drawings and script in one file |
| `my320d/build.sh` | Wraps `app.html` into `build/my320d/index.html` and packs `my320d-pi.tar.gz` |
| `my320d/pi/install.sh` | Installs the page on a Raspberry Pi as a systemd service on port 8320 |
| `my320d/pi.env.example` | Pi address for `build.sh deploy` (copy to `pi.env`, git-ignored) |

## Run on a Raspberry Pi

```bash
cd my320d
cp pi.env.example pi.env     # set PI=user@address
./build.sh deploy            # needs SSH key login and sudo on the Pi
```

Then open `http://<pi-address>:8320` on any device at home. The service runs Python's
built-in web server without privileges, capped at 64 MB of memory, and starts at boot.
Remove it with `sudo sh my320d/install.sh remove` on the Pi.

To try it without a Pi, run `./build.sh` and open `build/my320d/index.html` in a browser.
