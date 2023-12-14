class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
#DM機能のため追加 ---------------------------
  #whereメソッドとは、テーブル内の条件に一致したレコードを取得することができるメソッド
  #roomがcreateされた時に現在ログインしているユーザーと、「チャットへ」ボタンを押されたユーザーの両方をEntriesテーブルに記録する
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)

  #現在ログインしているユーザーではないという条件
  #すでにroomが作成されている場合とされていない場合に分岐
    if @user.id == current_user.id
    #作成されている場合、 @currentUserEntryと@userEntryをeachで一つずつ取り出し、それぞれEntriesテーブル内にあるroom_idが共通しているユーザー同士に対して@roomId = cu.room_idという変数を指定
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true #@isRoom = trueは、falseのとき（Roomを作成するとき）の条件を分岐するための記述
            @roomId = cu.room_id
          end
        end
      end
      #if @isRoom内では、新しくインスタンスを生成するために.newを記述
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
#--------------------------------------------
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
