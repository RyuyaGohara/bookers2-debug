class RoomsController < ApplicationController
  before_action :authenticate_user!
    
  def create
    @room = Room.create(user_id: current_user.id)
    #現在ログインしているユーザーに対しては、@entry1として、EntriesテーブルにRoom.createで作成された@roomに紐づくidと、現在ログインしているユーザーのidを保存させる
    @entry1 = Entry.create(:room_id => @room.id, :user_id => current_user.id)
    #@entry2では、フォローされている側の情報をEntriesテーブルに保存する
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(:room_id => @room.id))
    #チャットルームが開くようにredirect
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    #まず１つのチャットルームを表示させる必要があるので、findメソッドを使用。
    @room = Room.find(params[:id])
    #条件でまず、Entriesテーブルに、現在ログインしているユーザーのidとそれにひもづいたチャットルームのidをwhereメソッドで探し、そのレコードがあるか確認
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
    #trueだったら、Messageテーブルにそのチャットルームのidと紐づいたメッセージを表示させる
      @messages = @room.messages #アソシエーションを利用した@room.messagesを@messagesに代入
    #新しくメッセージを作成する場合は、メッセージのインスタンスを生成
      @message = Message.new
    #ユーザーの名前などの情報を表示させるために、@room.entriesを@entriesというインスタンス変数に入れ、Entriesテーブルのuser_idの情報を取得
      @entries = @room.entries
    #Roomで相手の名前表示するために記述
      @myUserId = current_user.id
    #条件がfalseだったら、前のページに戻る
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
end
