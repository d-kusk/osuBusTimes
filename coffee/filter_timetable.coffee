# 行き先を元に時刻表のデータを絞り込む処理
filterTimeTable = (timeTables, dest) ->
  window.busTime =
    dest: '',
    timeTable: {},
    hour: 0,
    times: []

  # 目的地に合わせて時刻表を抜き出す
  if (dest == 'osu')
    # 大阪産業大学行きの時刻業
    busTime.dest = '大阪産業大学'
    busTime.timeTable = timeTables.timeTableToOSU
  else if (dest == 'sta')
    # 住道駅行きの時刻表
    busTime.dest = '住道駅'
    busTime.timeTable = timeTables.timeTableToSta
  else
    console.log 'Error: 行き先から不正に値を取得しました。'

  do ->
    # 現在時間を元に絞り込む
    d = new Date()
    hour = d.getHours()
    minute = d.getMinutes()

    if (7 <= hour <= 21)
      busTime.hour = hour
      allTimes = busTime.timeTable[Number(hour)]

      # 現在の時間帯のバスの出発時刻一覧から
      _i = 0
      while (_i < allTimes.length)
        if (minute < allTimes[_i])
          busTime.times.push(allTimes[_i])
        _i++

      # 現時間帯にバスがない場合に次の時間帯の一覧を追加
      if busTime.times.length == 0
        busTime.hour++
        busTime.times = busTime.timeTable[Number(hour)+1]
    else
      busTime.hour = 7
      busTime.times = busTime.timeTable[7]
