Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :games, only: [:create] do
    member do
      post "turn"
    end
  end

  post "score", controller: "games", action: "score"

  resources :messages, only: [:create]
  resources :events, only: [:create]
end
