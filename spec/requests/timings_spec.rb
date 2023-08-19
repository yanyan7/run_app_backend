require 'rails_helper'

RSpec.describe "Timingsコントローラーのテスト", type: :request do
  let(:authorized_headers) do
    # 認証用ヘルパを呼び出す(spec/support/authoriztion_spec_helpers.rb)
    authorized_user_headers
  end

  describe "GET /index" do
    context "全てのTimingを取得する" do
      it '認証が通っている場合' do
        create_list(:timing, 3)
    
        get api_v1_timings_path, headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
    
        # 正しい数のデータが返されたか確認する。
        expect(json['data'].length).to eq(3)
      end

      it '認証が通っていない場合' do
        get api_v1_timings_path
        json = JSON.parse(response.body)
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET /show" do
    context "特定のTimingを取得する" do
      let(:timing) { create(:timing, name: 'test-name') }

      it '認証が通っている場合' do
        get "#{api_v1_timings_path}/#{timing.id}", headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
    
        # 要求した特定のTimingのみ取得した事を確認する
        expect(json['data']['name']).to eq(timing.name)
      end

      it '認証が通っていない場合' do
        get "#{api_v1_timings_path}/#{timing.id}"
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "POST /create" do
    context "新しいTimingを作成する" do
      let(:valid_params) { {name: 'name', sort: 1} }

      it '認証が通っている場合' do
        #データが作成されている事を確認
        expect { post api_v1_timings_path,
          params: { timing: valid_params },
          headers: authorized_headers
        }.to change(Timing, :count).by(+1)
  
        # リクエスト成功を表す201が返ってきたか確認する。
        expect(response.status).to eq(201)
      end

      it '認証が通っていない場合' do
        post api_v1_timings_path, params: { timing: valid_params }
  
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "PUT /update" do
    context "Timingの編集を行う" do
      let(:timing) { create(:timing, name: 'old-name') }
      let(:valid_params) { { name: 'new-name' } }

      it '認証が通っている場合' do  
        put "#{api_v1_timings_path}/#{timing.id}",
          params: { timing: valid_params },
          headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す201が返ってきたか確認する。
        expect(response.status).to eq(201)
    
        #データが更新されている事を確認
        expect(json['data']['name']).to eq('new-name')
      end

      it '認証が通っていない場合' do
        timing = create(:timing, name: 'old-name')
  
        put "#{api_v1_timings_path}/#{timing.id}", params: { timing: valid_params }

        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE /destroy" do
    context "Timingを削除する" do
      let!(:timing) { create(:timing) }

      it '認証が通っている場合' do
        #データが削除されている事を確認
        expect { delete "#{api_v1_timings_path}/#{timing.id}",
          headers: authorized_headers
        }.to change(Timing, :count).by(-1)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
      end

      it '認証が通っていない場合' do
        delete "#{api_v1_timings_path}/#{timing.id}"
    
        # 認証エラーを表す401が返ってきたか確認する。
        expect(response.status).to eq(401)
      end
    end
  end
end
