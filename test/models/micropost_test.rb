require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

def setup
  @user = users(:michael)
  # userを通しているのでuser_idは自動で入力される
  @micropost = @user.microposts.build(content: "Lorem ipsum")
end

test "should be valid" do
  assert @micropost.valid?
end

test "user id should be present" do
  @micropost.user_id = nil
  assert_not @micropost.valid?
end

test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

test "content should be at most 140 characters" do
  @micropost.content = "a" * 141
  assert_not @micropost.valid?
end

# DB上の最初の投稿がfixture内の最初の投稿と同じかテスト
test "order should be most recent first" do
# マイクロポストのfixtureがあるという前提に依存している
  assert_equal microposts(:most_recent), Micropost.first
end

end
