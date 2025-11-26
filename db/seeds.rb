# ------------------------------------
# GPU Products from CSV Dataset
# ------------------------------------

require "csv"

gpu_csv_path = Rails.root.join("db/csv/gpus.csv")
gpu_category = Category.find_or_create_by!(name: "Graphics Cards")

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

puts "✓ Imported #{count} GPUs from CSV!"
