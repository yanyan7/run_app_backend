require 'rails_helper'

RSpec.describe "Dailiesコントローラーのテスト", type: :request do
  let(:authorized_headers) do
    # 認証用ヘルパを呼び出す(spec/support/authoriztion_spec_helpers.rb)
    authorized_user_headers
  end

  describe "GET /index" do
    context "全てのDailyを取得する" do
      it '認証が通っている場合' do
        create_list(:daily, 3)
    
        get api_v1_dailies_path, headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
    
        # 正しい数のデータが返されたか確認する。
        expect(json['data'].length).to eq(3)
      end

      it '認証が通っていない場合' do
        get api_v1_dailies_path
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET /show" do
    context "特定のDailyを取得する" do
      let(:daily) { create(:daily, weight: 50) }

      it '認証が通っている場合' do
        get "#{api_v1_dailies_path}/#{daily.id}", headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
    
        # 要求した特定のDailyのみ取得した事を確認する
        expect(json['data']['weight']).to eq(daily.weight)
      end

      it '認証が通っていない場合' do
        get "#{api_v1_dailies_path}/#{daily.id}"
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "POST /create" do
    context "新しいDailyを作成する" do
      let(:valid_params) { { date: '2023-01-01', deleted: 0 } }

      it '認証が通っている場合' do
        #データが作成されている事を確認
        expect { post api_v1_dailies_path,
          params: { daily: valid_params },
          headers: authorized_headers
        }.to change(Daily, :count).by(+1)
  
        # リクエスト成功を表す201が返ってきたか確認する。
        expect(response.status).to eq(201)
      end

      it '認証が通っていない場合' do
        post api_v1_dailies_path, params: { daily: valid_params }
  
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "PUT /update" do
    context "Dailyの編集を行う" do
      let(:daily) { create(:daily, date: "2023-01-01") }
      let(:valid_params) { { date: '2023-01-02' } }

      it '認証が通っている場合' do
        put "#{api_v1_dailies_path}/#{daily.id}",
          params: { daily: valid_params },
          headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す201が返ってきたか確認する。
        expect(response.status).to eq(201)
    
        #データが更新されている事を確認
        expect(json['data']['date']).to eq('2023-01-02')
      end

      it '認証が通っていない場合' do
        put "#{api_v1_dailies_path}/#{daily.id}", params: { daily: valid_params }
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE /destroy" do
    context "Dailyを削除する" do
      let!(:daily) { create(:daily) }

      it '認証が通っている場合' do
        #データが削除されている事を確認
        expect { delete "#{api_v1_dailies_path}/#{daily.id}",
          headers: authorized_headers
        }.to change(Daily, :count).by(-1)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
      end

      it '認証が通っていない場合' do
        delete "#{api_v1_dailies_path}/#{daily.id}"
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end
end
