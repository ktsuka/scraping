# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
$stdout.sync = true

# progressive bar function
def ProgressBar(i, max)
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
code_array = Array.new
img_array = Array.new
chk_array = ["\/ec\/img\/\\d+\/\\d+-\\d+_s.jpg","\/ec\/img\/\\d+\/\\d+-\\w+\\d+_s.jpg","\/ec\/img\/\\d+\/\\d+-\\d+\\w+_s.jpg"]

# ISHIBASHI STORE DIGITAL URL
prev_url = "https://store.ishibashi.co.jp/ec/proList/doSearch/srDispProductList/1/1/%20/11430000000/1/%20/%20/%20/%20/%20/%20/1/40/"
post_url = "/0?jp=on&wd=%20&searchType=0&excludeSearchWord=&facetSearchType=0"
item_num = 0
total_num = 0
img_prev_url = "https://store.ishibashi.co.jp/"
img_url = ""

# Get Image Function
def GetImg(url)

  filename = File.basename(url)
  open(filename.to_s,'wb') do |file|
    open(url) do |data|
      file.write(data.read)
    end
  end

end

# get item all counts
url = prev_url + item_num.to_s + post_url
doc = Nokogiri::HTML(open(url))
doc.xpath("//span[@class=\"color\"]").each do |count|
    total_num =  count.text.to_i
    break
end

#puts total_num

# do scraping 
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

    # get code list
    doc.xpath("//p[@class=\"code\"]").each do |code|
      #puts code.text.strip
      code_array.push(code.text.strip.gsub("商品コード：",""))
    end

    # get image url
    doc.css('img').each do |image|

      chk_array.map do |path|     
        if /#{path}/ =~ image[:src]
          img_array.push(image[:src])
          break
        end
      end

    end

    item_num += 40
    ProgressBar(item_num,total_num)
    sleep(1)
    #break if item_num == 120
    #break

end

# zip array
(0...item_array.length).map{|i| [item_array[i], price_array[i], code_array[i]]}
item_list = item_array.zip(price_array, code_array)

# put results into file
makers = ["YAMAHA","ROLAND","KORG","DAVE SMITH INSTRUMENTS","DAVE SMITH","BEHRINGER","WALDORF","CLAVIA","ARTURIA",
         "STUDIOLOGIC","ELEKTRON","ZOOM","MAKE NOISE","TEENAGE ENGINEERING","MUTABLE INSTRUMENTS","TIPTOP AUDIO", \
         "GAMECHANGER AUDIO","IK MULTIMEDIA","DOEPFER","MOOG","VOX","ROSSUM ELECTRO-MUSIC","JOMOX","MELLOTRON","AKAI", \
         "DATO","KIKUTANI","KIKUTANI MUSIC","KYORITSU","NOVATION","HAMMOND","DIGITECH","CASIO","BOSS","STRYMON","KOMA","ORB", \
         "CRITTER\&GUITARI","DECKSAVER","ULTIMATE","UDG","KAWAI","SEQUENZ","NORD\(CLAVIA\)","SHERMAN","AUDIO-TECHNICA", \
         "CRAVIA","YAMANO","ACCESS","PIONEER","REON","QUIK-LOK","Radel","ESI","KRK","SELVA","TASCAM","HERCULES","PROVIDENCE", \
         "HERCULES","FOCAL","MACKIE","ADAM AUDIO","RADIKAL TECHNOLOGIES","ELECTRO HARMONIX","RADEL","PLOYTEC","CERWIN VEGA", \
         "CNB","ACIDLAB","KENTON","E-MU","SISMO","OBERHEIM","ACE TONE","RHODES","STUDIO ELECTRONICS","SKYCHORD ELECTRONICS", \
         "HOHNER","BASTL INSTRUMENTS","SEQUENTIAL CIRCUITS","SEQUENTIAL","QUASI MIDI","BIAS","EMIX TRIMTONE","TEISCO","CRUMAR","FIRSTMAN", \
         "FOSTEX","PHIL JONES BASS","EVE AUDIO","ULT-SOUND"]

jmakers = ["ヤマハ","ベリンガー","コルグ","ウォルドルフ","ウｫルドルフ","ローランド","クラヴィア","アートリア", \
          "スタジオロジック","エレクトロン","ズーム","ドイプファー","ジョモックス","メロトロン","アカイ","ダト", \
          "ノベーション","ハモンド","ストライモン","オーブ","デッキセーバー","カシオ","アダム","ボス","ユーディージー", \
          "カワイ","シャーマン","アクセス","レオン","ラデル","イーエスアイ","セルバ","タスカム","ハーキュレス","フォーカル", \
          "マッキー","オーバーハイム","エーストーン","ローズ","ホーナー","シーケンシャルサーキット","イーミュー","バイアス", \
          "テスコ","ファーストマン","フォステクス","ゲームチェンジャーオーディオ","シーケンシャル","デイブスミス","モーグ"]

dwords = ["\【U-BOX_MEGA_STORE\】","\【梅田店\】","\【横浜店\】","\【名古屋栄店\】","\【神戸三宮店\】","\【池袋店\】", \
          "\【福岡パルコ店\】","\【御茶ノ水本店\】","\【立川店\】","\【心斎橋店\】","\【渋谷店\】","\【WEBSHOP\】"]

# declare variables
mname = ""
goods = ""
itype = ""
i = 0

datetime = Time.new
filename = "\/Users\/tsuka\/ruby\/scraping\/ishibashi_digital_" + datetime.strftime("%Y%m%d%H%M") + ".txt"
File.open(filename,"w") do |f|
    while i < item_list.length do

        # upcase to check maker name
        goods = item_list[i][0].upcase

        # check maker name and delete maker name
        makers.map do |maker|
          if goods.include?(maker)
            mname = maker
            goods.sub!(maker,"").gsub!("\/"," ")
            goods.gsub!("\(\)","")
            break
          end
        end
    
        # delete japanese maker name
        jmakers.map do |jmaker|
          if goods.include?(jmaker)
            goods.gsub!(jmaker,"")
            break
          end
        end

        # delete needless words
        dwords.map do |dword|
          if goods.include?(dword)
            goods.gsub!(dword,"")
            break
          end
        end

        # check second hands
        if goods.include?("\【中古\】") then

          goods.gsub!("\【中古\】","")
          itype = "old"

        else itype = "" end

        # output file
        f.puts datetime.strftime("%Y%m%d") + sprintf("%05d",i + 1).to_s + "," + "IS" + "," + goods.strip + ","  + item_list[i][1] + "," \
        + mname + "," + "" + "," + itype + "," + "" + "," + item_list[i][2]

        # set variables
        i += 1
        mname = ""

    end

end

puts "SCRAPING DONE!"

img_filepath = "\/Users\/tsuka\/ruby\/scraping\/ishibashi_image_" + datetime.strftime("%Y%m%d%H%M") + ".txt"
File.open(img_filepath,"w") do |f|
  img_array.each do |ipath|
    f.puts ipath
  end
end
#puts img_array
