# APOD viewer

NASA's Astronomy Picture of the Day, sized to the screen, with the explanation beside it.

- `index.html` — the viewer. Open it in any browser. It reads the APOD posts from
  science.nasa.gov's WordPress feed (`/wp-json/wp/v2/image-article?categories=22766`),
  because api.nasa.gov's APOD endpoint stopped returning real pictures after the site move.
- `open-apod.sh` — opens the viewer in a new Safari window that fills the main screen.
- `install.sh` — adds a login item that runs `open-apod.sh` at each login.
  `install.sh --uninstall` removes it.

Keys: ← → change day, T today, E hide or show the text, F full screen.
Click the picture to open it at full size.
