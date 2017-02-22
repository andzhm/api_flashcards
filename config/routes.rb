ApiFlashcards::Engine.routes.draw do
  root 'home#main'

  scope module: 'api' do
    namespace :v1 do
      get :cards, to: 'cards#index'
      post :cards, to: 'cards#create'
      get :review_card, to: 'review#index'
      put :review_card, to: 'review#review_card'
    end
  end
end
