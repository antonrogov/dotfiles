var displayAvatars = true;
var expandGithubUrls = false;
var shortenGithubUrls = true;
var expandGithubShortcuts = true;
var expandDiffs = true;
var expandHtml = true;
var expandCloudAppImages = true;
var replaceDropboxImages = true;
var expandYandexPhotos = true;
var styleHubotMessages = true;
var infiteScrollHistory = false;
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


if (replaceDropboxImages) {
  Campfire.DropboxReplacer = Class.create({
    initialize: function(chat) {
      this.chat = chat;
      var messages = this.chat.transcript.messages;
      for (var i = 0; i < messages.length; i++) {
        this.replaceURL(messages[i]);
      }
    },

    replaceURL: function(message) {
      if (message.kind === 'text') {
        var links = message.bodyElement().select('a');
        if (links.length != 1) {
          return;
        }

        var href = links[0].getAttribute('href').replace('&#39', '');
        var match = href.match(/^https:\/\/www.dropbox.com\/s\//);
        if (!match) return;

        var imageURL = href.replace('www.dropbox.com', 'dl.dropboxusercontent.com');

        message.resize((function() {
          message.bodyElement().innerHTML = '<a href="'+imageURL+'" class="image loading" target="_blank"><img src="'+imageURL+'" onload="$dispatch(&quot;inlineImageLoaded&quot;, this)" onerror="$dispatch(&quot;inlineImageLoadFailed&quot;, this)" /></a>';
        }).bind(this));
      }
    },

    onMessagesInsertedBeforeDisplay: function(messages) {
      for (var i = 0; i < messages.length; i++) {
        this.replaceURL(messages[i]);
      }
    },

    onMessageAccepted: function(message, messageID) {
      this.replaceURL(message);
    }
  });

  Campfire.Responders.push("DropboxReplacer");
  window.chat.installPropaneResponder("DropboxReplacer", "dropboxreplacer");
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
        } else if (body.innerText.indexOf("Successfully deployed") !== -1) {
          body.addClassName("deploy success");
        } else if (body.innerText.indexOf("Failed to deploy") !== -1) {
          body.addClassName("deploy failure");
        } else {
          body.addClassName("notice");
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



if (infiteScrollHistory) {
  /*
   * Simple JSONP utility with Prototype.js
   */
  var JsonpRequest = Class.create({
      initialize: function(base_url, callback, options) {
      this.base_url = base_url;
      this.callback = callback;
      this.options = $H({
        callback_key: 'callback',
        param: { }
      });
      this.options.update(options);
      this.request();
    },

    request: function() {
      var handler_name = this.create_handler_name();
      var script_tag = new Element('script', {'type': 'text/javascript', 'src': this.url(handler_name)});

      var callback = this.callback;
      JsonpRequest[handler_name] = function(response) {
        script_tag.remove();
        delete JsonpRequest[handler_name];
        callback.call(this, response);
      };

      $$('head').first().insert(script_tag);
    },

    create_handler_name: function() {
      return 'handle_response_' + JsonpRequest.next_id++;
    },

    url: function(handler_name) {
      var param = $H(this.options.get('param'));
      param.set(this.options.get('callback_key'), 'JsonpRequest.' + handler_name);
      param.update({
        return_to: window.location.href + '?backfill=1',
        '_': new Date().getTime()
      });
      return this.base_url + '?' + param.toQueryString()
    }
  });
  JsonpRequest.next_id = 0;


  Campfire.Transcript.addMethods({
    /* maintainScrollPosition, html, *message_ids */
    prependMessages: function() {
      var ids = $A(arguments),
          maintainScrollPosition = ids.shift(),
          html = ids.shift();

      new Insertion.Top(this.element, html);
      this.findMessages()
      var messages = ids.map(this.getMessageById.bind(this));
      // this.chat.dispatch('messagesInsertedBeforeDisplay', messages);
      // messages.pluck('element').each(function(element) {
      //   Element.show(element);
      //   maintainScrollPosition();
      // });
      this.chat.dispatch('messagesInserted', messages);
      return messages;
    }
  });

  Campfire.Transcript.messageTemplates = {
    'TextMessage': new Template("<tr class=\"message text_message\" id=\"message_#{id}\"><td class=\"person\"><span class=\"author\" data-avatar=\"#{avatar_url}\" data-email=\"#{email_address}\" data-name=\"#{name}\">#{name}</span></td>\n  <td class=\"body\">\n    <div class=\"body\">#{body}</div>\n    \n  <span class=\"star \">\n    <a href=\"#\" onclick=\"chat.starmanager.toggle(this); return false;\" title=\"Starred lines appear as highlights in the transcript.\"></a>\n  </span>\n\n\n  </td>\n</tr>\n"),
    'PasteMessage': new Template("<tr class=\"message paste_message\" id=\"message_#{id}\"><td class=\"person\"><span class=\"author\" data-avatar=\"#{avatar_url}\" data-email=\"#{email_address}\" data-name=\"#{name}\">#{name}</span></td>\n  <td class=\"body\">\n <a href=\"/room/#{room_id}/paste/#{id}\" target=\"_blank\">View paste</a> \n<br>   <div class=\"body\"><pre><code>#{body}</code></pre></div>\n    \n  <span class=\"star \">\n    <a href=\"#\" onclick=\"chat.starmanager.toggle(this); return false;\" title=\"Starred lines appear as highlights in the transcript.\"></a>\n  </span>\n\n\n  </td>\n</tr>\n"),
    'TweetMessage': new Template("<tr class=\"message tweet_message\" id=\"message_#{id}\"><td class=\"person\"><span class=\"author\" data-avatar=\"#{avatar_url}\" data-email=\"#{email_address}\" data-name=\"#{name}\">#{name}</span></td>\n  <td class=\"body\">\n <div class=\"body\"><span class=\"clearfix tweet\"><span class=\"tweet_avatar\"><a href=\"http://twitter.com/#{tweet.author_username}/status/#{tweet.id}\" target=\"_blank\"><img alt=\"Profile_normal\" height=\"48\" src=\"#{tweet.author_avatar_url}\" width=\"48\"></a></span> \n #{tweet.message} \n <span class=\"tweet_author\">— <a href=\"http://twitter.com/#{tweet.author_username}/status/#{tweet.id}\" class=\"tweet_url\" target=\"_blank\">@#{tweet.author_username}</a> via Twitter</span> </span></div>\n    \n  <span class=\"star \">\n    <a href=\"#\" onclick=\"chat.starmanager.toggle(this); return false;\" title=\"Starred lines appear as highlights in the transcript.\"></a>\n  </span>\n\n\n  </td>\n</tr>\n"),
    'EnterMessage': new Template("<tr class=\"message enter_message\" id=\"message_#{id}\"><td class=\"person\"><span class=\"author\" data-avatar=\"#{avatar_url}\" data-email=\"#{email_address}\" data-name=\"#{name}\">#{name}</span></td>\n  <td class=\"body\">\n    <div>has entered the room</div>\n    \n\n\n  </td>\n</tr>\n"),
    'KickMessage': new Template("<tr class=\"message kick_message\" id=\"message_#{id}\"><td class=\"person\"><span class=\"author\" data-avatar=\"#{avatar_url}\" data-email=\"#{email_address}\" data-name=\"#{name}\">#{name}</span></td>\n  <td class=\"body\">\n    <div>has left the room</div>\n    \n\n\n  </td>\n</tr>\n"),
    'UploadMessage': new Template("<tr class=\"message upload_message\" id=\"message_#{id}\"><td class=\"person\"><span class=\"author\" data-avatar=\"#{avatar_url}\" data-email=\"#{email_address}\" data-name=\"#{name}\">#{name}</span></td>\n  <td class=\"body\">\n    <div class=\"body\"><img alt=\"Icon_png_small\" class=\"file_icon\" height=\"18\" src=\"/images/icons/icon_PNG_small.gif?1331159708\" width=\"24\">\n<a href=\"#{full_url}\" target=\"_blank\" title=\"#{body}\">#{body}</a>\n</div>\n    \n\n\n  </td>\n</tr>\n"),
    'UploadMessageImage': new Template("<tr class=\"message upload_message\" id=\"message_#{id}\"><td class=\"person\"><span class=\"author\" data-avatar=\"#{avatar_url}\" data-email=\"#{email_address}\" data-name=\"#{name}\">#{name}</span></td>\n  <td class=\"body\">\n    <div class=\"body\"><img alt=\"Icon_png_small\" class=\"file_icon\" height=\"18\" src=\"/images/icons/icon_PNG_small.gif?1331159708\" width=\"24\">\n<a href=\"#{full_url}\" target=\"_blank\" title=\"#{body}\">#{body}</a>\n<br>\n<a href=\"#{full_url}\" class=\"image\" target=\"_blank\"><img alt=\"#{body}\" onerror=\"$dispatch('inlineImageLoadFailed', this)\" onload=\"$dispatch('inlineImageLoaded', this)\" src=\"#{thumb_url}\"></a></div>\n    \n\n\n  </td>\n</tr>\n"),
    'TimestampMessage': new Template("<tr class=\"message timestamp_message\" id=\"message_#{id}\"><td class=\"date\"><span class=\"author\" style=\"display:none\"></span></td>\n  <td class=\"time\">\n    <div class=\"body\">#{time}</div>\n    \n\n\n  </td>\n</tr>\n")
  };

  var i = new Image();
  i.src = "https://github.com/images/spinners/octocat-spinner-16px.gif";

  function processMessage(message) {
    var pasteLines = 4;

    var type = message.type;
    var tmpl = Campfire.Transcript.messageTemplates[type];
    if (!tmpl) return;

    var user = chat.usersById[message.user_id];
    var opts = user ? $H(user) : $H({});

    if (message.body)
      opts = opts.merge({body: chat.transcript.bodyForPendingMessage(message.body)});

    if (opts.get('body') && type == 'PasteMessage') {
      var lines = opts.get('body').split("\n");
      if (lines.length > pasteLines)
        opts.set('body', lines.slice(0, pasteLines).join("\n") + "\n...");
    }

    var date = new Date(message.created_at);
    var hours = date.getHours();
    var mins = date.getMinutes() + '';
    if (mins.length == 1) mins = '0' + mins;
    var time = (hours > 12 ? hours-12 : hours == 0 ? 12 : hours) + ':' + mins + ' ' + (hours >= 12 ? 'PM' : 'AM');

    message.html = tmpl.evaluate(opts.merge({id: message.id,
                                             time: time,
                                             room_id: message.room_id,
                                             tweet: message.tweet}));
  }

  function fetchUsers(ids, callback) {
    if (!chat.usersById) window.chat.usersById = $H();

    var newIds = ids.filter(function (id) {
      return !chat.usersById[id];
    });
    var left = newIds.length;

    newIds.each(function (id) {
      var url = 'https://blackbits.campfirenow.com/users/' + id + '.json';

      new Ajax.Request(url, {
        method: 'get',
        onComplete: function(response) {
          chat.usersById[id] = response.responseJSON.user;
          left--;
          if (left <= 0) {
            callback();
          }
        }
      });
    });
  }

  function prependMessages(ids, html) {
    var history_request = 'history_request_' + (new Date().getTime());

    new Insertion.Top(chat.transcript.element, "<tr id='"+history_request+"'><td colspan=2><img src='https://github.com/images/spinners/octocat-spinner-16px.gif'></td></tr>")
    $(history_request).scrollTo()
    var scrollBottom = document.body.scrollHeight - document.body.scrollTop;
    var maintainScrollPosition = function() {
      document.body.scrollTop = document.body.scrollHeight - scrollBottom;
    }

    // Images without explicit sizes, and iframes whose src URLs contain
    // fragments, can cause the transcript to shift or scroll. We work
    // hard to keep the scroll position the same distance from the bottom
    // while backfilling.
    var interval = setInterval(maintainScrollPosition, 0);

    setTimeout(function(){
      chat.messageHistory += ids.length
      chat.transcript.prependMessages.apply(chat.transcript, [maintainScrollPosition, html].concat(ids))

      setTimeout(function(){
        $(history_request).remove()
        maintainScrollPosition()
        // Give iframes and images some more time to load before we let
        // the scroll position go.
        setTimeout(function(){
          clearInterval(interval);
        }, 1000)
      }, 250)
    }, 400)
  }

  function processMessages(data) {
    var ids = [];
    var html = '';
    var messages = data.messages;

    var userIds = messages.map(function (message) {
      return message.user_id;
    }).uniq().compact();

    fetchUsers(userIds, function () {
      messages.each(function (message) {
        processMessage(message);
        if (message.html) {
          ids.push(message.id);
          html += message.html;
        }
      });

      if (ids.length) {
        prependMessages(ids, html);
      }

      var link = $('todays_transcript_link');
      link.href = link.href.replace(/\/\d+$/, '/' + messages[0].id);
    });
  }

  function prependHistory(cb) {
    var room_id = $('return_to_room_id').value;
    var earliest_message = $('todays_transcript_link').href.match(/(\d+)$/)[1];
    var url = 'https://blackbits.campfirenow.com/room/' + room_id + '/recent.json';

    new Ajax.Request(url + '?since_message_id=' + earliest_message, {
      method: 'get',
      onSuccess: function(response) {
        processMessages(response.responseJSON);
        if (cb) cb();
      }
    });
  }

  $('todays_transcript_link').onclick = function(ev){
    ev.preventDefault();
    prependHistory();
  }

  if (location.search.match(/backfill/)) {
    prependHistory();
  }

  new Insertion.Bottom($('todays_transcript'), "<div style='float:right' id='infinite_scroll'></div>");

  var triggerHistory = false,
      triggeringHistory = false;

  Event.observe(window, 'scroll', function(ev) {
    var top = document.viewport.getScrollOffsets()[1];
    if (top < -40) {
      triggerHistory = true;
    }

    if (triggeringHistory)
      $('infinite_scroll').update('backfilling..');
    else if (triggerHistory)
      $('infinite_scroll').update('let go to backfill');
    else if (top < 0)
      $('infinite_scroll').update('keep pulling down to backfill');
    else if (top >= 0)
      $('infinite_scroll').update('');

    if (triggerHistory && top >= -5) {
      triggerHistory = false;
      triggeringHistory = true;
      prependHistory(function () {
        triggeringHistory = false;
        $('infinite_scroll').update('');
      });
    }
  });
}
