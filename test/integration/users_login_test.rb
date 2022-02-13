require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  # ログイン失敗時のテスト / passwordが間違っているため
test "login with valid email/invalid password" do
  get login_path
  assert_template 'sessions/new'
  post login_path, params: { session: { email:    @user.email,
                                        password: "invalid" } }
  assert_not is_logged_in? # helperを定義したので使える
  assert_template 'sessions/new' # 無効なログインなのでnewに戻る
  assert_not flash.empty? # flashが存在(する)ことを確認
  get root_path # 別なページへ
  assert flash.empty? # flashが存在(しない)ことを確認
end


# ログイン成功時のテスト
test "login with valid information" do
  get login_path
  post login_path, params: { session: { email:    @user.email,
                                        password: 'password' } }
  assert is_logged_in? # helperを定義したので使える
  assert_redirected_to @user # リダイレクト先が正しいか
  follow_redirect! # 実際にリダイレクト先に移動
  assert_template 'users/show' 
  assert_select "a[href=?]", login_path, count: 0 # リンク確認
  assert_select "a[href=?]", logout_path
  assert_select "a[href=?]", user_path(@user)
  
  # 以降はログアウト処理のテスト
  delete logout_path
  assert_not is_logged_in?
  assert_redirected_to root_url
  # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
  delete logout_path
  follow_redirect!
  assert_select "a[href=?]", login_path
  assert_select "a[href=?]", logout_path,      count: 0
  assert_select "a[href=?]", user_path(@user), count: 0
end

test "login with remembering" do
  log_in_as(@user, remember_me: '1')
  assert_not_empty cookies[:remember_token]
end

test "login without remembering" do
  # cookieを保存してログイン
  log_in_as(@user, remember_me: '1')
  delete logout_path
  # cookieを削除してログイン
  log_in_as(@user, remember_me: '0')
  assert_empty cookies[:remember_token]
end
  
end
