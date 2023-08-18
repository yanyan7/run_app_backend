require 'rails_helper'

RSpec.describe "SleepPatternsコントローラーのテスト", type: :request do
  describe "GET /index" do
    it '全てのSleepPatternを取得する' do
      create_list(:sleep_pattern, 3)
  
      get '/api/v1/sleep_patterns'
      json = JSON.parse(response.body)
  
      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
  
      # 正しい数のデータが返されたか確認する。
      expect(json['data'].length).to eq(3)
    end
  end

  describe "GET /show" do
    it '特定のSleepPatternを取得する' do
      sleep_pattern = create(:sleep_pattern, name: 'test-name')
  
      get "/api/v1/sleep_patterns/#{sleep_pattern.id}"
      json = JSON.parse(response.body)
  
      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
  
      # 要求した特定のSleepPatternのみ取得した事を確認する
      expect(json['data']['name']).to eq(sleep_pattern.name)
    end
  end

  describe "POST /create" do
    it '新しいSleepPatternを作成する' do
      valid_params = { name: 'name', sort: 1 }

      #データが作成されている事を確認
      expect { post '/api/v1/sleep_patterns', params: { sleep_pattern: valid_params } }.to change(SleepPattern, :count).by(+1)

      # リクエスト成功を表す201が返ってきたか確認する。
      expect(response.status).to eq(201)
    end
  end

  describe "PUT /update" do
    it 'SleepPatternの編集を行う' do
      sleep_pattern = create(:sleep_pattern, name: 'old-name')

      put "/api/v1/sleep_patterns/#{sleep_pattern.id}", params: { sleep_pattern: {name: 'new-name'}  }
      json = JSON.parse(response.body)
  
      # リクエスト成功を表す201が返ってきたか確認する。
      expect(response.status).to eq(201)
  
      #データが更新されている事を確認
      expect(json['data']['name']).to eq('new-name')
    end
  end

  describe "DELETE /destroy" do
    it 'SleepPatternを削除する' do
      sleep_pattern = create(:sleep_pattern)

      #データが削除されている事を確認
      expect { delete "/api/v1/sleep_patterns/#{sleep_pattern.id}" }.to change(SleepPattern, :count).by(-1)
  
      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
    end
  end
end
