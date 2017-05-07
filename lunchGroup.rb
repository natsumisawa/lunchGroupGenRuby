#初期設定
age = Array.new(160)
job = Array.new(160)
sex = Array.new(160)
for i in 0..159
  age[i] = rand(4)
  job[i] = rand(4)
  sex[i] = rand(2)
end
#個体の生成
ele = Array.new(11)
for i in 0..10
  ele[i]= Array.new(40)
  #160人をランダムな番号で並ばせる
  personArray = (0..159).to_a.shuffle!
  for j in 0..39
    ele[i][j] = Array.new(4)
    sliceArray = personArray.slice!(0, 4)
    for k in 0..3
      ele[i][j][k] = sliceArray[k]
    end
  end
end

#gene世代繰り替えす
gene = 50
for g in 0..gene

  #評価(同じチームのメンバーと年齢、職種が違ったら+5点、性別が違ったら+2点)
  score = Array.new(11)
  for i in 0..10
    score[i] = Array.new(40)
    for j in 0..39
      score[i][j] = 0
      for k in 0..3
        for m in 0..3
          if age[ele[i][j][k]] != age[ele[i][j][m]]
            score[i][j] += 5
          end
        end
        for m in 0..3
          if job[ele[i][j][k]] != job[ele[i][j][m]]
            score[i][j] += 5
          end
        end
        for m in 0..3
          if sex[ele[i][j][k]] != sex[ele[i][j][m]]
            score[i][j] += 2
          end
        end
      end
    end
    average = score[i].inject(0){|sum, j| sum + j } / score[i].size
    #各月の平均
    puts average
  end
  
  #エリート戦略(スコアが最大のチームは後で交叉を行わない)
  #memo score[i][selectGroup] < averageしてるから今のとこ意味ない
  for i in 0..10
    maxScore = score[i].max
    for j in 0..39
      if score[i][j] == maxScore
        maxGroup = {}
        maxGroup[i] = j
      end
    end
  end

  #交叉
  #memo メソッドにしたい
  10.times do
    for i in 0..10
      minScore = score[i].min
      selectGroup = rand(40)
      if selectGroup != maxGroup[i] && score[i][selectGroup] < average
        for j in 0..39
          if score[i][j] == minScore
            slicePoint = rand(2) + 1
            keepArray = Array.new(11)
            keepArray[i] = Array.new(40)
            keepArray[i][j] = ele[i][j]
            for k in 0..slicePoint
              ele[i][j][k] = ele[i][selectGroup][k] 
            end
            for k in slicePoint..3
              ele[i][selectGroup][k] = keepArray[i][j][k]
            end
          end
        end
      end
    end
  end

  #memo 突然変異はできない？

  #次の月とメンバーが二人以上かぶっていたらランダムに交叉させる(またお前かいの回避)
  for i in 0..9
    for j in 0..39
      for m in 0..39
        checkArray = ele[i][j] + ele[i + 1][m]
        #重複要素が2つ以上になるとuniqを探したとき配列の長さが6以下になる
        if checkArray.uniq.count <= 6
          # puts "重複があります"
          # puts ele[i][j]
          # puts "-----"
          # puts ele[i + 1][m]
          #交叉させて壊す
          10.times do
            selectGroup = rand(40)
            if selectGroup != maxGroup[i] && score[i][selectGroup] < average
              slicePoint = rand(2) + 1
              keepArray = Array.new(11)
              keepArray[i] = Array.new(40)
              keepArray[i][j] = ele[i][j]
              for k in 0..slicePoint
                ele[i][j][k] = ele[i][selectGroup][k] 
              end
              for k in slicePoint..3
                ele[i][selectGroup][k] = keepArray[i][j][k]
              end
            end
          end
        end
        checkArray = ele[i][j] + ele[i + 1][m]
        #重複が解消されたか確認用
        # if checkArray.uniq.count <= 6
        #   puts "重複が解消されませんでした"
        #   puts ele[i][j]
        #   puts "-----"
        #   puts ele[i + 1][m]
        # end
      end
    end
  end

#点数確認用
# for i in 0..10
# puts gene
# puts "世代の"
# puts i
# puts "月各チームの点数"
#   for j in 0..39
#     puts score[i][j]
#   end
# end

end

#最終結果確認用
# for i in 0..10
#   puts i
#   puts "月各チームの点数"
#   for j in 0..39
#     puts score[i][j]
#     puts "点"
#     for k in 0..3
#       puts age[ele[i][j][k]]
#     end
#     for k in 0..3
#       puts job[ele[i][j][k]]
#     end
#     for k in 0..3
#       puts sex[ele[i][j][k]]
#     end
#   end
# end