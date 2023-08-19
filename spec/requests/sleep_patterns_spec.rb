require 'rails_helper'

RSpec.describe "SleepPatternsコントローラーのテスト", type: :request do
  let(:authorized_headers) do
    # 認証用ヘルパを呼び出す(spec/support/authoriztion_spec_helpers.rb)
    authorized_user_headers
  end

  describe "GET /index" do
    context "全てのSleepPatternを取得する" do
      it '認証が通っている かつ データがある場合' do
        create_list(:sleep_pattern, 3)
    
        get api_v1_sleep_patterns_path, headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
    
        # 正しい数のデータが返されたか確認する。
        expect(json['data'].length).to eq(3)
      end

      it '認証が通っている かつ データがない場合' do
        # 404が返ってきたか確認する。
        expect(
          get api_v1_sleep_patterns_path, headers: authorized_headers
        ).to eq(404)
      end

      it '認証が通っていない場合' do
        get api_v1_sleep_patterns_path
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET /show" do
    context "特定のSleepPatternを取得する" do
      let(:sleep_pattern) { create(:sleep_pattern, name: 'test-name') }

      it '認証が通っている かつ データがある場合' do
        get "#{api_v1_sleep_patterns_path}/#{sleep_pattern.id}", headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
    
        # 要求した特定のSleepPatternのみ取得した事を確認する
        expect(json['data']['name']).to eq(sleep_pattern.name)
      end

      it '認証が通っている かつ データがない場合' do    
        # ActiveRecordのNotFoundエラーが発生することを確認する
        expect {
          get "#{api_v1_sleep_patterns_path}/test", headers: authorized_headers
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it '認証が通っていない場合' do
        get "#{api_v1_sleep_patterns_path}/#{sleep_pattern.id}"
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "POST /create" do
    context "新しいSleepPatternを作成する" do
      let(:valid_params) { { name: 'name', sort: 1 } }

      it '認証が通っている場合' do
        #データが作成されている事を確認
        expect { post api_v1_sleep_patterns_path,
          params: { sleep_pattern: valid_params },
          headers: authorized_headers
        }.to change(SleepPattern, :count).by(+1)
  
        # リクエスト成功を表す201が返ってきたか確認する。
        expect(response.status).to eq(201)
      end

      it '認証が通っていない場合' do
        post api_v1_sleep_patterns_path, params: { sleep_pattern: valid_params }
  
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "PUT /update" do
    context "SleepPatternの編集を行う" do
      let(:sleep_pattern) { create(:sleep_pattern, name: 'old-name') }
      let(:valid_params) { { name: 'new-name' } }

      it '認証が通っている場合' do
        put "#{api_v1_sleep_patterns_path}/#{sleep_pattern.id}",
          params: { sleep_pattern: valid_params },
          headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す201が返ってきたか確認する。
        expect(response.status).to eq(201)
    
        #データが更新されている事を確認
        expect(json['data']['name']).to eq('new-name')
      end

      it '認証が通っていない場合' do
        put "#{api_v1_sleep_patterns_path}/#{sleep_pattern.id}", params: { sleep_pattern: valid_params }
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE /destroy" do
    context "SleepPatternを削除する" do
      let!(:sleep_pattern) { create(:sleep_pattern) }

      it '認証が通っている場合' do
        #データが削除されている事を確認
        expect { delete "#{api_v1_sleep_patterns_path}/#{sleep_pattern.id}",
          headers: authorized_headers
        }.to change(SleepPattern, :count).by(-1)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
      end

      it '認証が通っていない場合' do
        delete "#{api_v1_sleep_patterns_path}/#{sleep_pattern.id}"
        
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end


  end
end
