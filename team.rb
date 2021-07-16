  if false
  irb --noecho
  require '/Users/ryu/workspace/vending_macine/team.rb'
  vm = VendingMachine.new
  vm.slot_money (500)
  vm.current_slot_money
  vm.drink_list
  vm.possible_drinks
  vm.buy_drink
  vm.sales
  vm.return_money
end


class VendingMachine
  MONEY = [10, 50, 100, 500, 1000].freeze

  # 初期値
  def initialize
    @slot_money = 0
    @sales = 0
    @drinks = [
      { 番号: 1, 名前: 'コーラ', 値段: 120,  在庫: 5},
      { 番号: 2, 名前: 'レッドブル', 値段: 200,  在庫: 5},
      { 番号: 3, 名前: '水', 値段: 100,  在庫: 5},
      { 番号: 4, 名前: 'お茶', 値段: 110,  在庫: 10},
    ]
  end

  # 自販機に(money)円を投入
  def slot_money(money)
    if MONEY.include?(money)
      puts " \n#{@slot_money += money}円入っています\n "
    else
      puts " \n投入できません"
      puts "#{money}円を返却します\n "
    end
  end

  # 自販機に入っている金額の合計
  def current_slot_money
    @slot_money == 0 ?
     (puts " \nお金を入れてください\n ") :
     (puts " \n#{@slot_money}円投入済みです\n ")
  end

  # irbの改行
  def new_line
    puts " "
  end

  # ドリンクの在庫
  def drink_list
    new_line
    @drinks.each { |drink| puts "#{drink[:番号]}.#{drink[:名前]} : #{drink[:値段]}円（残り#{drink[:在庫]}本）"}
    new_line
  end

  # 購入できない時の処理の切り出し
  def can_not_buy(stock, name)
    if stock == 0
      puts "#{name}は売り切れました。"
    else
      puts "#{name}を買うにはお金が足りません。"
    end
  end

  # 購入可能なドリンクの確認
  def possible_drinks
    new_line
    @drinks.each do |drink|
      if @slot_money >= drink[:値段] && drink[:在庫] > 0
        puts "#{drink[:名前]}を買えます。"
      else
        can_not_buy(drink[:在庫], drink[:名前])
      end
    end
    new_line
  end

  # 払い戻し
  def return_money
    puts " \nおつりは#{@slot_money}円です\n "
    @slot_money = 0
  end

  # ドリンクを購入する
  def buy_drink
    puts " \n購入したい番号を入力してください"

    while true do
      drink_list
      puts "#{@drinks.last[:番号] + 1}.購入をやめる"
      input = gets.to_i
      new_line
      numbers = (1..@drinks.size)
      if numbers.include?(input)
        drink_name = @drinks[input-1][:名前]
        drink_price = @drinks[input-1][:値段]
        drink_stocks = @drinks[input-1][:在庫]
        if @slot_money >= drink_price && drink_stocks > 0
          4.times {
            puts "・"
            sleep 0.3
          }
          puts "#{drink_name}を買いました！"
          @slot_money -= drink_price
          @drinks[input-1][:在庫] -= 1
          @sales += drink_price
          puts "残金は#{@slot_money}円です！"
        else
          can_not_buy(drink_stocks, drink_name)
        end
        puts " \n購入したい番号を入力してください"
      elsif input == @drinks.size + 1
        puts "お買い上げありがとうございました!"
        return_money
        return
      else
        puts "もう一度番号を入力してください"
      end
    end
  end

  # 売り上げの確認
  def sales
    puts " \n現在の売り上げ金額は#{@sales}円です\n "
  end

end
