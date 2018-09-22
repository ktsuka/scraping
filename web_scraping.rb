# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'

item_array = Array.new
price_array = Array.new

doc = Nokogiri::HTML(open('https://store.ishibashi.co.jp/ec/srDispCategoryTreeLink/doSearchCategory/11430000000/04-05/2/1'))

doc.xpath("//span[@class=\"color\"]").each do |count|
    puts count.text
    #puts count.text.to_i.div(40)
    break
end

doc.xpath("//p[@class=\"item\"]").each do |item|
    #puts item.text.gsub("\/ ","").gsub(" …","").gsub(" ","") 
    item_array.push(item.text.gsub("\/ ","").gsub(" …","").gsub(" ",""))
end

doc.xpath("//p[@class=\"price\"]").each do |price|
    #puts price.text.strip.gsub("販売価格:","").gsub("円\(税込\)","")
    price_array.push(price.text.strip.gsub("販売価格:","").gsub("円\(税込\)","").gsub(",",""))
end

# 配列要素を昇順に並び替える
(0...item_array.length).map{|i| [item_array[i], price_array[i]]}

# item_arrayとprice_arrayを結合する(二次元配列になる)
item_list = item_array.zip(price_array)

# 全レコード出力する
i = 0
while i < item_list.length do
    puts i.to_s + "," + item_list[i][0] + "," + item_list[i][1]
    i += 1
end

# 全レコード出力する
#puts item_list
