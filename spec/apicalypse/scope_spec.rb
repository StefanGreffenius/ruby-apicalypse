RSpec.describe Apicalypse::Scope do
  subject { Apicalypse.new('https://api.url') }

  it 'supports hash where scopes' do
    subject.where(name: 'Json Born')
    expect(subject.scope.chain).to eq(where: { name: 'Json Born' })

    subject.where(age: 40)
    expect(subject.scope.chain).to eq(where: { name: 'Json Born', age: 40 })
  end

  describe 'string where scopes' do
    it 'succeed when chained one time' do
      subject.where('name=Json Born && age > 40')
      expect(subject.scope.chain).to eq(where: 'name=Json Born && age > 40')
    end

    it 'raises an exception when chained multiple times' do
      expect do
        subject.where('name=Json Born').where('age > 40')
      end.to raise_error(/Multiple String where scopes are not supported./)
    end

    it 'raises an exception when chained with hash type' do
      expect do
        subject.where(name: 'Json Born').where('age > 40')
      end.to raise_error(/Hash and String where scopes can't be combined./)
    end
  end
end
