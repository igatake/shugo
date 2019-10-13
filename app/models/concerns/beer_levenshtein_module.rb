module BeerLevenshteinModule
  extend ActiveSupport::Concern

  =begin
    ジャンル表
      0 -> その他
      1 -> 生ビール
      2 -> 瓶ビール
      3 -> キリン系
      4 -> アサヒ系
      5 -> モルツ系
      6 -> サッポロ系
      7 -> ヱビス系
  =end

  def self.similarity(str1, str2)
    1 - normalized_distance(str1, str2)
  end

  def self.check_ebisu(drink)
    #ヱビスは'ビ'が入っているためポイントが高くなりガチなので丁寧に
    if drink.include?('ヱビス') || drink.include?('エビス')
      p 'エビスビール'
      return 7
    elsif drink.include?('生ビール')
      Levenshtein.finer_check(drink)
    else
      p 'その他'
      return 0
    end
  end

  def self.finer_check(drink)
    if drink.include?('キリン') || drink.include?('一番搾り')
      p 'キリン一番搾り'
      return 3
    elsif drink.include?('アサヒ') || drink.include?('スーパードライ')
      p 'アサヒスーパードライ'
      return 4
    elsif drink.include?('モルツ')
      p 'ザ・プレミアム・モルツ'
      return 5
    elsif drink.include?('サッポロ') || drink.include?('黒ラベル')
      p 'サッポロ黒ラベル'
      return 6
    elsif drink.include?('ヱビス') || drink.include?('エビス')
      p 'エビスビール'
      return 7
    else
      p '生ビール'
      return 1
    end
  end

  def self.beer_classify(beer_name)
    #それぞれの類似ポイントを算出
    kirin = Levenshtein.similarity(beer_name, 'キリン一番搾り')
    asahi = Levenshtein.similarity(beer_name, 'アサヒスーパードライ')
    puremoru = Levenshtein.similarity(beer_name, 'ザ・プレミアム・モルツ')
    sapporo = Levenshtein.similarity(beer_name, 'サッポロ黒ラベル')
    ebisu =  Levenshtein.similarity(beer_name, 'ヱビスビール')
    beer_array = [kirin, asahi, puremoru, sapporo, ebisu]
    #点数順に並べる
    beer_array.sort!.reverse!
    p beer_array[0]
    #ポイントが一番高いものを選別
    if beer_name.include?('瓶ビール') #瓶ビールはとりあえず種類は選ばず抽出
      p '瓶ビール'
      return 2
    elsif beer_array[0] <= 0.15 #ここのポイントは微調整が必要
      if beer_name.include?('生ビール')
        Levenshtein.finer_check(beer_name)
      else
        p 'その他'
        return 0
      end
    elsif beer_array[0] == kirin
      p 'キリン'
      return 3
    elsif beer_array[0] == asahi
      p 'アサヒスーパードライ'
      return 4
    elsif beer_array[0] == puremoru
      p 'ザ・プレミアム・モルツ'
      return 5
    elsif beer_array[0] == sapporo
      p 'サッポロ黒ラベル'
      return 6
    else
      Levenshtein.check_ebisu(beer_name)
    end
  end
end
