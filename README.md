# Kittens Automate

An Automation UI for Kittens Game written in Elm.

The script is still in it's alpha stages, right now only the current features
exist:

* Automatically Gather Catnip(fixed at 10 clicks/sec atm)
* Automatically build Catnip Fields(when catnip >= 90% of max)

TODO:

* Configurable catnip click rate
* Configurable resource ratio for auto building
* Automatically observe astronomical events
* Automatic Catnip refining
* More crafting
* More auto building


```
npm i
cd game/
# Add `<script src='http://localhost:7000/app.js'></script>` to index.html
python -m http.server 8080 &
xdg-open http://localhost:8000 &
cd ..
webpack watch
```

To load the script manually, run the following in devtools console:

```
var script = document.createElement('script');
script.setAttribute('src', 'http://localhost:7000/app.js');
document.head.appendChild(script);
```


Eventually, the script should be auto-built and pushed to github pages.
