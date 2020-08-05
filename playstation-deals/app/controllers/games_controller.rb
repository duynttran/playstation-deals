# Created 8/4/2020 by Duytan Tran
# Controller for web scraping and displaying game prices
class GamesController < ApplicationController
  # Created 8/4/2020 by Duytan Tran
  # Displays a list of prices for the designated Playstation 4 game from various vendors
  def index
    game = 'witcher 3'
    @gamestop = scrape_gamestop game
    @walmart = scrape_walmart game
    #@bestbuy = scrape_bestbuy game
    @playstation = scrape_playstation game
    @amazon = scrape_amazon game
  end

  private

  # Created 8/4/2020 by Duytan Tran
  # Scrapes gamestop for the price of the indicated game
  def scrape_gamestop game_name
    url = 'https://www.gamestop.com/'
    a = Mechanize.new { |agent| agent.user_agent_alias = 'Windows Firefox' }
    gamestop_home_page = a.get url
    search_bar = gamestop_home_page.forms.first
    search_bar.q = 'ps4 ' + game_name + ' game'
    unparsed_game_search = a.submit(search_bar, search_bar.buttons.first)
    parsed_game_search = Nokogiri::HTML(unparsed_game_search.body)
    text = 'not found'
    search_result = parsed_game_search.search('div.product')[0]
    text = search_result.text unless search_result.nil?
    [text, unparsed_game_search.uri.to_s]
  end

  # Created 8/4/2020 by Duytan Tran
  # Scrapes walmart for the price of the indicated game
  def scrape_walmart game_name
    url = 'https://www.walmart.com/'
    a = Mechanize.new { |agent| agent.user_agent_alias = 'Windows Firefox' }
    walmart_home_page = a.get url
    search_bar = walmart_home_page.forms.first
    search_bar.query = 'ps4 ' + game_name + ' game'
    unparsed_game_search = a.submit(search_bar, search_bar.buttons.first)
    parsed_game_search = Nokogiri::HTML(unparsed_game_search.body)
    text = 'not found'
    search_result = parsed_game_search.search('div.tile-aside.Grid-col.u-size-2-8.u-offset-1-8')[0]
    text = search_result.text unless search_result.nil?
    [text, unparsed_game_search.uri.to_s]
  end

  # Created 8/4/2020 by Duytan Tran
  # Scrapes bestbuy for the price of the indicated game (currently broken)
  def scrape_bestbuy game_name
    url = "https://www.bestbuy.com/site/searchpage.jsp?st=ps4+#{game_name.downcase.tr(' ', '+')}+game"
    a = Mechanize.new { |agent| agent.user_agent_alias = 'Windows Firefox' }
    unparsed_game_search = a.get url
    parsed_game_search = Nokogiri::HTML(unparsed_game_search.body)
    text = 'not found'
    search_result = parsed_game_search.search('div.priceView-hero-price.priceView-customer-price')[0]
    text = search_result.text unless search_result.nil?
    [text, unparsed_game_search.uri.to_s]
  end

  # Created 8/4/2020 by Duytan Tran
  # Scrapes the playstation store for the price of the indicated game
  def scrape_playstation game_name
    url = "https://store.playstation.com/en-us/grid/search-game/1?query=#{game_name}"
    a = Mechanize.new { |agent| agent.user_agent_alias = 'Windows Firefox' }
    unparsed_game_search = a.get url
    parsed_game_search = Nokogiri::HTML(unparsed_game_search.body)
    text = 'not found'
    search_result = parsed_game_search.search('div.grid-cell.grid-cell--game')[0]
    text = search_result.text unless search_result.nil?
    [text, unparsed_game_search.uri.to_s]
  end

  # Created 8/4/2020 by Duytan Tran
  # Scrapes amazon for the price of the indicated game
  def scrape_amazon game_name
    url = "https://www.amazon.com/s?k=ps4+#{game_name.downcase.tr(' ', '+')}+game"
    a = Mechanize.new { |agent| agent.user_agent_alias = 'Windows Firefox' }
    unparsed_game_search = a.get url
    parsed_game_search = Nokogiri::HTML(unparsed_game_search.body)
    text = 'not found'
    search_result = parsed_game_search.search('.a-section.a-spacing-none.a-spacing-top-mini span.a-color-base')[0]
    text = search_result.text unless search_result.nil?
    [text, unparsed_game_search.uri.to_s]
  end
end
