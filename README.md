# Kittens Automate

An Automation UI for Kittens Game written in Elm.

The script is still in early development, right now you can automatically:

* Gather Catnip(fixed at 10 clicks/sec atm)
* Build Catnip Fields, Huts, & Barns(when resources >= 90% of max)
* Refine Catnip into Wood
* Observe Astronomical Events
* Send Your Hunters when at Max Catpower
* Praise the Sun when at Max Faith

TODO:

* Population management
    * minimum amount of farmers to never starve
    * always max engineers
    * sliders to control distribution percentages
* Fix automation when button not displayed
* Configurable catnip click rate
* Configurable resource ratios for auto building/crafting
* More auto crafting/building options
* Automated trading
* Auto research
* Fullscreen button, turns panel into large modal window(when lots of UI options)
* Refactor Ports(click link, click building button, click craft button)
* Refactor code to generate checkboxes & handle updates using lists of
  buildings/recipes.


```
npm i
git submodule update --init
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
