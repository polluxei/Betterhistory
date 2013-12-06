class BH.Lib.ExampleTags
  load: (callback = ->) ->
    persistence.tag().import exampleTags, =>
      if user.isLoggedIn()
        persistence.tag().fetchTags (tags, compiledTags) =>
          translator = new BH.Lib.SyncingTranslator()
          translator.forServer compiledTags, (sites) =>
            persistence.remote().updateSites(sites)
            chrome.runtime.sendMessage({action: 'calculate hash'})
            callback()
      else
        callback()
date = new Date().getTime()
datetime = ->
  date += 1

exampleTags =
  tags: ['games', 'places to travel', 'clothing', 'recipes', 'friends', 'funny videos', 'world news', 'productivity']
  friends: [
    {
      title: 'Facebook'
      url: 'http://www.facebook.com'
      datetime: datetime()
    }, {
      title: 'Twitter'
      url: 'https://twitter.com'
      datetime: datetime()
    }, {
      title: 'LinkedIn'
      url: 'http://www.linkedin.com'
      datetime: datetime()
    }, {
      title: 'Reddit'
      url: 'http://www.reddit.com'
      datetime: datetime()
    }, {
      title: 'Instagram'
      url: 'http://www.instagram.com'
      datetime: datetime()
    }, {
      title: 'Pinterest'
      url: 'http://www.pinterest.com'
      datetime: datetime()
    }
  ]
  'funny videos': [
    {
      title: '▶ Charlie bit my finger - again ! - YouTube'
      url: 'http://www.youtube.com/watch?v=_OBlgSz8sSM'
      datetime: datetime()
    }
  ]
  'world news': [
    {
      title: 'Google News'
      url: 'https://news.google.com/news?vanilla=1'
      datetime: datetime()
    }, {
      title: 'BBC - Homepage'
      url: 'http://www.bbc.co.uk/'
      datetime: datetime()
    }, {
      title: 'Fact-Based, In-Depth News | Al Jazeera America'
      url: 'http://america.aljazeera.com/'
      datetime: datetime()
    }, {
      title: 'Yahoo! News - Latest News & Headlines'
      url: 'http://news.yahoo.com/'
      datetime: datetime()
    }, {
      title: 'World News'
      url: 'http://www.reddit.com/r/worldnews/'
      datetime: datetime()
    }, {
      title: 'World News, Foreign Policy and International Affairs - HuffPost World'
      url: 'http://www.huffingtonpost.com/world/'
      datetime: datetime()
    }, {
      title: 'World News | Reuters.com'
      url: 'http://www.reuters.com/news/world'
      datetime: datetime()
    }, {
      title: 'World News and International Headlines : NPR'
      url: 'http://www.npr.org/sections/world/'
      datetime: datetime()
    }
  ]
  games: [
    {
      title: 'Play Burrito Bison Revenge, a free online game on Kongregate'
      url: 'http://www.kongregate.com/games/JuicyBeast/burrito-bison-revenge'
      datetime: datetime()
    }, {
      title: 'Play Red Remover, a free online game on Kongregate'
      url: 'http://www.kongregate.com/games/TheGameHomepage/red-remover'
      datetime: datetime()
    }, {
      title: 'Monkey Quest - Free Online Strategy Games from AddictingGames'
      url: 'http://www.addictinggames.com/strategy-games/monkey-quest-game.jsp?xid=ag_mq_featured_bananas-beware'
      datetime: datetime()
    }, {
      title: 'Plants vs Zombies - Game of The Year Online at Games.com: Play Free Online Games'
      url: 'http://www.games.com/play/popcap-games/plants-vs-zombies-game-of-the-year'
      datetime: datetime()
    }, {
      title: 'Word Battle Online at Games.com: Play Free Online Games'
      url: 'http://www.games.com/play/sia-fufla/word-battle'
      datetime: datetime()
    }, {
      title: 'Bush Whacker 2 Online at Games.com: Play Free Online Games'
      url: 'http://www.games.com/play/djarts-games/bush-whacker-2'
      datetime: datetime()
    }, {
      title: 'Kingdom Rush Online at Games.com: Play Free Online Games'
      url: 'http://www.games.com/play/armorgames/kingdom-rush'
      datetime: datetime()
    }, {
      title: '8 Ball Pool Multiplayer - A free Sports Game'
      url: 'http://www.miniclip.com/games/8-ball-pool-multiplayer/en/#t-h-h'
      datetime: datetime()
    }, {
      title: 'Soccer Stars - A free Sports Game'
      url: 'http://www.miniclip.com/games/soccer-stars/en/#t-c-a'
      datetime: datetime()
    }, {
      title: 'Marble Lines | Play Online - Yahoo Games'
      url: 'http://games.yahoo.com/game/marble-lines-flash.html'
      datetime: datetime()
    }, {
      title: 'Rockitty | Play Online - Yahoo Games'
      url: 'http://games.yahoo.com/game/rockitty-flash.html'
      datetime: datetime()
    }
  ]
  recipes: [
    {
      title: 'Allrecipes - Recipes and cooking confidence for home cooks everywhere'
      url: 'http://allrecipes.com/'
      datetime: datetime()
    }, {
      title: 'Epicurious.com: Recipes, Menus, Cooking Articles & Food Guides'
      url: 'http://www.epicurious.com/'
      datetime: datetime()
    }, {
      title: 'foodgawker | feed your eyes'
      url: 'http://foodgawker.com/'
      datetime: datetime()
    }, {
      title: 'Recipes, Party Food, Cooking Guides, Dinner Ideas, and Grocery Coupons - Delish.com'
      url: 'http://www.delish.com/'
      datetime: datetime()
    }, {
      title: 'Quick Recipes & Easy Recipe Ideas - Tablespoon'
      url: 'http://www.tablespoon.com/'
      datetime: datetime()
    }, {
      title: 'The Best Site For Recipes, Recommendations, Food And Cooking | Yummly'
      url: 'http://www.yummly.com/'
      datetime: datetime()
    }
  ]
  clothing: [
    {
      title: 'Backpacks Made in USA, Gear Bags & Backpack Accessories | Topo Designs'
      url: 'http://topodesigns.com/'
      datetime: datetime()
    }, {
      title: "J.Crew : Cashmere Sweaters, Women's Clothing & Dresses, Men's & Kids' Clothing | JCrew.com"
      url: 'http://www.jcrew.com/index.jsp'
      datetime: datetime()
    }, {
      title: 'Topshop USA - Womens Clothing - Womens Fashion - Topshop'
      url: 'http://us.topshop.com/?geoip=home'
      datetime: datetime()
    }, {
      title: 'Clothes, Shoes, and Accessories for Women and Men | Free Shipping on $50 | Banana Republic'
      url: 'http://bananarepublic.gap.com/'
      datetime: datetime()
    }, {
      title: 'American Apparel | Fashionable Basics. Sweatshop Free. Made in USA.'
      url: 'http://www.americanapparel.net/'
      datetime: datetime()
    }, {
      title: 'Clothing – Shop For Clothes, Shipped FREE | Zappos.com'
      url: 'http://www.zappos.com/clothing'
      datetime: datetime()
    }, {
      title: 'Forever 21 - Shop fashionable clothing for women, plus, girls, men'
      url: 'http://www.forever21.com/Product/Main.aspx?br=f21'
      datetime: datetime()
    }, {
      title: 'OBEY CLOTHING'
      url: 'http://www.obeyclothing.com/'
      datetime: datetime()
    }, {
      title: "Victoria's Secret Online Clothing Store - Women's Clothing and Styles"
      url: 'http://www.victoriassecret.com/clothing'
      datetime: datetime()
    }, {
      title: 'Amazon.com Clothing: Denim, Dresses, T-Shirts & more + Free Returns'
      url: 'http://www.amazon.com/clothing-accessories-men-women-kids/b?ie=UTF8&node=1036592'
      datetime: datetime()
    }, {
      title: 'Urban Outfitters'
      url: 'http://www.urbanoutfitters.com/urban/index.jsp'
      datetime: datetime()
    }, {
      title: 'H&M | H&M US'
      url: 'http://www.hm.com/us/'
      datetime: datetime()
    }, {
      title: "Macy's - Shop Fashion Clothing & Accessories - Official Site - Macys.com"
      url: 'http://www.macys.com/'
      datetime: datetime()
    }, {
      title: 'Clothes For Women, Men, Kids and Baby | Free Shipping on $50 | Old Navy | Old Navy'
      url: 'http://www.oldnavy.com/'
      datetime: datetime()
    }
  ]
  'places to travel': [
    {
      title: 'Grand Canyon National Park - Grand Canyon National Park'
      url: 'http://www.nps.gov/grca/index.htm'
      datetime: datetime()
    }, {
      title: 'Great Wall of China - Wikipedia, the free encyclopedia'
      url: 'http://en.wikipedia.org/wiki/Great_Wall_of_China'
      datetime: datetime()
    }, {
      title: 'Nile River (river, Africa) -- Encyclopedia Britannica'
      url: 'http://www.britannica.com/EBchecked/topic/415347/Nile-River'
      datetime: datetime()
    }, {
      title: 'Travel Alaska - Official State of Alaska Travel &amp; Vacation Information'
      url: 'http://www.travelalaska.com/'
      datetime: datetime()
    }, {
      title: 'The London Pass® - London Sightseeing and Tourism for Less - London guide'
      url: 'http://www.londonpass.com/'
      datetime: datetime()
    }, {
      title: '10 Top Tourist Attractions in Germany | Touropia'
      url: 'http://www.touropia.com/tourist-attractions-in-germany/'
      datetime: datetime()
    }, {
      title: "France's Southern Vineyards : Wine : Travel Channel"
      url: 'http://www.travelchannel.com/interests/wine/articles/frances-southern-vineyards'
      datetime: datetime()
    }, {
      title: 'Things to do in Cuba – 275 Cuba Attractions - TripAdvisor'
      url: 'http://www.tripadvisor.ca/Attractions-g147270-Activities-Cuba.html'
      datetime: datetime()
    }, {
      title: 'Hawaii Vacations | Hawaii Vacation Packages and Deals'
      url: 'http://www.hawaii.com/'
      datetime: datetime()
    }
  ]
  productivity: [
    {
      title: 'Remember The Milk: Online to-do list and task management'
      url: 'http://www.rememberthemilk.com/'
      datetime: datetime()
    }, {
      title: 'Evernote | Remember everything with Evernote, Skitch and our other great apps.'
      url: 'http://evernote.com/'
      datetime: datetime()
    }, {
      title: 'Project management software, online collaboration: Basecamp'
      url: 'https://basecamp.com/'
      datetime: datetime()
    }, {
      title: 'HipChat'
      url: 'http://www.hipchat.com'
      datetime: datetime()
    }, {
      title: 'Skype - Free internet calls and cheap calls to phones online'
      url: 'http://www.skype.com/en/'
      datetime: datetime()
    }, {
      title: 'Dropbox'
      url: 'https://www.dropbox.com/'
      datetime: datetime()
    }
  ]

