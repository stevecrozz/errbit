describe 'initializers/devise' do
  def load_initializer
    load File.join(Rails.root, 'config', 'initializers', 'devise.rb')
  end

  after do
    ActionMailer::Base.delivery_method = :test
  end

  describe 'omniauth github' do
    it 'sets the client options correctly for the default github_url' do
      allow(Errbit::Config).to receive(:github_url).and_return('https://github.com')
      load_initializer

      options = Devise.omniauth_configs[:github].options
      expect(options).not_to have_key(:client_options)
    end

    it 'sets the client options correctly for the a GitHub Enterprise github_url' do
      allow(Errbit::Config).to receive(:github_url).and_return('https://github.example.com')
      load_initializer

      options = Devise.omniauth_configs[:github].options
      expect(options).to have_key(:client_options)
      expect(options[:client_options]).to eq({
        site: 'https://github.example.com/api/v3',
        authorize_url: 'https://github.example.com/login/oauth/authorize',
        token_url: 'https://github.example.com/login/oauth/access_token',
      })
    end
  end
end
