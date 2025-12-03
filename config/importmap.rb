# Pin npm packages by running ./bin/importmap

# pin "application"
# pin "bootstrap" # @5.3.8
# pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
# 
#
# Pin npm packages by running ./bin/importmap

pin "application"

# Bootstrap + Popper (Correct)
pin "bootstrap", to: "bootstrap.min.js"
pin "@popperjs/core", to: "popper.js"

