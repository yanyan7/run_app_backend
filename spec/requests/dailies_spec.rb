require 'rails_helper'

RSpec.describe "Dailiesコントローラーのテスト", type: :request do
  describe "GET /index" do
    it '全てのDailyを取得する' do
      create_list(:daily, 3)
  
      get '/api/v1/dailies'
      json = JSON.parse(response.body)
  
      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
  
      # 正しい数のデータが返されたか確認する。
      expect(json['data'].length).to eq(3)
    end
  end

  describe "GET /show" do
    it '特定のDailyを取得する' do
      daily = create(:daily, weight: 50)
  
      get "/api/v1/dailies/#{daily.id}"
      json = JSON.parse(response.body)
  
      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
  
      # 要求した特定のDailyのみ取得した事を確認する
      expect(json['data']['weight']).to eq(daily.weight)
    end
  end

  describe "POST /create" do
    it '新しいDailyを作成する' do
      valid_params = { date: '2023-01-01', deleted: 0 }

      #データが作成されている事を確認
      expect { post '/api/v1/dailies', params: { daily: valid_params } }.to change(Daily, :count).by(+1)

      # リクエスト成功を表す201が返ってきたか確認する。
      expect(response.status).to eq(201)
    end
  end

  describe "PUT /update" do
    it 'Dailyの編集を行う' do
      daily = create(:daily, date: "2023-01-01")

      put "/api/v1/dailies/#{daily.id}", params: { daily: {date: '2023-01-02'}  }
      json = JSON.parse(response.body)
  
      # リクエスト成功を表す201が返ってきたか確認する。
      expect(response.status).to eq(201)
  
      #データが更新されている事を確認
      expect(json['data']['date']).to eq('2023-01-02')
    end
  end

  describe "DELETE /destroy" do
    it 'Dailyを削除する' do
      daily = create(:daily)

      #データが削除されている事を確認
      expect { delete "/api/v1/dailies/#{daily.id}" }.to change(Daily, :count).by(-1)
  
      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
    end
  end
end
