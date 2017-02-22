require 'rails_helper'
require 'shared/shared_examples_api'
require 'shared/shared_api'

module ApiFlashcards
  describe Api::V1::CardsController, type: :controller do
    routes { ApiFlashcards::Engine.routes }

    describe '#index' do
      context 'without credentials' do
        before(:each) { get :index }
        it_behaves_like 'not autorized'
      end

      context 'with wrong credentials' do
        before(:each) do
          request.headers['Authorization'] = 'some@test.com, wrong_password'
          get :index
        end
        it_behaves_like 'not autorized'
      end

      context 'with correct credentials' do
        include_context 'correct credentials'

        it 'returns 200' do
          expect(response.status).to eq(200)
        end

        it 'returns card fields' do
          expect(response.body).to include(card.to_json)
        end

        it 'returns array of cards' do
          expect(JSON.parse(response.body)).to be_a Array
        end
      end
    end

    describe '#create' do
      context 'without credentials' do
        before(:each) { post :create }
        it_behaves_like 'not autorized'
      end

      context 'with wrong credentials' do
        before(:each) do
          request.headers['Authorization'] = 'some@test.com, wrong_password'
          post :create
        end
        it_behaves_like 'not autorized'
      end

      context 'with correct credentials' do
        include_context 'correct credentials'

        before(:each) do
          request.headers['Authorization'] =
            ActionController::HttpAuthentication::Basic.encode_credentials(user.email, user.password)
          post :create, params
        end

        context 'with correct card params' do
          let(:params) do
            { card:
              {
                original_text: 'Text',
                translated_text: 'Текст',
                block_id: 1
              }
            }
          end

          it 'create card' do
            expect do
              request.headers['Authorization'] =
                ActionController::HttpAuthentication::Basic.encode_credentials(user.email, user.password)
              post :create, params
            end.to change(user.cards, :count).by(1)
          end

          it 'returns 201' do
            expect(response.status).to eq(201)
          end
        end

        context 'with incorect card params' do
          it_behaves_like 'unprocessable entity', card: { original_text: 'Text', translated_text: 'Text', block_id: 1 }
          it_behaves_like 'unprocessable entity', card: { original_text: '', translated_text: 'Text', block_id: 1 }
          it_behaves_like 'unprocessable entity', card: { original_text: 'Text', translated_text: '', block_id: 1 }
          it_behaves_like 'unprocessable entity', card: { original_text: 'Text', translated_text: 'Tran', block_id: '' }
        end
      end
    end
  end
end