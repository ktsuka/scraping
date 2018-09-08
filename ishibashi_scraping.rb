# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('https://store.ishibashi.co.jp/ec/srDispCategoryTreeLink/doSearchCategory/11430000000/04-05/2/1'))
doc.xpath("//p[@class=\"item\"]").each do |item|
    puts item.text
end

doc.xpath("//p[@class=\"price\"]").each do |price|
    puts price.text
end
