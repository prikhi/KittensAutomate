# Kittens Automate

An Automation UI for Kittens Game written in Elm.

The script is still in it's alpha stages, right now only the current features
exist:

* Automatically Gather Catnip(fixed at 10 clicks/sec atm)
* Automatically Build Catnip Fields, Huts, & Barns(when resources >= 90% of max)
* Automatically Refine Catnip into Wood
* Automatically Observe Astronomical Events
* Automatically Send Your Hunters when at Max Catpower

TODO:

* Save Options & Load on Page Load
* Population management
    * minimum amount of farmers to never starve
    * always max engineers
    * sliders to control distribution percentages
* Fix automation when button not displayed
* Configurable catnip click rate
* Configurable resource ratios for auto building/crafting
* More auto crafting/building
* Automated trading
* Auto research
* Fullscreen button, turns panel into large modal window(when lots of UI options)


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
