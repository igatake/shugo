require 'csv'

namespace :db_and_csv do

  desc "CSV書き出し"
  task :write_csv_from_db => :environment do
    def shop_csv
      csv_shop = CSV.generate do |csv|
        csv << Shop.column_names
        # ActiveRecordオブジェクトを生成しながら、10000件ずつデータをメモリに展開して処理
        Shop.find_each(:batch_size => 10000) do |model|
          csv << model.attributes.values_at(*Shop.column_names)
        end
      end
      File.open("./csv/shop.csv", 'w') do |file|
        file.write(csv_shop)
      end
    end

    def drink_csv
      csv_drink = CSV.generate do |csv|
        csv << Drink.column_names
        # ActiveRecordオブジェクトを生成しながら、10000件ずつデータをメモリに展開して処理
        Drink.find_each(:batch_size => 10000) do |model|
          csv << model.attributes.values_at(*Drink.column_names)
        end
      end
      File.open("./csv/drink.csv", 'w') do |file|
        file.write(csv_drink)
      end
    end

    shop_csv
    drink_csv
  end
end