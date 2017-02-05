module ApiFlashcards
  module Api
    module V1
      class CardsController < ApiFlashcards::ApiController
        api :GET, '/v1/cards', 'All user cards'
        def index
          @cards = current_user.cards.order(:review_date)
          render json: @cards, status: :ok
        end

        api :POST, '/v1/cards', 'Create new card'
        param :original_text, String
        param :translated_text, String
        param :block_id, Integer

        def create
          @card = current_user.cards.build(card_params)
          if @card.save
            render json: { message: 'success' }, status: :created
          else
            render json: { message: 'failed', errors: @card.errors }, status: :unprocessable_entity
          end
        end

        private

        def card_params
         params.require(:card).permit(:original_text, :translated_text, :block_id)
        end
      end
    end
  end
end