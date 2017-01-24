module ApiFlashcards
  class ApplicationController < ActionController::Base
    http_basic_authenticate_with name: 'newuser', password: 'userpass'
  end
end