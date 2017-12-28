require 'rom/mongo/relation'

RSpec.describe ROM::Mongo::Relation do
  include_context 'database'
  include_context 'users'

  describe '#by_pk' do
    it 'fetches a document by _id' do
      expect(users.by_pk(jane_id).one!.to_h).
        to eql(_id: jane_id, name: 'Jane', email: 'jane@doe.org')
    end
  end

  describe '#order' do
    it 'sorts documents' do
      expect(users.order(name: :asc).only(:name).without(:_id).to_a.map(&:to_h)).
        to eql([{name: 'Jane',}, {name: 'Joe'}])

      expect(users.order(name: :desc).only(:name).without(:_id).to_a.map(&:to_h)).
        to eql([{name: 'Joe'}, {name: 'Jane'}])
    end

    it 'supports mutli-field sorting' do
      expect(users.order(name: :asc, email: :asc).only(:name).without(:_id).to_a.map(&:to_h)).
        to eql([{name: 'Jane',}, {name: 'Joe'}])

      expect(users.order(email: :asc, name: :asc).only(:name).without(:_id).to_a.map(&:to_h)).
        to eql([{name: 'Joe',}, {name: 'Jane'}])
    end
  end

  describe '#aggregate' do
    subject(:relation) { users.with(auto_struct: false).aggregate(query) }

    let(:query) { [{ '$group': { _id: 1, count: { '$sum': 1 } } }] }

    it 'aggregate documents' do
      expect(relation.to_a).to eql([{ "_id" => 1, "count" => 2 }])
    end
  end
end
