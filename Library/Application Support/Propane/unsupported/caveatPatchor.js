var displayAvatars = true;
var expandGithubUrls = true;
var shortenGithubUrls = true;
var expandGithubShortcuts = true;
var expandDiffs = true;
var expandHtml = true;
var expandCloudAppImages = true;
var expandYandexPhotos = true;
var styleHubotMessages = true;
var HATERS = [];



if (displayAvatars) {
  Object.extend(Campfire.Message.prototype, {
    addAvatar: function() {
      if (this.actsLikeTextMessage()) {
        var author = this.authorElement();
        var avatar = '';

        if (author.visible()) {
          author.hide();
          if (this.bodyCell.select('strong').length === 0) {
            this.bodyCell.insert({top: '<strong style="color:#333;">'+author.textContent+'</strong><br>'});
            avatar = author.getAttribute('data-avatar') || 'http://asset1.37img.com/global/missing/avatar.png?r=3';
            author.insert({after: '<img alt="'+this.author()+'" align="top" src="'+avatar+'">'});
          }
        }
      }
    }
  });

  /* if you can wrap rather than rewrite, use swizzle like this: */
  swizzle(Campfire.Message, {
    setAuthorVisibilityInRelationTo: function($super, message) {
      $super(message);
      this.addAvatar();
    }
  });

  /* defining a new responder is probably the best way to insulate your hacks from Campfire and Propane */
  Campfire.AvatarMangler = Class.create({
    initialize: function(chat) {
      this.chat = chat;

      var messages = this.chat.transcript.messages;

      for (var i = 0; i < messages.length; i++) {
        var message = messages[i];
        message.addAvatar();
      }

      this.chat.layoutmanager.layout();
      this.chat.windowmanager.scrollToBottom();
    },

    onMessagesInserted: function(messages) {
      var scrolledToBottom = this.chat.windowmanager.isScrolledToBottom();

      for (var i = 0; i < messages.length; i++) {
        var message = messages[i];
        message.addAvatar();
      }

      if (scrolledToBottom) {
        this.chat.windowmanager.scrollToBottom();
      }
    }
  });

  /* Here is how to install your responder into the running chat */
  Campfire.Responders.push("AvatarMangler");
  window.chat.installPropaneResponder("AvatarMangler", "avatarmangler");
}



if (expandGithubUrls) {
  Campfire.GitHubExpander = Class.create({
    initialize: function(chat) {
      this.chat = chat;
      var messages = this.chat.transcript.messages;
      for (var i = 0; i < messages.length; i++) {
        this.detectGitHubURL(messages[i]);
      }
      this.chat.windowmanager.scrollToBottom();
    },

    detectGitHubURL: function(message) {
      if (!message.pending() && message.kind === 'text') {
        var iframe = null, elem, height = 150;

        var gists = message.bodyElement().select('a[href*="gist.github.com"]');
        if (gists.length == 1) {
          elem = gists[0];
          var href = elem.getAttribute('href');
          var match = href.match(/^https?:\/\/gist.github.com\/([A-Fa-f0-9]+)/);
          if (match) {
            iframe = 'https://gist.github.com/'+match[1]+'.pibb';
          }
        }

        var blobs = message.bodyElement().select('a[href*="#L"]');
        if (blobs.length == 1) {
          elem = blobs[0];
          var href = elem.getAttribute('href');
          iframe = href;
        }

        var blobs = message.bodyElement().select('a[href*="/blob/"]');
        if (!iframe && blobs.length == 1 && message.author() != 'Hubot') {
          elem = blobs[0];
          var href = elem.getAttribute('href');
          if (href.indexOf('#') > -1)
            iframe = href;
          else
            iframe = href + '#L1';
        }

        var commits = message.bodyElement().select('a[href*="/commit/"]')
        if (!iframe && commits.length == 1 && message.author() != 'Hubot' && message.author() != 'Git') {
          elem = commits[0];
          var href = elem.getAttribute('href');
          if (href.indexOf('#') > -1)
            iframe = href;
          else
            iframe = href + '#diff-stat';
        }

        if (!iframe || HATERS.include(this.chat.username) || iframe.match(/Image-Diff-View-Modes/)) return;
        message.bodyElement().insert({bottom:"<iframe style='border:0; margin-top: 5px' height='"+height+"' width='98%' src='"+iframe+"'></iframe>"});
      }
    },

    onMessagesInsertedBeforeDisplay: function(messages) {
      var scrolledToBottom = this.chat.windowmanager.isScrolledToBottom();
      for (var i = 0; i < messages.length; i++) {
        this.detectGitHubURL(messages[i]);
      }
      if (scrolledToBottom) {
        this.chat.windowmanager.scrollToBottom();
      }
    },

    onMessageAccepted: function(message, messageID) {
      this.detectGitHubURL(message);
    }
  });

  Campfire.Responders.push("GitHubExpander");
  window.chat.installPropaneResponder("GitHubExpander", "githubexpander");
}



if (shortenGithubUrls) {
  Campfire.GitHubURLShortener = Class.create({
    initialize: function(chat) {
      this.chat = chat;
      var messages = this.chat.transcript.messages;
      for (var i = 0; i < messages.length; i++) {
        this.detectGitHubURL(messages[i]);
      }
      this.chat.windowmanager.scrollToBottom();
    },

    detectGitHubURL: function(message) {
      if (!message.pending() && message.kind === 'text') {
        var authority = "//github.com/";
        var shortRef = function(str) { return /[^0-9a-f]/.test(str) ? str : str.substr(0, 7); }

        message.bodyElement().select('a[href*="' + authority + '"]').filter(function(link) {
          // We only want to modify links where the link's text is the URL.

          var text = link.innerText;
          if (text.substr(text.length - 3, 3) == '...') {
            text = text.substr(0, text.length - 3) + '…';
          }
          if (text[text.length - 1] === "…") {
            // The URL has been truncated, so use a more lenient test.
            text = text.substr(0, text.length - 1);
            return link.href.indexOf(text) === 0;
          }
          return text == link.href;
        }).forEach(function(link) {
          var pathQueryFragment = decodeURIComponent(link.href.substr(link.href.indexOf(authority) + authority.length));

          var index = pathQueryFragment.indexOf("?");
          if (index < 0)
            index = pathQueryFragment.indexOf("#");
          if (index >= 0) {
            var path = pathQueryFragment.slice(0, index);
            var queryFragment = pathQueryFragment.slice(index);
          } else {
            var path = pathQueryFragment;
            var queryFragment = "";
          }

          var components = path.split("/");

          // Don't shorten blog links; they look silly.
          if (components[0] === "blog")
            return;

          var userRepo = components.splice(0, 2).join("/");

          if (components.length === 0) {
            // This is just a link to a repository.
            link.innerText = userRepo + queryFragment;
            return;
          }

          var command = components.splice(0, 1);

          var transformations = {
            blob: {
              regex: /([^\/]+)\/(.*)/,
              text: function(match) {
                return userRepo + "@" + shortRef(match[1]) + ":" + match[2];
              },
            },
            commit: {
              regex: /[0-9a-fA-F]+/,
              text: function(match) {
                return userRepo + "@" + shortRef(match[0]);
              },
            },
            issues: {
              regex: /\d+/,
              text: function(match) {
                return userRepo + "#" + match[0];
              },
            },
            pull: {
              regex: /\d+/,
              text: function(match) {
                return userRepo + "#" + match[0];
              },
            },
            compare: {
              regex: /(.*?)\.\.\.(.*)/,
              text: function(match) {
                return userRepo + "@" + shortRef(match[1]) + "..." + shortRef(match[2]);
              },
            },
          };

          if (!(command in transformations))
            return;
          transformation = transformations[command];
          var match = components.join("/").match(transformation.regex);
          if (!match)
            return;
          link.innerText = transformation.text(match) + queryFragment;
        });
      }
    },

    onMessagesInsertedBeforeDisplay: function(messages) {
      var scrolledToBottom = this.chat.windowmanager.isScrolledToBottom();
      for (var i = 0; i < messages.length; i++) {
        this.detectGitHubURL(messages[i]);
      }
      if (scrolledToBottom) {
        this.chat.windowmanager.scrollToBottom();
      }
    },

    onMessageAccepted: function(message, messageID) {
      this.detectGitHubURL(message);
    }
  });

  Campfire.Responders.push("GitHubURLShortener");
  window.chat.installPropaneResponder("GitHubURLShortener", "githuburlshortener");
}



if (expandGithubShortcuts) {
  Campfire.GFMExpander = Class.create({
    initialize: function(chat) {
      this.chat = chat;
      var messages = this.chat.transcript.messages;
      for (var i = 0; i < messages.length; i++) {
        this.detectGFM(messages[i]);
      }
    },

    detectGFM: function(message) {
      if (message.kind === 'text') {
        var body = message.bodyElement()
        var text = body.innerText
        var regex = /(\s|^)([\w-]+\/[\w-]+)(@|#)([a-f0-9]+|\d+)\b/g

        if (text.match(regex)) {
          var html = body.innerHTML
          html = html.replace(regex, function(all, space, nwo, type, num){
            var link;
            if (type == '@') {
              link = "https://github.com/" + nwo + "/commit/" + num
            } else {
              link = "https://github.com/" + nwo + "/issues/" + num
            }

            return space + "<a target='_blank' href='"+link+"'>" + nwo + type + num + "</a>"
          })
          body.innerHTML = html
        }
      }
    },

    onMessagesInsertedBeforeDisplay: function(messages) {
      for (var i = 0; i < messages.length; i++) {
        this.detectGFM(messages[i]);
      }
    }
  });

  Campfire.Responders.push("GFMExpander");
  window.chat.installPropaneResponder("GFMExpander", "gfmexpander");
}



if (expandDiffs) {
  Campfire.DiffExpander = Class.create({
    initialize: function(chat) {
      this.chat = chat;
      var messages = this.chat.transcript.messages;
      for (var i = 0; i < messages.length; i++) {
        this.detectDiff(messages[i]);
      }
      this.chat.windowmanager.scrollToBottom();
    },

    detectDiff: function(message) {
      if (message.kind === 'paste') {
        var pre = message.bodyCell.select('pre')
        var code = message.bodyCell.select('pre code')
        if (code.length) {
          /* nowrap hax */
          pre[0].setStyle({'word-wrap':'normal','white-space':'pre'})
          code[0].setStyle({'overflow-x':'scroll'})

          var diff = code[0].innerText
          if (diff.match(/^\+\+\+/m)) {
            var lines = diff.split("\n").map(function(line){
              if (line.match(/^(diff|index)/)) {
                return "<b>"+line.escapeHTML()+"</b>"
              } else if (match = line.match(/^(@@.+?@@)(.*)$/)) {
                return "<b>"+match[1]+"</b> " + match[2].escapeHTML()
              } else if (line.match(/^\+/)) {
                return "<font style='color:green'>"+line.escapeHTML()+"</font>"
              } else if (line.match(/^\-/)) {
                return "<font style='color:red'>"+line.escapeHTML()+"</font>"
              } else {
                return line.escapeHTML()
              }
            })
            code[0].innerHTML = lines.join("\n")
          }
        }
      }
    },

    onMessagesInsertedBeforeDisplay: function(messages) {
      var scrolledToBottom = this.chat.windowmanager.isScrolledToBottom();
      for (var i = 0; i < messages.length; i++) {
        this.detectDiff(messages[i]);
      }
      if (scrolledToBottom) {
        this.chat.windowmanager.scrollToBottom();
      }
    },

    onMessageAccepted: function(message, messageID) {
      this.detectDiff(message);
    }
  });

  Campfire.Responders.push("DiffExpander");
  window.chat.installPropaneResponder("DiffExpander", "diffexpander");
}



if (expandHtml) {
  Campfire.HTMLExpander = Class.create({
    initialize: function(chat) {
      this.chat = chat;
      var messages = this.chat.transcript.messages;
      for (var i = 0; i < messages.length; i++) {
        this.detectHTML(messages[i], true);
      }
      this.chat.windowmanager.scrollToBottom();
    },

    detectHTML: function(message, noplay) {
      if (!message.pending() && ['text','paste'].include(message.kind)) {
        var body = message.bodyElement()
        var orig = body.innerHTML
        var match = body.innerText.match(/^HTML!\s+(.+)$/m);

        //if (noplay && !body.innerText.match(/<audio/)) return;

        // Some people can't handle this much fun
        if ((noplay || SOUND_HATERS.concat(HATERS).include(this.chat.username)) && /<audio/.test(body.innerText)) {
          match[1] = match[1].replace('autoplay','')
        }

        if (match && !body.innerText.match(/<\s*script/i)) {
          // find and fix truncated links
          var links = {}
          orig.replace(/<a href="(.+?)" target="_blank">(.+?…)<\/a>/, function(all, href, text){ links[text]=href; return all })

          var html = match[1].replace(/(h.*?…)/, function(all, link){ return links[link] || link })
          body.update(html)
        }
      }
    },

    onMessagesInsertedBeforeDisplay: function(messages) {
      var scrolledToBottom = this.chat.windowmanager.isScrolledToBottom();
      for (var i = 0; i < messages.length; i++) {
        this.detectHTML(messages[i]);
      }
      if (scrolledToBottom) {
        this.chat.windowmanager.scrollToBottom();
      }
    },

    onMessageAccepted: function(message, messageID) {
      this.detectHTML(message);
    }
  });

  Campfire.Responders.push("HTMLExpander");
  window.chat.installPropaneResponder("HTMLExpander", "htmlexpander");
}



/*
  Display CloudApp images inline.

  This responder illustrates using Propane's requestJSON service to request 
  JSON from remote (non-authenticated) servers and have the results passed
  to a callback of your choosing.
*/

if (expandCloudAppImages) {
  Campfire.CloudAppExpander = Class.create({
    initialize: function(chat) {
      this.chat = chat;
      var messages = this.chat.transcript.messages;
      for (var i = 0; i < messages.length; i++) {
        this.detectCloudAppURL(messages[i]);
      }
    },

    detectCloudAppURL: function(message) {
      /* we are going to use the messageID to uniquely identify our requestJSON request
         so we don't check pending messages */
      if (!message.pending() && message.kind === 'text') {
        var links = message.bodyElement().select('a:not(.image)');
        if (links.length != 1) {
          return;
        }
        var href = links[0].getAttribute('href');
        var match = href.match(/^https?:\/\/cl.ly\/image\/[A-Za-z0-9]+\/?$/);
        if (!match) return;
        window.propane.requestJSON(message.id(), href, 'window.chat.cloudappexpander', 'onEmbedDataLoaded', 'onEmbedDataFailed');
      }
    },

    onEmbedDataLoaded: function(messageID, data) {
      var message = window.chat.transcript.getMessageById(messageID);
      if (!message) return;

      if (data['item_type'] === 'image') {
        var imageURL = data['content_url'];
        message.resize((function() {
          message.bodyCell.insert({bottom: '<div style="width:100%; margin-top:5px; padding-top: 5px; border-top:1px dotted #ccc;"><a href="'+imageURL+'" class="image loading" target="_blank">' + '<img src="'+imageURL+'" onload="$dispatch(&quot;inlineImageLoaded&quot;, this)" onerror="$dispatch(&quot;inlineImageLoadFailed&quot;, this)" /></a></div>'});
        }).bind(this));
      }
    },

    onEmbedDataFailed: function(messageID) {
      /* No cleanup required, we only alter the HTML after we get back a succesful load from the data */
    },

    onMessagesInsertedBeforeDisplay: function(messages) {
      for (var i = 0; i < messages.length; i++) {
        this.detectCloudAppURL(messages[i]);
      }
    },

    onMessageAccepted: function(message, messageID) {
      this.detectCloudAppURL(message);
    }
  });

  Campfire.Responders.push("CloudAppExpander");
  window.chat.installPropaneResponder("CloudAppExpander", "cloudappexpander");
}



if (expandYandexPhotos) {
  Campfire.YandexPhotoExpander = Class.create({
    initialize: function(chat) {
      this.chat = chat;
      var messages = this.chat.transcript.messages;
      for (var i = 0; i < messages.length; i++) {
        this.detectURL(messages[i]);
      }
    },

    detectURL: function(message) {
      if (!message.pending() && message.kind === 'text') {
        var links = message.bodyElement().select('a:not(.image)');
        if (links.length != 1) {
          return;
        }
        var href = links[0].getAttribute('href');
        var match = href.match(/^https?:\/\/img-fotki.yandex.ru/);
        if (!match) return;
        message.resize(function() {
          message.bodyCell.insert({bottom: '<div style="width:100%; margin-top:5px; padding-top: 5px; border-top:1px dotted #ccc;"><a href="'+href+'" class="image loading" target="_blank">' + '<img src="'+href+'" onload="$dispatch(&quot;inlineImageLoaded&quot;, this)" onerror="$dispatch(&quot;inlineImageLoadFailed&quot;, this)" /></a></div>'});
        });
      }
    },

    onMessagesInsertedBeforeDisplay: function(messages) {
      for (var i = 0; i < messages.length; i++) {
        this.detectURL(messages[i]);
      }
    },

    onMessageAccepted: function(message, messageID) {
      this.detectURL(message);
    }
  });

  Campfire.Responders.push("YandexPhotoExpander");
  window.chat.installPropaneResponder("YandexPhotoExpander", "yandexphotoexpander");
}



if (styleHubotMessages) {
  Campfire.HubotMessageStyler = Class.create({
    initialize: function(chat) {
      this.chat = chat;
      var messages = this.chat.transcript.messages;
      for (var i = 0; i < messages.length; i++) {
        this.styleHubotMessage(messages[i]);
      }
      this.chat.windowmanager.scrollToBottom();
    },

    styleHubotMessage: function(message) {
      if (!message.pending() && message.kind === 'text' && message.author() == 'Hubot') {
        var body = message.bodyElement();
        body.addClassName("hubot");
        if (body.innerText.indexOf("Successfully built") !== -1) {
          body.addClassName("build success");
        } else if (body.innerText.indexOf("Failed to build") !== -1) {
          body.addClassName("build failure");
        }
      }
    },

    onMessagesInserted: function(messages) {
      var scrolledToBottom = this.chat.windowmanager.isScrolledToBottom();
      for (var i = 0; i < messages.length; i++) {
        this.styleHubotMessage(messages[i]);
      }
      if (scrolledToBottom) {
        this.chat.windowmanager.scrollToBottom();
      }
    }
  });

  Campfire.Responders.push("HubotMessageStyler");
  window.chat.installPropaneResponder("HubotMessageStyler", "hubotmessagestyler");
}
