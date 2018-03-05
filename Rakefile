require "faker"
require "json"

ASSETS_DIR = "./assets/"

task default: %w[pirates]

task :pirates do
  pirates = []

  1000.times do |i|
    pirates << {
      name: Faker::OnePiece::character,
      serial: "GOMU-#{i}",
      value: Faker::OnePiece::akuma_no_mi,
      created: Faker::Date.backward(5000)
    }
  end

  puts "writing one piece pirates"
  File.write(ASSETS_DIR + "pirates.json", JSON.pretty_generate({ pirates: pirates }))
  puts "done"
end