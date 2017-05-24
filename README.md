# Kittens Automate

An Automation UI for Kittens Game written in Elm.

The script is still in early development, right now you can automatically:

* Gather Catnip(fixed at 10 clicks/sec atm)
* Build Buildings When Resources >= 90% of Max(for buildings that don't require craftable resources)
* Craft Wood, Beams, Slabs When Resources >= 90% of Max, Using 15% of Available Resources
* Observe Astronomical Events
* Send Your Hunters when at Max Catpower
* Praise the Sun when at Max Faith

TODO:

* Fix building automation when button not displayed
* Fix parsing of JSON for buildings with multiple stages
* Incorporate workshop discounts into hut price calculation
    * See `gamePage.workshop -> effects -> hutPriceRatio`
* Population management
    * minimum amount of farmers to never starve
        * rebalance in cold winter or whenever catnip production is negative?
    * always max engineers
    * sliders to control distribution percentages
* Configurable catnip click rate
* Configurable resource current/max ratios for auto building & crafting
* Configurable crafting amounts or percentage of current resources to use
* More auto crafting/building options
* Automated trading
* Auto research
* Fullscreen button, turns panel into large modal window(when lots of UI options)
* Refactor Ports(click link, click building button, click craft button)
* Refactor Options/Messages
    * Maybe use Dict for options so we can represent options w/ strings instead of attributes
* Allow options migrations(so different set of options don't clear previous choices)
* FIgure out buying strategy for resources with no cap
    * Something like when cost is 10% of current?


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
