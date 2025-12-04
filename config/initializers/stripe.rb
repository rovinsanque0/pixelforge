# Stripe.api_key = ENV["STRIPE_SECRET_KEY"] # wihtout docker run this


Stripe.api_key = Rails.application.credentials.stripe[:secret_key]
