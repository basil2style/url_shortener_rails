Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "shortened_urls#index"
  get "/:short_url", to: "shortened_urls#show"
  get "/shortened_urls/:short_url", to: "shortened_urls#shortened", as: :shortened_url
  post "/shortened_urls", to: "shortened_urls#create"
end
