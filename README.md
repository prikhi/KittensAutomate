# Kittens Automate

An Automation UI for Kittens Game written in Elm.


Still at the first steps, nothing usable yet.


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
