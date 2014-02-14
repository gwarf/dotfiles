// Pentadactyl Plugin: 'Delicious'
// Last Change: 23-Apr-2011
// License: MIT
// Usage: Use :delicious "description in quotes (optional)" <tags delimited by spaces> command
// Usage: if successfully posted you will see tagged response with privacy switch.
// Maintained by: Egon Hyszczak <gone404@gmail.com>
// Changes made: Added private bookmarks (pvt) and Twitter functionality (for:@twitter).
// Modified for use with Pentadactyl.
// Previous Maintainer: Travis Jeffery <travisjeffery@gmail.com>

group.commands.add(['delicious'], "Save page as a bookmark on Delicious",
    function(args) {
        var title = buffer.title;
        var url = "https://api.del.icio.us/v1/posts/add?";
        url += "&url=" + encodeURIComponent(buffer.URL);
        url += "&description=" + encodeURIComponent(title);
        var tags;
        var statusString = '';
        var extended;

        var re = new RegExp(/"([^"]+)"/);
        var ext = args.string.match(re);
        if(ext != null) {
            extended = encodeURIComponent(ext[1]);
            url += "&extended=" + extended;
            //Check to see if the title is at the beginning or end
            if(args.string.substr(0,1) == '"') {
              tags = args.string.substr(ext[0].length);
            } else if(args.string.substr(args.string.length - 1, 1) == '"') {
              tags = args.string.substr(0, args.string.length - ext[0].length);
            }
        } else {
            tags = args.string;
        }

        //If the 'pvt' tag is used lock the bookmark from public access
        if(tags.match("pvt")) {
            //Replace pvt with empty string
            tags = tags.replace("pvt", "");
            url += "&shared=no";
            statusString += '[PRIVATE] ';
        } else {
            url += "&shared=yes";
        }

        //Remove superfluous whitespace
        var whitespace = new RegExp(/\s{2,}/);
        tags = tags.replace(whitespace, " ");
        tags = tags.trim();

        url += "&tags=" + encodeURIComponent(tags);

        //Twitter
        if(tags.match("for:@twitter")) {
            //Use extended message if given
            if(ext) {
                url += "&share_msg=" + extended;
            } else {
                if(title.length >= 137) {
                    title = title.substr(0,137).trim();
                    title += "...";
                    url += "&share_msg=" + encodeURIComponent(title);
                } else {
                    url += "&share_msg=" + encodeURIComponent(title);
                }
            }
            url += "&recipients=" + encodeURIComponent("@twitter");
        }

        util.httpGet(url, {
          method: "POST",
          onload: function(req) {
            var status = req.responseXML.getElementsByTagName('result')[0].getAttribute('code');

            if(status == "done") {
              statusString += "Added bookmark for " + buffer.URL + " [" + tags + "]";
              dactyl.echomsg(statusString);
            } else {
              dactyl.echomsg(status);
            }
          },
          user: 'changeme', //Username
          pass: 'changeme' //Password
        });
    }
);
