# ------------------------------------
# GPU Products from CSV Dataset
# ------------------------------------

require "csv"
require "open-uri"

def attach_remote_image(product, keyword)
  url = "https://picsum.photos/seed/#{keyword + rand(1000).to_s}/600/400"
  file = URI.open(url)

  product.image.attach(
    io: file,
    filename: "#{keyword}.jpg",
    content_type: "image/jpeg"
  )
rescue => e
  puts "Image failed for #{product.name}: #{e.message}"
end

# Universal pricing generator
def generate_pricing(min_price, max_price)
  min_price = min_price.to_i
  max_price = max_price.to_i

  # Prevent invalid ranges
  max_price = min_price + 1 if max_price <= min_price

  # Generate valid original price
  original = rand(min_price..max_price)

  # Randomly decide sale
  on_sale = [true, false].sample

  if on_sale
    # Discount = between 10 and maximum 30% OR at least 10 minimum
    max_discount = [(original * 0.3).to_i, 10].max
    discount = rand(10..max_discount)
    sale = original - discount
  else
    sale = nil
  end

  [original, sale, on_sale]
end


# ------------------------------------
# Categories
# ------------------------------------

gpu_category        = Category.find_or_create_by!(name: "Graphics Cards")
cpu_category        = Category.find_or_create_by!(name: "CPUs")
peripheral_category = Category.find_or_create_by!(name: "Peripherals")
storage_category    = Category.find_or_create_by!(name: "Storage")

# ------------------------------------
# GPUs (CSV)
# ------------------------------------

puts "Importing GPUs from CSV..."

gpu_csv_path = Rails.root.join("db/csv/gpus.csv")
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

  original_price, sale_price, on_sale = generate_pricing(150, 600)

  p = Product.create!(
    name: name,
    description: description.strip,
    original_price: original_price,
    sale_price: sale_price,
    on_sale: on_sale,
    stock: rand(2..15),
    category: gpu_category
  )

  attach_remote_image(p, "graphics-card")

  count += 1
  break if count >= 20
end

puts " Imported #{count} GPUs!"

# ------------------------------------
# CPUs (Faker)
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

  description = <<~DESC
    Cores: #{rand(4..16)}
    Threads: #{rand(8..32)}
    Base Clock: #{rand(2.5..4.0).round(2)} GHz
    Boost Clock: #{rand(4.0..5.7).round(2)} GHz
    TDP: #{[65, 105, 125, 170].sample}W
    Socket: #{["AM4", "AM5", "LGA1151", "LGA1700"].sample}
  DESC

  original_price, sale_price, on_sale = generate_pricing(200, 900)

  p = Product.create!(
    name: cpu_name,
    description: description,
    original_price: original_price,
    sale_price: sale_price,
    on_sale: on_sale,
    stock: rand(5..20),
    category: cpu_category
  )

  attach_remote_image(p, "cpu")
end

puts " Seeded CPUs!"

# ------------------------------------
# Peripherals
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
  "Logitech", "Corsair", "Razer", "SteelSeries", "HyperX",
  "ASUS", "MSI", "Acer", "BenQ", "Elgato"
]

20.times do
  item = peripheral_items.sample
  brand = brands.sample
  model_code = "#{('A'..'Z').to_a.sample}#{rand(50..999)}"

  name = "#{brand} #{model_code} #{item}"
  description = "#{item} by #{brand}. Model #{model_code}."

  original_price, sale_price, on_sale = generate_pricing(20, 200)

  p = Product.create!(
    name: name,
    description: description,
    original_price: original_price,
    sale_price: sale_price,
    on_sale: on_sale,
    stock: rand(5..30),
    category: peripheral_category
  )

  keyword = case item
            when "Mechanical Keyboard" then "keyboard"
            when "Gaming Mouse" then "mouse"
            when /Monitor/ then "monitor"
            when "Gaming Headset" then "headset"
            when "USB Microphone" then "microphone"
            when /Webcam/ then "webcam"
            else "computer-accessory"
            end

  attach_remote_image(p, keyword)
end

puts " Seeded Peripherals!"

# ------------------------------------
# Static Pages
# ------------------------------------

puts "Creating editable static pages..."

Page.find_or_create_by!(slug: "about") do |page|
  page.title = "About Us"
  page.content = "Write something about your store here."
end

Page.find_or_create_by!(slug: "contact") do |page|
  page.title = "Contact Us"
  page.content = "You can contact us using the form below or email support@example.com."
end

puts " Static pages created."

# ------------------------------------
# Storage
# ------------------------------------

puts "Seeding Storage products..."

storage_types = [
  "SATA SSD",
  "NVMe SSD",
  "External HDD",
  "Internal HDD"
]

20.times do
  type = storage_types.sample
  brand = ["Samsung", "Western Digital", "Seagate", "Crucial", "Kingston"].sample
  capacity = ["250GB", "500GB", "1TB", "2TB", "4TB"].sample

  name = "#{brand} #{capacity} #{type}"
  description = "#{capacity} #{type} storage device."

  original_price, sale_price, on_sale = generate_pricing(40, 300)

  p = Product.create!(
    name: name,
    description: description,
    original_price: original_price,
    sale_price: sale_price,
    on_sale: on_sale,
    stock: rand(5..25),
    category: storage_category
  )

  keyword = type.include?("SSD") ? "ssd" : "hdd"
  attach_remote_image(p, keyword)
end

puts " Seeded Storage!"



# PROVINCES and taxes
Province.destroy_all

Province.create!([
  { name: "Alberta", gst: 0.05, pst: 0, hst: 0 },
  { name: "British Columbia", gst: 0.05, pst: 0.07, hst: 0 },
  { name: "Manitoba", gst: 0.05, pst: 0.07, hst: 0 },
  { name: "New Brunswick", gst: 0, pst: 0, hst: 0.15 },
  { name: "Newfoundland and Labrador", gst: 0, pst: 0, hst: 0.15 },
  { name: "Northwest Territories", gst: 0.05, pst: 0, hst: 0 },
  { name: "Nova Scotia", gst: 0, pst: 0, hst: 0.15 },
  { name: "Nunavut", gst: 0.05, pst: 0, hst: 0 },
  { name: "Ontario", gst: 0, pst: 0, hst: 0.13 },
  { name: "Prince Edward Island", gst: 0, pst: 0, hst: 0.15 },
  { name: "Quebec", gst: 0.05, pst: 0.09975, hst: 0 },
  { name: "Saskatchewan", gst: 0.05, pst: 0.06, hst: 0 },
  { name: "Yukon", gst: 0.05, pst: 0, hst: 0 }
])

