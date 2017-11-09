// https://brookhong.github.io/2015/09/15/surfingkeys.html

// align then hint to the right
settings.hintAlign = "left";

// hint characters
Hints.characters = "asdfghjkl";

// intercept all error pages so Surfing keys can work on them
settings.interceptedErrors = ["*"];

// turn off smoothscroll
settings.smoothScroll = false;

// show the current mode in the status bar
settings.showModeStatus = true;

// open new tabs to the right of the current one
settings.newTabPosition = "right";

// disable smart page boundry jump next/previous
settings.smartPageBoundary = false;

// make Google translate languages clickable
settings.clickableSelector = "*.jfk-button, *.goog-flat-menu-button";

// show only tabs from the current window
settings.omnibarTabsQuery = {currentWindow: true};

// Follow link in current page: f

// Follow in new active tab: af
//mapkey ('F', 'Open link in new tab', 'Hints.create (Hints.pointers, Hints.dispatchMouseClick, {tabbed: true})');

// Follow in new background tab: gf
// map F
mapkey ('F', 'open a new tab in the background link', 'Hints.create (Hints.pointers, Hints.dispatchMouseClick, {tabbed: true, active: false})');

// Previous page in history: S
// mapkey ('H', 'backward', 'history.go (-1)');

// Change scroll target (iframe): cs

// Search with google (selected word or clipboard)
// Launch search: sg
// Launch search adding site:XXX: sog
// Edit search: sG
// Edit search adding site:XXX: soG
// g is the searchalias for google define in the chrome conf
addSearchAliasX('d', 'duckduckgo', 'https://duckduckgo.com/?q=', 'o');
addSearchAliasX('n', 'nar', 'http://newalbumreleases.net/?s=', 'o');
addSearchAliasX('q', 'qwant', 'https://www.qwant.com/?q=', 'o');
addSearchAliasX('r', 'drive', 'https://drive.google.com/drive/search?q=', 'o');
addSearchAliasX('gh', 'github', 'https://github.com/search?q=', 'o');
addSearchAliasX('wke', 'wikipedia_en', 'https://en.wikipedia.org/w/index.php?search=', 'o');
addSearchAliasX('wkf', 'wikipedia_fr', 'https://fr.wikipedia.org/w/index.php?search=', 'o');
settings.defaultSearchEngine = 'd';

// Edit URL to open in new tab
// su

// Edit settings: se

// Edit input with vim editor: I

// Markdown preview from clipboard
// sm (preview markdown)
// sm (show/edit markdown)
// :Wq (update preview)

// Show usage: ?: us
// Search with default search engine or open from clipboard
// map p in new tab
// map P in current tab

// Add bookmark with a

// Access tab/buffer with b

// Disable for sites X

// Vimium/vimperator-like settings
// https://brookhong.github.io/2015/09/15/surfingkeys.html
map('u', 'e');
mapkey('p', "Open the clipboard's URL in the current tab", function() {
    Front.getContentFromClipboard(function(response) {
        window.location.href = response.data;
    });
});
map('P', 'cc');
map('gi', 'i');
map('F', 'af');
map('gf', 'w');
map('`', '\'');
// save default key `t` to temp key `>_t`
map('>_t', 't');
// create a new key `t` for default key `on`
map('t', 'on');
// create a new key `o` for saved temp key `>_t`
map('o', '>_t');
map('H', 'S');
map('L', 'D');
map('gt', 'R');
map('gT', 'E');
map('K', 'R');
map('J', 'E');

// Disabling SurfkingKeys on https://app.asana.com
"blacklist": {
    "https://github.com": 1,
    "https://app.asana.com": 1
},

// vim:ft=javascript:foldmethod=marker:foldlevel=0:
