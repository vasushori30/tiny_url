Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "short_urls#index"
  get ":short_url", to: "short_urls#show"
  get "short_urls/:short_url", to: "short_urls#shortened", as: :shortened
  post "short_urls/create"
  get "short_urls/fetch_original_url"

end