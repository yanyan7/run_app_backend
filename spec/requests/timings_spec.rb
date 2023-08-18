require 'rails_helper'

RSpec.describe "Timingsコントローラーのテスト", type: :request do
  describe "GET /index" do
    it '全てのTimingを取得する' do
      create_list(:timing, 3)
  
      get '/api/v1/timings'
      json = JSON.parse(response.body)
  
      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
  
      # 正しい数のデータが返されたか確認する。
      expect(json['data'].length).to eq(3)
    end
  end

  describe "GET /show" do
    it '特定のTimingを取得する' do
      timing = create(:timing, name: 'test-name')
  
      get "/api/v1/timings/#{timing.id}"
      json = JSON.parse(response.body)
  
      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
  
      # 要求した特定のTimingのみ取得した事を確認する
      expect(json['data']['name']).to eq(timing.name)
    end
  end

  describe "POST /create" do
    it '新しいTimingを作成する' do
      valid_params = { name: 'name', sort: 1 }

      #データが作成されている事を確認
      expect { post '/api/v1/timings', params: { timing: valid_params } }.to change(Timing, :count).by(+1)

      # リクエスト成功を表す201が返ってきたか確認する。
      expect(response.status).to eq(201)
    end
  end

  describe "PUT /update" do
    it 'Timingの編集を行う' do
      timing = create(:timing, name: 'old-name')

      put "/api/v1/timings/#{timing.id}", params: { timing: {name: 'new-name'}  }
      json = JSON.parse(response.body)
  
      # リクエスト成功を表す201が返ってきたか確認する。
      expect(response.status).to eq(201)
  
      #データが更新されている事を確認
      expect(json['data']['name']).to eq('new-name')
    end
  end

  describe "DELETE /destroy" do
    it 'Timingを削除する' do
      timing = create(:timing)

      #データが削除されている事を確認
      expect { delete "/api/v1/timings/#{timing.id}" }.to change(Timing, :count).by(-1)
  
      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
    end
  end
end
