require 'rails_helper'

RSpec.describe User, type: :model do
  it 'create with name and githubUser' do
    user_factory = FactoryBot.attributes_for(:user)

    user = User.new(user_factory)

    expect(user).to be_valid
    expect(user.name).to eq(user_factory[:name])
    expect(user.githubUser).to eq(user_factory[:githubUser])
  end

  it '(fail) create without name' do
    user_factory = { githubUser: 'aaa' }

    user = User.new(user_factory)

    expect(user).to_not be_valid
    expect(user.name).to eq(user_factory[:name])
    expect(user.githubUser).to eq(user_factory[:githubUser])
  end

  it '(fail) create without githubUser' do
    user_factory = { name: 'aaa' }

    user = User.new(user_factory)

    expect(user).to_not be_valid
    expect(user.name).to eq(user_factory[:name])
    expect(user.githubUser).to eq(user_factory[:githubUser])
  end
end
