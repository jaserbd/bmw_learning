The guess holds, and the Pi version is ready in my320d-pi.tar.gz.

Your car, confirmed. Code 0005/CYN belongs to the 320d Steptronic: 8-speed automatic, mild-hybrid diesel, engine B47D20B, 140 kW (190 hp). Insurer data for the same code lists rear-wheel drive and 400 Nm at 1,750 rpm. So everything in the app applies to you, including the 48 V parts. I updated the app’s header to say so. 
motorinsel
bavariadirekt

Install on the Pi

Copy it over: scp my320d-pi.tar.gz <user>@<pi-address>:~
On the Pi: tar xzf my320d-pi.tar.gz && sudo sh my320d/install.sh
Open http://<pi-address>:8320 on any device at home.

What you get:

Tiny footprint: one HTML file served by Python’s built-in web server, capped at 64 MB of memory, no Docker or database.
Starts at boot as a system service running without privileges.
Away from home: connect your WireGuard VPN and use the same address. Don’t forward port 8320 on the router.
On your iPhone: in Safari, use Share > Add to Home Screen to get an app icon.
Remove: sudo sh my320d/install.sh remove

I tested that the page serves correctly here, but the install script has not run on a real Pi, so tell me if step 2 prints an error. Your ticks and quiz score are saved per browser, so they won’t sync between phone and laptop. The fonts load from Google; without internet the app still works with standard fonts.
