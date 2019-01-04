RSpec.describe Apicalypse::Request do
  let(:api_url) { 'https://api.url' }
  let(:api_request_headers) do
    { 'user-key' => 'your-api-key' }
  end

  it 'get request to api' do
    stub_request(:get, api_url).to_return(status: 200, body: "\{\}")

    Apicalypse.new(api_url).request
  end

  it 'supports header options' do
    stub_request(:get, api_url)
      .with(headers: api_request_headers)
      .to_return(status: 200, body: "\{\}")

    Apicalypse.new(api_url, headers: api_request_headers).request
  end

  it 'supports query string requests' do
    stub_request(:get, api_url + '?fields=name,age')
      .to_return(status: 200, body: "\{\}")

    Apicalypse.new(api_url, query_method: :url).query('fields=name,age').request
  end

  it 'supports body requests' do
    stub_request(:get, api_url)
      .with(body: 'fields name,age;')
      .to_return(status: 200, body: "\{\}")

    Apicalypse.new(api_url).fields(:name, :age).request
  end

  it 'parses the json response' do
    stub_request(:get, api_url)
      .with(headers: api_request_headers)
      .with(body: 'fields name;search "Foo";limit 2;')
      .to_return(status: 200, body: '[{"id":1,"name":"Foo"},{"id":2,"name":"Fooo"}]')

    api = Apicalypse.new(api_url, headers: api_request_headers)
    api.fields(:name).search('Foo').limit(2)

    expect(api.request).to match [{ 'id' => 1, 'name' => 'Foo' }, { 'id' => 2, 'name' => 'Fooo' }]
  end
end
