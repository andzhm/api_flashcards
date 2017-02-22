module ApiFlashcards
  shared_examples 'not autorized' do
    let(:not_autorized) { 'HTTP Basic: Access denied' }

    it 'return 401 status' do
      expect(response.status).to eq(401)
    end

    it 'return "Not autorized" in body' do
      expect(response.body).to include(not_autorized)
    end
  end

  shared_examples 'unprocessable entity' do |card_params|
    let(:params) { card_params }

    describe 'card' do
      it 'was not created' do
        expect do
          request.headers['Authorization'] =
            ActionController::HttpAuthentication::Basic.encode_credentials(user.email, user.password)
          post :create, params
        end.to change(user.cards, :count).by(0)
      end

      it 'return 422 status code' do
        expect(response.status).to eq(422)
      end

      it 'return errors in body' do
        expect(response.body).to include('errors')
      end
    end
  end
end