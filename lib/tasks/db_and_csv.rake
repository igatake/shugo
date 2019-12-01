require 'csv'

namespace :db_and_csv do
  desc 'CSV書き出し'
  task write_csv_from_db: :environment do
    def shop_csv
      csv_shop = CSV.generate do |csv|
        csv << Shop.column_names
        # ActiveRecordオブジェクトを生成しながら、10000件ずつデータをメモリに展開して処理
        Shop.find_each(batch_size: 10_000) do |model|
          csv << model.attributes.values_at(*Shop.column_names)
        end
      end
      File.open('./csv/shop.csv', 'w') do |file|
        file.write(csv_shop)
      end
    end

    def drink_csv
      csv_drink = CSV.generate do |csv|
        csv << Drink.column_names
        # ActiveRecordオブジェクトを生成しながら、10000件ずつデータをメモリに展開して処理
        Drink.find_each(batch_size: 10_000) do |model|
          csv << model.attributes.values_at(*Drink.column_names)
        end
      end
      File.open('./csv/drink.csv', 'w') do |file|
        file.write(csv_drink)
      end
    end
  end

  desc 'CSV読み込み'
  task read_csv_to_db: :environment do
    CSV.read('./csv/shop.csv', headers: true).each do |row|
      p Shop.create!(
        shop_name: row['shop_name'],
        shop_address: row['shop_address'],
        shop_url: row['shop_url'],
        crawled_at: row['crawled_at'],
        created_at: row['ceated_at'],
        updated_at: row['updated_at']
      )
    end

    CSV.read('./csv/drink.csv', headers: true).each do |row|
      drink = Drink.new(
        drink_name: row['drink_name'],
        drink_price: row['drink_price'],
        crawled_at: row['crawled_at'],
        created_at: row['ceated_at'],
        updated_at: row['updated_at']
      )
      shop_id = row['shop_id'].to_s
      shop = p Shop.find(shop_id)
      shop.drinks << drink
      drink.save!
      shop.save!
    end
  end
end
