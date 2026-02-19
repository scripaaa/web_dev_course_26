#1/usr/bin/env ruby

fileteam, start, finish, out = ARGV
teams = []
File.readlines(fileteam).each_line do |line|
  line = line.strip
  str = line.split(' - ')
  name = str[0]
  city = str[1]
  teams << {name: name, city: city}
end

games = []
  teams.combination(2).each do |team1, team2|
    games << {team1: team1, team2: team2}
end

start_date = DateTime.parse(start, '%dd.mm.yy')
finish_date = DateTime.parse(finish, '%dd.mm.yy')

slots = []
times = ["12:00", "15:00", "18:00"]
days = [5, 6, 7]
current = start_date
while current != finish_date
  if days.include?(current.wday)
    times.each do |time|
      slots << {date: current, time: time, game: games[0]}
      games.delete(game[0])
      current += 1
    end
  end

File.open(out, "w+") do |file|
  slots.each do |s|
    file.puts " Матч #{s:game:team1} vs #{{s:game:team2} } Время: #{s:time} Дата: #{s:date}"
  end
