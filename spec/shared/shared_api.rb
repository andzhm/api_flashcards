module ApiFlashcards
  shared_context 'correct credentials' do
    let!(:user)  { FactoryGirl.create(:user) }
    let!(:block) { FactoryGirl.create(:block, title: 'Test Block', user_id: user.id) }
    let!(:card)  { FactoryGirl.create(:card, user_id: user.id, block_id: block.id) }
    let!(:check_translation_stub) {}

    before(:example) { check_translation_stub }

    before(:each) do
      get :index, request.headers['Authorization'] =
        ActionController::HttpAuthentication::Basic.encode_credentials(user.email, user.password)
    end
  end
end