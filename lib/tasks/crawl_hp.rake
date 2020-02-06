namespace :crawl_hp do
  desc "DrinkGenre作成"
  task :make_models_of_drink_genre => :environment do
    def make_model(model_name)
      drink_genre = DrinkGenre.create(genre_name: model_name.to_s)
      log = Logger.new(STDOUT)
      log.info("made model #{model_name}")
    end

    make_model("その他")
    make_model("生ビール")
    make_model("瓶ビール")
    make_model("スーパードライ(アサヒ系)")
    make_model("一番搾り(キリン系)")
    make_model("黒ラベル(サッポロ系)")
    make_model("プレミアムモルツ(サントリー系)")
    make_model("ヱビス")

    log = Logger.new(STDOUT)
    log.info("complete")
  end

  desc "スクレイピング"
  task :crawring_hp => :environment do
    scrape_log = Logger.new("log/scrape.log", 2, 10 * 1024)
    scrape_log.info("Start crawling")
    date = Date.today

    def rand_sleep(sec = 3)
      rand = Random.new
      sleep(rand.rand(1.0..3.0) + sec.to_i)
    end

    (0..851).each do |i|
      begin
        p url = "https://www.hotpepper.jp/yoyaku/SA11/bgn#{852 - i}"
        html = URI(url).read
        # 各ページのHTML解析
        doc = Nokogiri::HTML(html, nil, "utf-8")

        # 店舗記載のブロックを取得
        shops = doc.xpath(
          "//div[@class='shopDetailText']"
        )

        shops.each do |shop_block|
          # 店舗id取得
          shop_url = shop_block.xpath(
            ".//a[@class='fs18 bold lh22 marB1']"
          ).attribute("href").text

          if Shop.find_by(shop_url: shop_url)
            puts "#{shop_url} was skipped"
            next
          end

          shop_link = URI("https://www.hotpepper.jp#{shop_url}").read
          drink_link = URI("https://www.hotpepper.jp#{shop_url}drink/").read
          drink_num = 1
          rand_sleep(3)

          begin
            doc_each_shop = Nokogiri::HTML(shop_link, nil, "utf-8")

            # 店舗名取得
            shop_name = doc_each_shop.xpath(".//h1[@class='shopName']").text

            # 店舗の住所取得
            shop_address = doc_each_shop.xpath(".//td/address[position()=1]").text.strip

            shop = Shop.find_or_initialize_by(shop_url: shop_url, shop_address: shop_address)
            shop.shop_name = shop_name
            shop.crawled_at = date
            p shop
            shop.save!
          rescue => e
            scrape_log = Logger.new("log/scrape.log", 2, 10 * 1024)
            scrape_log.error("#{e}: was closed")
            rand_sleep(3)
          end

          begin
            doc_drink = Nokogiri::HTML(drink_link, nil, "utf-8")

            # drinkメニューHTML取得
            drinks = doc_drink.xpath(
              "//div[@class='shopInner']/h3"
            )

            drinks.each do |drink|
              # drink名取得
              drink_name = drink.text.gsub("\"", "")

              # drink値段取得かつ数字のみに変換
              drink_price = doc_drink.xpath(
                "//dl[@class='price' and position()=#{drink_num}]/dd"
              ).text.gsub(/[^\d]/, "").to_i

              # 将来的には綺麗にしたい
              if (drink_name.length <= 25) && # 25文字以上のドリンクないでしょ
                 (drink_price != 0) && # priceがたまに0のがあるから排除
                 (drink_price <= 1000) #1000円以上のドリンクは飲み放題とかかぶるからなし
                drink = shop.drinks.find_or_initialize_by(drink_name: drink_name)
                drink.drink_price = drink_price
                drink.crawled_at = date
                p drink
                drink.save!
              end
              drink_num += 1
            end
          rescue => e
            scrape_log = Logger.new("log/scrape.log", 2, 10 * 1024)
            scrape_log.error("#{e}: drink menu could not find")
            rand_sleep(3)
            next
          end
          shop.destroy if shop.drinks.empty?
        end
      rescue => e
        scrape_log = Logger.new("log/scrape.log", 2, 10 * 1024)
        scrape_log.error("#{e} in")
        rand_sleep(3)
        next
      end
      rand_sleep(10)
    end
  end

  #   Anemone.crawl(url, skip_quary_strings: true, delay: 10, user_agent: "Mac Safari 4") do |anemone|
  #     page_nm = 1
  #     anemone.focus_crawl do |page|
  #       page.links.keep_if do |link|
  #         link.to_s.match("https://www.hotpepper.jp/yoyaku/SA11/bgn")
  #       end
  #     end

  #     # あるエリアのページを巡回
  #     anemone.on_every_page do |page|
  #       page_nm += 1
  #       begin
  #         html = URI(page.url).read

  #         # 各ページのHTML解析
  #         doc = Nokogiri::HTML(html, nil, "utf-8")

  #         # 店舗記載のブロックを取得
  #         shops = doc.xpath(
  #           "//div[@class='shopDetailText']"
  #         )

  #         shops.each do |shop_block|

  #           # 店舗id取得
  #           shop_url = shop_block.xpath(
  #             ".//a[@class='fs18 bold lh22 marB1']"
  #           ).attribute("href").text

  #           if Shop.find_by(shop_url: shop_url)
  #             puts "#{shop_url} was skipped"
  #             next
  #           end

  #           shop_link = URI("https://www.hotpepper.jp#{shop_url}").read
  #           drink_link = URI("https://www.hotpepper.jp#{shop_url}drink/").read
  #           drink_num = 1
  #           rand_sleep

  #           begin
  #             doc_each_shop = Nokogiri::HTML(shop_link, nil, "utf-8")

  #             # 店舗名取得
  #             shop_name = doc_each_shop.xpath(".//h1[@class='shopName']").text

  #             # 店舗の住所取得
  #             shop_address = doc_each_shop.xpath(".//td/address[position()=1]").text.strip

  #             shop = Shop.find_or_initialize_by(shop_url: shop_url, shop_address: shop_address)
  #             shop.shop_name = shop_name
  #             shop.crawled_at = date
  #             p shop
  #             shop.save!
  #           rescue => e
  #             scrape_log = Logger.new("log/scrape.log", 2, 10 * 1024)
  #             scrape_log.error("#{e}: was closed")
  #             rand_sleep
  #           end

  #           begin
  #             doc_drink = Nokogiri::HTML(drink_link, nil, "utf-8")

  #             # drinkメニューHTML取得
  #             drinks = doc_drink.xpath(
  #               "//div[@class='shopInner']/h3"
  #             )

  #             drinks.each do |drink|
  #               # drink名取得
  #               drink_name = drink.text.gsub("\"", "")

  #               # drink値段取得かつ数字のみに変換
  #               drink_price = doc_drink.xpath(
  #                 "//dl[@class='price' and position()=#{drink_num}]/dd"
  #               ).text.gsub(/[^\d]/, "").to_i

  #               # 将来的には綺麗にしたい
  #               if (drink_name.length <= 25) && # 25文字以上のドリンクないでしょ
  #                  (drink_price != 0) && # priceがたまに0のがあるから排除
  #                  (drink_price <= 1000) #1000円以上のドリンクは飲み放題とかかぶるからなし
  #                 drink = shop.drinks.find_or_initialize_by(drink_name: drink_name)
  #                 drink.drink_price = drink_price
  #                 drink.crawled_at = date
  #                 p drink
  #                 drink.save!
  #               end
  #               drink_num += 1
  #             end
  #           rescue => e
  #             scrape_log = Logger.new("log/scrape.log", 2, 10 * 1024)
  #             scrape_log.error("#{e}: drink menu could not find")
  #             rand_sleep
  #             next
  #           end
  #           shop.destroy if shop.drinks.empty?
  #         end
  #       rescue => e
  #         scrape_log = Logger.new("log/scrape.log", 2, 10 * 1024)
  #         scrape_log.error("#{e} in")
  #         rand_sleep
  #         next
  #       end
  #       rand_sleep
  #     end
  #   end
  # end

  desc "ジャンル分け"
  task :drink_classification => :environment do
    require "levenshtein"

    def similarity(str1, str2)
      1 - Levenshtein.normalized_distance(str1, str2)
    end

    def genre_save(drink, shop_id, genre_id)
      genre = DrinkGenre.find(genre_id)
      puts drink.drink_name
      drink.drink_genre = p genre
      drink.save!
      shop = Shop.find(shop_id)
      shop_gen = shop.drink_genres.ids
      unless shop_gen.include?(genre_id)
        shop.drink_genres << genre
        shop.save!
      end
    end

    def finer_check(drink)
      if drink.drink_name.include?("ヱビス") || drink.drink_name.include?("エビス")
        genre_save(drink, drink.shop_id, 8)
      elsif drink.drink_name.include?("アサヒ") || drink.drink_name.include?("スーパードライ")
        genre_save(drink, drink.shop_id, 4)
      elsif drink.drink_name.include?("モルツ")
        genre_save(drink, drink.shop_id, 7)
      elsif drink.drink_name.include?("サッポロ") || drink.drink_name.include?("黒ラベル")
        genre_save(drink, drink.shop_id, 6)
      elsif drink.drink_name.include?("キリン") || drink.drink_name.include?("一番搾り")
        genre_save(drink, drink.shop_id, 5)
      else
        genre_save(drink, drink.shop_id, 2)
      end
    end

    while Drink.where(drink_genre: nil).count != 0
      drinks = Drink.where(drink_genre: nil).limit(1000)
      drinks.each do |drink|
        if (/ビール|アサヒ|キリン|サッポロ|ヱビスビール|エビス|モルツ/ =~ drink.drink_name) &&
           (/金麦|ノンアルコール|ベース|ゼロ|フリー|零|甘太郎|クリア|ホップ|シャンディ|トマト|レッド|カシス|オレンジ|カンパリ/ !~ drink.drink_name)
          kirin = similarity(drink.drink_name, "キリン一番搾り")
          asahi = similarity(drink.drink_name, "アサヒスーパードライ")
          puremoru = similarity(drink.drink_name, "ザ・プレミアム・モルツ")
          sapporo = similarity(drink.drink_name, "サッポロ黒ラベル")
          ebisu = similarity(drink.drink_name, "ヱビスビール")

          drink_array = [kirin, asahi, puremoru, sapporo, ebisu]

          drink_array.sort!.reverse!

          if drink.drink_name.include?("瓶ビール")
            genre_save(drink, drink.shop_id, 3)
          elsif drink_array[0] <= 0.15
            if drink.drink_name.include?("生ビール")
              finer_check(drink)
            else
              genre_save(drink, drink.shop_id, 1)
            end
          elsif drink_array[0] == asahi
            if drink.drink_name.include?("アサヒ") || drink.drink_name.include?("スーパードライ")
              genre_save(drink, drink.shop_id, 4)
            else
              genre_save(drink, drink.shop_id, 1)
            end
          elsif drink_array[0] == kirin
            genre_save(drink, drink.shop_id, 5)
          elsif drink_array[0] == sapporo
            genre_save(drink, drink.shop_id, 6)
          elsif drink_array[0] == puremoru
            genre_save(drink, drink.shop_id, 7)
          elsif drink.drink_name.include?("ヱビス") || drink.drink_name.include?("エビス")
            genre_save(drink, drink.shop_id, 8)
          elsif drink.drink_name.include?("生ビール")
            finer_check(drink)
          else
            genre_save(drink, drink.shop_id, 1)
          end
        else
          genre_save(drink, drink.shop_id, 1)
        end
      end
    end
  end

  desc "geocode"
  task :add_lat_and_lng => :environment do
    def geocode(shop)
      uri = URI.escape("https://maps.googleapis.com/maps/api/geocode/json?language=ja&address=" + shop.shop_address + "&key=#{ENV['API_KEY']}")
      res = HTTP.get(uri).to_s
      response = JSON.parse(res)
      check = response["status"]
      if check == "OK"
        shop.shop_lat = response["results"][0]["geometry"]["location"]["lat"]
        shop.shop_lng = response["results"][0]["geometry"]["location"]["lng"]
        shop.shop_address = response["results"][0]["formatted_address"].gsub(/日本、/, '').gsub(/\A日本 /, '').gsub(/ 日本\z/, '').gsub(/〒\d{3}-\d{4} /, '').gsub(/\d{3}-\d{4}/, '').gsub(/\A\s*/, '').gsub(/\s*\z/, '')
        shop.save!
        puts shop.shop_lat
        puts shop.shop_lng
        puts shop.shop_address
      else
        scrape_log = Logger.new("log/scrape.log", 2, 10 * 1024)
        scrape_log.error("Not Found #{shop.shop_name} : #{shop.shop_address}")
      end
    end

    shops = Shop.where(shop_lng: nil)
    puts shops.count
    shops.each do |shop|
      geocode(shop) unless shop.shop_lng?
    end
  end

  desc "scraping sequence"
  task scraping_sequence: [:crawring_hp, :drink_classification, :add_lat_and_lng] do
    scrape_log = Logger.new("log/scrape.log", 2, 10 * 1024)
    scrape_log.info("Complete crawling")
  end
end
