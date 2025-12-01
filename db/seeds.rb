# ------------------------------------
# GPU Products from CSV Dataset
# ------------------------------------

require "csv"

#gpu
gpu_csv_path = Rails.root.join("db/csv/gpus.csv")
gpu_category = Category.find_or_create_by!(name: "Graphics Cards")

#cpu
cpu_category = Category.find_or_create_by!(name: "CPUs")

#peripherals
peripheral_category = Category.find_or_create_by!(name: "Peripherals")

puts "Importing GPUs from CSV..."

count = 0

CSV.foreach(gpu_csv_path, headers: true) do |row|
  name = row["Name"]
  description = <<~DESC
    Architecture: #{row["Architecture"]}
    Memory: #{row["Memory"]}
    Memory Type: #{row["Memory_Type"]}
    Boost Clock: #{row["Boost_Clock"]}
    Core Speed: #{row["Core_Speed"]}
    Memory Speed: #{row["Memory_Speed"]}
    Max Resolution: #{row["Best_Resolution"] || row["Resolution_WxH"]}
    DirectX: #{row["Direct_X"]}
    OpenGL: #{row["Open_GL"]}
    Release Date: #{row["Release_Date"]}
  DESC

  price = row["Release_Price"].present? ? row["Release_Price"].to_f : rand(99..399)
  stock = rand(2..15)

  Product.create!(
    name: name,
    description: description.strip,
    price: price,
    stock: stock,
    category: gpu_category
  )

  count += 1
  break if count >= 20   # limit to 20 products to avoid over-seeding
end

puts " Imported #{count} GPUs from CSV!"



# ------------------------------------
# CPU Products (Faker)
# ------------------------------------

puts "Seeding CPU products..."

20.times do
  cpu_name = [
    "Intel Core i5-#{rand(9400..12600)}",
    "Intel Core i7-#{rand(9700..13900)}",
    "Intel Core i9-#{rand(9900..14900)}",
    "AMD Ryzen 5 #{rand(2600..7600)}",
    "AMD Ryzen 7 #{rand(2700..7800)}",
    "AMD Ryzen 9 #{rand(3900..7950)}"
  ].sample

  cores = [4, 6, 8, 12, 16].sample
  threads = cores * 2
  base_clock = rand(2.5..4.0).round(2)
  boost_clock = rand(4.0..5.7).round(2)
  tdp = [65, 105, 125, 170].sample

  description = <<~DESC
    Cores: #{cores}
    Threads: #{threads}
    Base Clock: #{base_clock} GHz
    Boost Clock: #{boost_clock} GHz
    TDP: #{tdp}W
    Socket: #{["AM4", "AM5", "LGA1151", "LGA1700"].sample}
  DESC

  Product.create!(
    name: cpu_name,
    description: description,
    price: rand(149..799),
    stock: rand(5..20),
    category: cpu_category
  )
end

puts " Seeded CPUs!"




# ------------------------------------
# Peripheral Products (Faker)
# ------------------------------------

puts "Seeding Peripheral products..."

peripheral_items = [
  "Mechanical Keyboard",
  "Gaming Mouse",
  "RGB Mousepad",
  "1080p Monitor",
  "1440p Gaming Monitor",
  "4K UHD Monitor",
  "Gaming Headset",
  "USB Microphone",
  "Webcam 1080p",
  "Webcam 4K"
]

brands = [
  "Logitech",
  "Corsair",
  "Razer",
  "SteelSeries",
  "HyperX",
  "ASUS",
  "MSI",
  "Acer",
  "BenQ",
  "Elgato"
]

20.times do
  item  = peripheral_items.sample
  brand = brands.sample

  # Simple fake model code like "K65", "G502", etc.
  model_code = "#{('A'..'Z').to_a.sample}#{rand(50..999)}"

  name = case item
         when "Mechanical Keyboard"
           "#{brand} #{model_code} Mechanical Keyboard"
         when "Gaming Mouse"
           "#{brand} #{model_code} Gaming Mouse"
         when /Monitor/
           "#{brand} #{model_code} #{item}"
         when "Gaming Headset"
           "#{brand} #{model_code} Gaming Headset"
         when "USB Microphone"
           "#{brand} #{model_code} USB Microphone"
         when /Webcam/
           "#{brand} #{model_code} #{item}"
         else
           "#{brand} #{model_code} #{item}"
         end

  description = case item
                when "Mechanical Keyboard"
                  <<~DESC
                    Switch Type: #{["Red", "Blue", "Brown"].sample}
                    Backlight: #{["RGB", "White", "None"].sample}
                    Connectivity: #{["USB-C Wired", "Wireless 2.4GHz"].sample}
                  DESC
                when "Gaming Mouse"
                  <<~DESC
                    DPI: #{rand(400..26_000)}
                    Buttons: #{rand(5..12)}
                    Weight: #{rand(60..120)}g
                  DESC
                when /Monitor/
                  <<~DESC
                    Resolution: #{item}
                    Refresh Rate: #{[60, 75, 120, 144, 240].sample}Hz
                    Panel Type: #{["IPS", "VA", "TN"].sample}
                  DESC
                when "Gaming Headset"
                  <<~DESC
                    Driver Size: #{rand(40..53)}mm
                    Surround: #{["Stereo", "Virtual 7.1"].sample}
                    Microphone: #{["Detachable", "Flip-to-mute"].sample}
                  DESC
                when "USB Microphone"
                  <<~DESC
                    Polar Pattern: #{["Cardioid", "Omnidirectional", "Bidirectional"].sample}
                    Sample Rate: #{[44_100, 48_000].sample} Hz
                    Connectivity: USB
                  DESC
                when /Webcam/
                  <<~DESC
                    Resolution: #{item.include?("4K") ? "3840x2160" : "1920x1080"}
                    Frame Rate: #{[30, 60].sample} FPS
                    Field of View: #{[78, 90, 110].sample}°
                  DESC
                else
                  Faker::Lorem.paragraph(sentence_count: 3)
                end

  Product.create!(
    name:        name,
    description: description,
    price:       rand(29..499),
    stock:       rand(5..30),
    category:    peripheral_category
  )
end

puts "✓ Seeded Peripherals!"





