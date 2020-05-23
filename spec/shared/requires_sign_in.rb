RSpec.shared_examples 'requires sign in' do
  context 'when signed out' do
    it { is_expected.to redirect_to sign_in_path }
    it { expect(flash[:alert]).to be_present }
  end
end
