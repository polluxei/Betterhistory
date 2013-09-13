class BH.Lib.ExampleTags
  constructor: (options) ->
    throw "Chrome API not set" unless options.chrome?
    throw "Persistence not set" unless options.persistence?

    @chromeAPI = options.chrome
    @persistence = options.persistence

  load: ->
    @persistence.fetchTags (tags) =>
      @chromeAPI.storage.local.set exampleTags

exampleTags =
  tags: ['games', 'places to travel', 'clothing', 'recipes', 'friends', 'funny videos', 'world news', 'productivity']
  friends: [
    {
      title: 'Facebook'
      url: 'http://www.facebook.com'
    }, {
      title: 'Twitter'
      url: 'https://twitter.com'
    }, {
      title: 'LinkedIn'
      url: 'http://www.linkedin.com'
    }, {
      title: 'Reddit'
      url: 'http://www.reddit.com'
    }, {
      title: 'Instagram'
      url: 'http://www.instagram.com'
    }, {
      title: 'Pinterest'
      url: 'http://www.pinterest.com'
    }
  ]
  'funny videos': [
    {
      title: '▶ Charlie bit my finger - again ! - YouTube'
      url: 'http://www.youtube.com/watch?v=_OBlgSz8sSM'
    }, {
      title: ''
      url: ''
    }
  ]
  'world news': [
    {
      title: 'Google News'
      url: 'https://news.google.com/news?vanilla=1'
    }, {
      title: 'BBC - Homepage'
      url: 'http://www.bbc.co.uk/'
    }, {
      title: 'Fact-Based, In-Depth News | Al Jazeera America'
      url: 'http://america.aljazeera.com/'
    }, {
      title: 'Yahoo! News - Latest News & Headlines'
      url: 'http://news.yahoo.com/'
    }, {
      title: 'World News'
      url: 'http://www.reddit.com/r/worldnews/'
    }, {
      title: 'World News, Foreign Policy and International Affairs - HuffPost World'
      url: 'http://www.huffingtonpost.com/world/'
    }, {
      title: 'World News | Reuters.com'
      url: 'http://www.reuters.com/news/world'
    }, {
      title: 'World News and International Headlines : NPR'
      url: 'http://www.npr.org/sections/world/'
    }
  ]
  games: [
    {
      title: 'Play Burrito Bison Revenge, a free online game on Kongregate'
      url: 'http://www.kongregate.com/games/JuicyBeast/burrito-bison-revenge'
    }, {
      title: 'Play Red Remover, a free online game on Kongregate'
      url: 'http://www.kongregate.com/games/TheGameHomepage/red-remover'
    }, {
      title: 'Monkey Quest - Free Online Strategy Games from AddictingGames'
      url: 'http://www.addictinggames.com/strategy-games/monkey-quest-game.jsp?xid=ag_mq_featured_bananas-beware'
    }, {
      title: 'Plants vs Zombies - Game of The Year Online at Games.com: Play Free Online Games'
      url: 'http://www.games.com/play/popcap-games/plants-vs-zombies-game-of-the-year'
    }, {
      title: 'Word Battle Online at Games.com: Play Free Online Games'
      url: 'http://www.games.com/play/sia-fufla/word-battle'
    }, {
      title: 'Bush Whacker 2 Online at Games.com: Play Free Online Games'
      url: 'http://www.games.com/play/djarts-games/bush-whacker-2'
    }, {
      title: 'Kingdom Rush Online at Games.com: Play Free Online Games'
      url: 'http://www.games.com/play/armorgames/kingdom-rush'
    }, {
      title: '8 Ball Pool Multiplayer - A free Sports Game'
      url: 'http://www.miniclip.com/games/8-ball-pool-multiplayer/en/#t-h-h'
    }, {
      title: 'Soccer Stars - A free Sports Game'
      url: 'http://www.miniclip.com/games/soccer-stars/en/#t-c-a'
    }, {
      title: 'Marble Lines | Play Online - Yahoo Games'
      url: 'http://games.yahoo.com/game/marble-lines-flash.html'
    }, {
      title: 'Rockitty | Play Online - Yahoo Games'
      url: 'http://games.yahoo.com/game/rockitty-flash.html'
    }
  ]
  recipes: [
    {
      title: 'Allrecipes - Recipes and cooking confidence for home cooks everywhere'
      url: 'http://allrecipes.com/'
    }, {
      title: 'Epicurious.com: Recipes, Menus, Cooking Articles & Food Guides'
      url: 'http://www.epicurious.com/'
    }, {
      title: 'foodgawker | feed your eyes'
      url: 'http://foodgawker.com/'
    }, {
      title: 'Recipes, Party Food, Cooking Guides, Dinner Ideas, and Grocery Coupons - Delish.com'
      url: 'http://www.delish.com/'
    }, {
      title: 'Quick Recipes & Easy Recipe Ideas - Tablespoon'
      url: 'http://www.tablespoon.com/'
    }, {
      title: 'The Best Site For Recipes, Recommendations, Food And Cooking | Yummly'
      url: 'http://www.yummly.com/'
    }
  ]
  clothing: [
    {
      title: 'Backpacks Made in USA, Gear Bags & Backpack Accessories | Topo Designs'
      url: 'http://topodesigns.com/'
    }, {
      title: "J.Crew : Cashmere Sweaters, Women's Clothing & Dresses, Men's & Kids' Clothing | JCrew.com"
      url: 'http://www.jcrew.com/index.jsp'
    }, {
      title: 'Topshop USA - Womens Clothing - Womens Fashion - Topshop'
      url: 'http://us.topshop.com/?geoip=home'
    }, {
      title: 'Clothes, Shoes, and Accessories for Women and Men | Free Shipping on $50 | Banana Republic'
      url: 'http://bananarepublic.gap.com/'
    }, {
      title: 'American Apparel | Fashionable Basics. Sweatshop Free. Made in USA.'
      url: 'http://www.americanapparel.net/'
    }, {
      title: 'Clothing – Shop For Clothes, Shipped FREE | Zappos.com'
      url: 'http://www.zappos.com/clothing'
    }, {
      title: 'Forever 21 - Shop fashionable clothing for women, plus, girls, men'
      url: 'http://www.forever21.com/Product/Main.aspx?br=f21'
    }, {
      title: 'OBEY CLOTHING'
      url: 'http://www.obeyclothing.com/'
    }, {
      title: "Victoria's Secret Online Clothing Store - Women's Clothing and Styles"
      url: 'http://www.victoriassecret.com/clothing'
    }, {
      title: 'Amazon.com Clothing: Denim, Dresses, T-Shirts & more + Free Returns'
      url: 'http://www.amazon.com/clothing-accessories-men-women-kids/b?ie=UTF8&node=1036592'
    }, {
      title: 'Urban Outfitters'
      url: 'http://www.urbanoutfitters.com/urban/index.jsp'
    }, {
      title: 'H&M | H&M US'
      url: 'http://www.hm.com/us/'
    }, {
      title: "Macy's - Shop Fashion Clothing & Accessories - Official Site - Macys.com"
      url: 'http://www.macys.com/'
    }, {
      title: 'Clothes For Women, Men, Kids and Baby | Free Shipping on $50 | Old Navy | Old Navy'
      url: 'http://www.oldnavy.com/'
    }
  ]
  'places to travel': [
    {
      title: 'Grand Canyon National Park - Grand Canyon National Park'
      url: 'http://www.nps.gov/grca/index.htm'
    }, {
      title: 'Great Wall of China - Wikipedia, the free encyclopedia'
      url: 'http://en.wikipedia.org/wiki/Great_Wall_of_China'
    }, {
      title: 'Nile River (river, Africa) -- Encyclopedia Britannica'
      url: 'http://www.britannica.com/EBchecked/topic/415347/Nile-River'
    }, {
      title: 'Travel Alaska - Official State of Alaska Travel &amp; Vacation Information'
      url: 'http://www.travelalaska.com/'
    }, {
      title: 'The London Pass® - London Sightseeing and Tourism for Less - London guide'
      url: 'http://www.londonpass.com/'
    }, {
      title: '10 Top Tourist Attractions in Germany | Touropia'
      url: 'http://www.touropia.com/tourist-attractions-in-germany/'
    }, {
      title: "France's Southern Vineyards : Wine : Travel Channel"
      url: 'http://www.travelchannel.com/interests/wine/articles/frances-southern-vineyards'
    }, {
      title: 'Things to do in Cuba – 275 Cuba Attractions - TripAdvisor'
      url: 'http://www.tripadvisor.ca/Attractions-g147270-Activities-Cuba.html'
    }, {
      title: 'Hawaii Vacations | Hawaii Vacation Packages and Deals'
      url: 'http://www.hawaii.com/'
    }
  ]
  productivity: [
    {
      title: 'Remember The Milk: Online to-do list and task management'
      url: 'http://www.rememberthemilk.com/'
    }, {
      title: 'Evernote | Remember everything with Evernote, Skitch and our other great apps.'
      url: 'http://evernote.com/'
    }, {
      title: 'Project management software, online collaboration: Basecamp'
      url: 'https://basecamp.com/'
    }, {
      title: 'HipChat'
      url: 'http://www.hipchat.com'
    }, {
      title: 'Skype - Free internet calls and cheap calls to phones online'
      url: 'http://www.skype.com/en/'
    }, {
      title: 'Dropbox'
      url: 'https://www.dropbox.com/'
    }
  ]

