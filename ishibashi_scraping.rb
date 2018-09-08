# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('https://store.ishibashi.co.jp/ec/srDispCategoryTreeLink/doSearchCategory/11430000000/04-05/2/1'))
doc.xpath("//html/body/div/div/form[@name=\"srDispProductListForm\"]").each do |item|
    #puts item
    puts item.xpath("//p[@class=\"item\"]").text
    puts item.xpath("//p[@class=\"price\"]").text
end
