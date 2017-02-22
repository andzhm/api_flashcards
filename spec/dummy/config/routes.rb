Rails.application.routes.draw do
  mount ApiFlashcards::Engine => "/api"
end