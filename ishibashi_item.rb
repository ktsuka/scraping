# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
$stdout.sync = true

# progressive bar function
def progress_bar(i, max)
  i = max if i > max
  rest_size = 1 + 5 + 1      # space + progress_num + %
  bar_width = 79 - rest_size # (width - 1) - rest_size = 72
  percent = i * 100.0 / max
  bar_length = i * bar_width.to_f / max
  bar_str = ('#' * bar_length).ljust(bar_width)
  progress_num = '%3.1f' % percent
  print "\r#{bar_str} #{'%5s' % progress_num}%"
end

# Array
item_array = Array.new
price_array = Array.new

# ISHIBASHI STORE DIGITAL URL
prev_url = "https://store.ishibashi.co.jp/ec/proList/doSearch/srDispProductList/1/1/%20/11430000000/1/%20/%20/%20/%20/%20/%20/1/40/"
post_url = "/0?jp=on&wd=%20&searchType=0&excludeSearchWord=&facetSearchType=0"
item_num = 0
total_num = 0

# get item all counts
url = prev_url + item_num.to_s + post_url
doc = Nokogiri::HTML(open(url))
doc.xpath("//span[@class=\"color\"]").each do |count|
    total_num =  count.text.to_i
    break
end

#puts total_num

# 
while item_num < total_num

    # set url
    url = prev_url + item_num.to_s + post_url
    #puts url

    # get item list
    doc = Nokogiri::HTML(open(url))
    doc.xpath("//p[@class=\"item\"]").each do |item|
        #puts item.text.gsub("\/ ","").gsub(" …","").gsub(" ","")
        item_array.push(item.text.gsub("\/ ","").gsub(" …",""))
    end

    # get price list
    doc.xpath("//p[@class=\"price\"]").each do |price|
        #puts price.text.strip.gsub("販売価格:","").gsub("円\(税込\)","")
        price_array.push(price.text.strip.gsub("販売価格:","").gsub("円\(税込\)","").gsub(",",""))
    end

    item_num += 40
    progress_bar(item_num,total_num)
    sleep(1)
    #break

end

(0...item_array.length).map{|i| [item_array[i], price_array[i]]}
item_list = item_array.zip(price_array)

#i = 0
#while i < item_list.length do
#    puts (i + 1).to_s + "," + item_list[i][0] + "," + item_list[i][1]
#    i += 1
#end

# put results into file
i = 0
datetime = Time.new
filename = "\/Users\/tsuka\/ruby\/scraping\/ishibashi_digital_" + datetime.strftime("%Y%m%d%H%M") + ".txt"
File.open(filename,"w") do |f|
    while i < item_list.length do
        f.puts datetime.strftime("%Y%m%d") + sprintf("%05d",i + 1).to_s + "," + "" + "," + item_list[i][0] + ","  + item_list[i][1] \
        + "," + "" + "," + ""
        i += 1
    end
end

puts "SCRAPING DONE!"
