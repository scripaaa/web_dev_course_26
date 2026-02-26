#!/usr/bin/env ruby

require 'date'

path, start, finish, out_file = ARGV

if ARGV.size != 4
    puts "Неверное количество аргументов"
    exit 1
end

if out_file.size < 1 || out_file == ""
    puts "Файла вывода нет"
    exit 1
end

teams = []

unless File.exist?(path)
    puts "Файл не найден"
    exit 1
end
File.readlines(path, chomps:true).each do |line|
    next if line.empty?
    line = line.strip    
    str = line.sub(/^\d+\. /, "")
    str = str.split(" — ")
    teams << {name: str[0], city: str[1]}
    teams
end

if teams.size < 2
    puts "Недостаточное количество команд"
    exit 1
end
games = teams.combination(2).to_a
games.shuffle!

times = []
start_date = Date.strptime(start, '%d.%m.%Y')
finish_date = Date.strptime(finish, '%d.%m.%Y')

if start_date > finish_date
  puts "Дата начала не может быть позже даты окончания"
  exit 1
end

current = start_date
while current != finish_date 
    if [5, 6, 0].include?(current.wday)
        ["12:00", "15:00", "18:00"].each do |t|
          times << {date: current, time: t, matches: [], teams: [] }
        end
    end
    current += 1
end
if times.size < 1
    puts "В промежутке между датой начала и датой окончания нет пятницы, субботы, воскресенья"
    exit
end

games.each do |game|
    team1, team2 = game
    slot = times.find do |s|
        s[:matches].size < 2 && s[:teams].size < 4
        && !((s[:teams].include?(team1) || s[:teams].include?(team2)))
    end
    if slot
        slot[:matches] << game
        slot[:teams].concat([team1, team2])
    end
end


File.open(out_file, 'w') do |f|
    times.each do |slot|
        date_str = slot[:date].strftime('%d.%m.%Y')
        wday_str = case slot[:date].wday
            when 5 then 'пятница'
            when 6 then 'суббота'
            when 0 then 'воскресенье'
        end
        time_str = slot[:time]
        matches = slot[:matches]
        if matches.size == 2
            f.puts "#{date_str} ~> #{time_str} ~> #{wday_str}\n"
            f.puts "Играют: #{matches[0][0][:name]} vs #{matches[0][1][:name]}"
            f.puts "        #{matches[1][0][:name]} vs #{matches[1][1][:name]}\n"
            f.puts "Города: #{matches[0][0][:city]} vs #{matches[0][1][:city]}"
            f.puts "        #{matches[1][0][:city]} vs #{matches[1][1][:city]}"
        elsif matches.size == 1
            f.puts "#{date_str} ~> #{time_str} ~> #{wday_str}\n"
            f.puts "Играют: #{matches[0][0][:name]} vs #{matches[0][1][:name]}"
            f.puts "Города: #{matches[0][0][:city]} vs #{matches[0][1][:city]}"
        end
        f.puts "\n"
    end
end


        

