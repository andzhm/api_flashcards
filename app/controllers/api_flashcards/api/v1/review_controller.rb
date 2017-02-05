module ApiFlashcards
  module Api
    module V1
      class ReviewController < ApiFlashcards::ApiController
        api :GET, '/v1/review_card', 'Card data for user'
        param :id, Integer,  desc: 'Card id for send review card data'
        def index
          if params[:id]
            @card = current_user.cards.find(params[:id])
          else
            @card = first_repeating_or_pending_card
          end

          render json: @card, status: :ok
        end

        api :PUT, '/v1/review_card', 'Data for check'
        param :card_id, String, desc: 'Card id for check translation'
        param :user_translation, String, desc: 'User translation'
        def review_card
          @card = current_user.cards.find(params[:card_id])
          check_result = @card.check_translation(review_params[:user_translation])

          if check_result[:state]
            handle_correct_answer(check_result[:distance])
          else
            render json: { message: 'Wrong answer' }, status: :ok
          end
        end

        private

        def review_params
          params.permit(:user_translation)
        end

        def first_repeating_or_pending_card
          if current_user.current_block
            current_user.current_block.cards.first_repeating_or_pending_card
          else
            current_user.cards.first_repeating_or_pending_card
          end
        end

        def handle_correct_answer(distance)
          if distance == 0
            render json: { message: 'Right answer' }, status: :ok
          else
            render json: { message: 'You have mistake. Please try again' }, status: :ok
          end
        end
      end
    end
  end
end