require 'rails_helper'
require 'shared/shared_examples_api'
require 'shared/shared_api'

module ApiFlashcards
  describe Api::V1::ReviewController, type: :controller do
    routes { ApiFlashcards::Engine.routes }

    describe '#index' do
      context 'without credentials' do
        before(:each) { get :index }
        it_behaves_like 'not autorized'
      end

      context 'with incorrect credentials' do
        before do
          request.headers['Authorization'] = 'some@test.com, wrong_password'
          get :index
        end
        it_behaves_like 'not autorized'
      end

      context 'with correct credentials' do
        include_context 'correct credentials'

        it 'responds with 200 status code' do
          expect(response.status).to eq(200)
        end

        it 'returns card fields' do
          expect(response.body).to include(card.to_json)
        end

       it 'returns only one card' do
          expect(JSON.parse(response.body)).to be_a Hash
        end
      end
    end

    describe '#review_card' do
      context 'without credentials' do
        before(:each) { put :review_card }
        it_behaves_like 'not autorized'
      end

      context 'with incorrect credentials' do
        before do
          request.headers['Authorization'] = 'some@test.com, wrong_password'
          put :review_card
        end
        it_behaves_like 'not autorized'
      end

      context 'with correct credentials' do
        include_context 'correct credentials'

        before(:each) do
          request.headers['Authorization'] =
            ActionController::HttpAuthentication::Basic.encode_credentials(user.email, user.password)
          put :review_card, params
        end

        context 'with correct user translation' do
          let(:params) do
            { card_id: card.id, user_translation: 'house' }
          end

          let(:check_translation_stub) do
            allow_any_instance_of(Card).to receive(:check_translation).with(any_args).and_return(state: true, distance: 0)
          end

          it 'responds with 200 status code' do
            expect(response.status).to eq(200)
          end

          it 'returns "Correct answer" in message' do
            expect(response.body).to include('Correct answer')
          end
        end

        context 'with user typo' do
          let(:params) do
            { card_id: card.id, user_translation: 'hoase' }
          end

          let(:check_translation_stub) do
            allow_any_instance_of(Card).to receive(:check_translation).with(any_args).and_return(state: true, distance: 1)
          end

          it 'responds with 200 status code' do
            expect(response.status).to eq(200)
          end

          it 'returns "Correct answer" in message' do
            expect(response.body).to include('You entered translation from misprint. Please try again')
          end
        end

        context 'with incorrect user translation' do
          let(:params) do
            { card_id: card.id, user_translation: 'wrong_answer' }
          end

          let(:check_translation_stub) do
            allow_any_instance_of(Card).to receive(:check_translation).with(any_args).and_return(state: false, distance: 0)
          end

          it 'responds with 200 status code' do
            expect(response.status).to eq(200)
          end

          it 'returns "Correct answer" in message' do
            expect(response.body).to include('Incorrect answer')
          end
        end
      end
    end
  end
end