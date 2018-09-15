# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'

item_array = Array.new
price_array = Array.new

prev_url = "https://store.ishibashi.co.jp/ec/proList/doSearch/srDispProductList/1/1/%20/11430000000/1/%20/%20/%20/%20/%20/%20/1/40/"
post_url = "/0?jp=on&wd=%20&searchType=0&excludeSearchWord=&facetSearchType=0"
item_count = 0
total_count = 0

doc = Nokogiri::HTML(open(prev_url + item_count.to_s + post_url))

# get item all counts
doc.xpath("//span[@class=\"color\"]").each do |count|
    total_count =  count.text.to_i
    break
end

puts total_count

# 
while item_count < total_count
    puts prev_url + item_count.to_s + post_url
    item_count += 40
end

#doc.xpath("//p[@class=\"item\"]").each do |item|
    #puts item.text.gsub("\/ ","").gsub(" …","").gsub(" ","") 
#    item_array.push(item.text.gsub("\/ ","").gsub(" …","").gsub(" ",""))
#end

#doc.xpath("//p[@class=\"price\"]").each do |price|
    #puts price.text.strip.gsub("販売価格:","").gsub("円\(税込\)","")
#    price_array.push(price.text.strip.gsub("販売価格:","").gsub("円\(税込\)","").gsub(",",""))
#end

#(0...item_array.length).map{|i| [item_array[i], price_array[i]]}
#item_list = item_array.zip(price_array)
#puts item_list

#doc.xpath("//li[@class=\"nxt next bt_next\"]").each do |nextp|
#    link = nextp.to_s.gsub("<li class=\"nxt next bt_next\"><a onclick=\"return pageLinkClick\(\'","").gsub("\'\)\" href=\"#\">次へ<\/a><\/li>","")
#    puts link
#    break
#end
