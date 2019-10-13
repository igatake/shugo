class Beer < ApplicationRecord
  validates :beer_name, presence: true
  validates :beer_price, presence: true
  validates :beer_genre, presence: true
  validates :shop_name, presence: true
  validates :shop_address, presence: true
  validates :shop_url, presence: true



  def self.fetch_beers
    url = 'https://www.hotpepper.jp/yoyaku/SA11/Y050/'
    Anemone.crawl(url, skip_quary_strings: true, delay: 10, user_agent: 'Mac Safari 4') do |anemone|
      page_nm = 1
      anemone.focus_crawl do |page|
        page.links.keep_if do |link|
          link.to_s.match('https://www.hotpepper.jp/yoyaku/SA11/Y050/bgn')
        end
      end

        # あるエリアのページを巡回
      anemone.on_every_page do |page|
        puts "〜〜〜〜〜〜〜〜〜〜〜〜〜#{page_nm}目〜〜〜〜〜〜〜〜〜〜〜〜"
        puts page.url

        page_nm += 1
        begin
          html = URI(page.url).read

          # 各ページのHTML解析
          doc = Nokogiri::HTML(html, nil, 'utf-8')

          # 店舗記載のブロックを取得
          shops = doc.xpath(
            "//div[@class='shopDetailText']"
          )

          shops.each do |shop|

            # 店舗id取得
            shop_url = shop.xpath(
              ".//a[@class='fs18 bold lh22 marB1']"
            ).attribute('href').text

            shop_link = URI("https://www.hotpepper.jp#{shop_url}").read
            drink_link = URI("https://www.hotpepper.jp#{shop_url}drink/").read
            drink_num = 1
            sleep(5)

            begin
              doc_each_shop = Nokogiri::HTML(shop_link, nil, 'utf-8')

              # 店舗名取得
              shop_name = p doc_each_shop.xpath(".//h1[@class='shopName']").text

              # 店舗の住所取得
              shop_address = p doc_each_shop.xpath(".//td/address[position()=1]").text.strip

            rescue => e
              p e
              p '店が潰れてます'
              sleep(5)
            end

            begin
              doc_drink = Nokogiri::HTML(drink_link, nil, 'utf-8')

              store_array = []

              # drinkメニューHTML取得
              drinks =  doc_drink.xpath(
                "//div[@class='shopInner']/h3"
              )

              drinks.each do |drink|
                # drink名取得
                drink_name = drink.text.gsub("\"", "")

                # drink値段取得かつ数字のみに変換
                drink_price = doc_drink.xpath(
                  "//dl[@class='price' and position()=#{drink_num}]/dd"
                ).text.gsub(/[^\d]/, '').to_i

                # 一つ目の条件で入っててほしい単語を指定
                # 二つ目の条件で入ってて欲しくない単語を指定
                # 将来的には綺麗にしたい
                if (/ビール|アサヒ|キリン|サッポロ|ヱビスビール|エビス|モルツ/ =~ drink_name) &&
                  (/金麦|ノンアルコール|ベース|ゼロ|フリー|零|甘太郎|クリア|ホップ|シャンディ|トマト|レッド|カシス|オレンジ|カンパリ/ !~ drink_name) &&
                  (drink_name.length <= 25) && # 25文字以上の生ビールないでしょ
                  (drink_price != 0) && # priceがたまに0のがあるから排除
                  (drink_price <= 1000) then #1000円以上のビールは飲み放題とかかぶるからなし
                  p store_array.push(drink_name, drink_price, shop_name, shop_url, shop_address)
                  store_array = []
                end
                  drink_num += 1
              end
            rescue => e
              p e
              puts 'drinkページがないよー'
              sleep(5)
              next
            end
          end
        rescue => e
          p e
          puts 'そんなことある！？'
          sleep(5)
          next
        end
          sleep(5)
      end
    end
    puts '終了'
  end
end
