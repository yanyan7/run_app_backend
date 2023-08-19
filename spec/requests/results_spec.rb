require 'rails_helper'

RSpec.describe "Resultsコントローラーのテスト", type: :request do
  let(:authorized_headers) do
    # 認証用ヘルパを呼び出す(spec/support/authoriztion_spec_helpers.rb)
    authorized_user_headers
  end

  describe "GET /index" do
    context "全てのResultを取得する" do
      it '認証が通っている場合' do
        create_list(:result, 3)
    
        get api_v1_results_path, headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
    
        # 正しい数のデータが返されたか確認する。
        expect(json['data'].length).to eq(3)
      end

      it '認証が通っていない場合' do
        get api_v1_results_path
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET /show" do
    context "特定のResultを取得する" do
      let(:result) { create(:result, content: 'test-content') }

      it '認証が通っている場合' do
        get "#{api_v1_results_path}/#{result.id}", headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
    
        # 要求した特定のResultのみ取得した事を確認する
        expect(json['data']['content']).to eq(result.content)
      end

      it '認証が通っていない場合' do
        get "#{api_v1_results_path}/#{result.id}"
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "POST /create" do
    let(:valid_params) do
      daily = create(:daily)

      {
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
    end

    context "新しいResultを作成する" do
      it '認証が通っている場合' do
        #データが作成されている事を確認
        expect { post api_v1_results_path,
          params: { result: valid_params },
          headers: authorized_headers
        }.to change(Result, :count).by(+1)
  
        # リクエスト成功を表す201が返ってきたか確認する。
        expect(response.status).to eq(201)
      end

      it '認証が通っていない場合' do
        post api_v1_results_path, params: { result: valid_params }
  
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "PUT /update" do
    context "Resultの編集を行う" do
      let(:result) { create(:result, content: 'old-content') }
      let(:valid_params) { { content: 'new-content' } }

      it '認証が通っている場合' do
        put "#{api_v1_results_path}/#{result.id}",
          params: { result: valid_params },
          headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す201が返ってきたか確認する。
        expect(response.status).to eq(201)
    
        #データが更新されている事を確認
        expect(json['data']['content']).to eq('new-content')
      end

      it '認証が通っていない場合' do
        put "#{api_v1_results_path}/#{result.id}", params: { result: valid_params }
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE /destroy" do
    context "Resultを削除する" do
      let!(:result) { create(:result) }

      it '認証が通っている場合' do
        #データが削除されている事を確認
        expect { delete "#{api_v1_results_path}/#{result.id}",
          headers: authorized_headers
        }.to change(Result, :count).by(-1)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
      end

      it '認証が通っていない場合' do
        delete "#{api_v1_results_path}/#{result.id}"
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end
end
