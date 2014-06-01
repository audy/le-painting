require File.join(File.dirname(__FILE__), 'spec_helper')

describe User do

  let(:user) {
    User.create(
      name:     'Bones McSkelleton',
      email:    'bones@skellingtons.com',
      password: 'yogs'
  )}

  it 'can be created' do
    user.should_not be_nil
  end

  it 'has a name' do
    user.name.should_not be_nil
  end

  it 'has an email' do
    user.email.should_not be_nil
  end

  it 'has an encrypted password' do
    User.get(user.id).password.should be_nil
  end

  it 'can be authenticated' do
    User.authenticate(user.email, user.password).should_not be_nil
  end

  it 'cannot be authenticated with bad credentials' do
    User.authenticate(user.email, user.password).should_not be_nil
  end
end

describe Post do
  let (:user) { User.create(name: 'testy', email: 'test@test.com', password: 'asdf') }
  let (:post) { Post.create(title: 'test post ', user: user) }

  it 'can be created' do
    post.should_not be_nil
  end

  it 'has a title' do
    post.title.should_not be_nil
  end

  it 'can be saved' do
    post.save.should be_true
  end

  it 'strips title automatically before saving' do
    post.save
    post.title.should == post.title
  end

  it 'can be forked' do
    post.forks << post
    post.save.should be_true
    post.forks.size.should == 1
  end
end
