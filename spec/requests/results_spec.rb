require 'rails_helper'

RSpec.describe "Resultsコントローラーのテスト", type: :request do
  describe "GET /index" do
    it '全てのResultを取得する' do
      create_list(:result, 3)
  
      get '/api/v1/results'
      json = JSON.parse(response.body)
  
      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
  
      # 正しい数のデータが返されたか確認する。
      expect(json['data'].length).to eq(3)
    end
  end

  describe "GET /show" do
    it '特定のResultを取得する' do
      result = create(:result, content: 'test-content')
  
      get "/api/v1/results/#{result.id}"
      json = JSON.parse(response.body)
  
      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
  
      # 要求した特定のResultのみ取得した事を確認する
      expect(json['data']['content']).to eq(result.content)
    end
  end

  describe "POST /create" do
    it '新しいResultを作成する' do
      daily = create(:daily)
      valid_params = {
        daily_id: daily.id,
        date: '2023-01-01',
        temperature: nil,
        timing_id: nil,
        content: nil,
        distance: nil,
        time_h: nil,
        time_m: nil,
        time_s: nil,
        pace_m: nil,
        pace_s: nil,
        place: nil,
        shoes: nil,
        note: nil,
        deleted: 0
      }

      #データが作成されている事を確認
      expect { post '/api/v1/results', params: { result: valid_params } }.to change(Result, :count).by(+1)

      # リクエスト成功を表す201が返ってきたか確認する。
      expect(response.status).to eq(201)
    end
  end

  describe "PUT /update" do
    it 'Resultの編集を行う' do
      result = create(:result, content: 'old-content')

      put "/api/v1/results/#{result.id}", params: { result: {content: 'new-content'}  }
      json = JSON.parse(response.body)
  
      # リクエスト成功を表す201が返ってきたか確認する。
      expect(response.status).to eq(201)
  
      #データが更新されている事を確認
      expect(json['data']['content']).to eq('new-content')
    end
  end

  describe "DELETE /destroy" do
    it 'Resultを削除する' do
      result = create(:result)

      #データが削除されている事を確認
      expect { delete "/api/v1/results/#{result.id}" }.to change(Result, :count).by(-1)
  
      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
    end
  end
end
