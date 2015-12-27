require 'spec_helper'

describe Socket2me do
  it 'has a version number' do
    expect(Socket2me::VERSION).not_to be nil
  end

  it 'is configurable' do
    Socket2me.configure do |config|
      expect(config.ws_host).to be_kind_of(String), 'should have default String values'
      expect(config.ws_port).to be_kind_of(String), 'should have default String values'

      config.ws_host = 'cats'
      config.ws_port = 'dogs'
    end

    expect(Socket2me.config.ws_host).to eq('cats')
    expect(Socket2me.config.ws_port).to eq('dogs')
  end
end
