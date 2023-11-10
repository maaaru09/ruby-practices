# frozen_string_literal: true

# !/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')
shots = []

scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each.with_index do |frame, i|
  next_frame = frames[i + 1]
  next_next_frame = frames[i + 2]
  point +=
    # ストライクの点数加算 && 9フレーム目まで
    if frame[0] == 10 && i < 9
      # 加算される次のフレームがストライクだった場合
      if next_frame[0] == 10
        10 + 10 + next_next_frame[0]
      else
        10 + (next_frame[0] + next_frame[1])
      end
    # スペアの点数加算 && 9フレーム目まで
    elsif frame.sum == 10 && i < 9
      10 + next_frame[0]
    else
      frame.sum
    end
end
puts point
