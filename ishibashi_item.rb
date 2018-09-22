# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'

item_array = Array.new
price_array = Array.new

prev_url = "https://store.ishibashi.co.jp/ec/proList/doSearch/srDispProductList/1/1/%20/11430000000/1/%20/%20/%20/%20/%20/%20/1/40/"
post_url = "/0?jp=on&wd=%20&searchType=0&excludeSearchWord=&facetSearchType=0"
item_num = 0
total_num = 0

url = prev_url + item_num.to_s + post_url
doc = Nokogiri::HTML(open(url))

# get item all counts
doc.xpath("//span[@class=\"color\"]").each do |count|
    total_num =  count.text.to_i
    break
end

puts total_num

# 
while item_num < total_num

    # set url
    url = prev_url + item_num.to_s + post_url
    puts url

    # get item list
    doc = Nokogiri::HTML(open(url))
    doc.xpath("//p[@class=\"item\"]").each do |item|
        #puts item.text.gsub("\/ ","").gsub(" …","").gsub(" ","")
        item_array.push(item.text.gsub("\/ ","").gsub(" …","").gsub(" ",""))
    end

    # get price list
    doc.xpath("//p[@class=\"price\"]").each do |price|
        #puts price.text.strip.gsub("販売価格:","").gsub("円\(税込\)","")
        price_array.push(price.text.strip.gsub("販売価格:","").gsub("円\(税込\)","").gsub(",",""))
    end

    item_num += 40
    sleep(1)

end

(0...item_array.length).map{|i| [item_array[i], price_array[i]]}
item_list = item_array.zip(price_array)

i = 0
while i < item_list.length do
    puts (i + 1).to_s + "," + item_list[i][0] + "," + item_list[i][1]
    i += 1
end
