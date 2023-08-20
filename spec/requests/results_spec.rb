require 'rails_helper'

RSpec.describe "Resultsコントローラーのテスト", type: :request do
  let(:authorized_headers) do
    # 認証用ヘルパを呼び出す(spec/support/authoriztion_spec_helpers.rb)
    authorized_user_headers
  end

  describe "GET /index" do
    context "全てのResultを取得する" do
      context "認証が通っている場合" do
        context "クエリパラメータがある場合" do
          it 'データがある場合' do
            user = create(:user)
            daily = Daily.create(
              date: "2023-08-01",
              user_id: user.id,
              sleep_pattern_id: nil,
              weight: nil,
              note: nil,
              deleted: 0
            )
            Daily.create(
              date: "2023-08-31",
              user_id: user.id,
              sleep_pattern_id: nil,
              weight: nil,
              note: nil,
              deleted: 0
            )
            Daily.create(
              date: "2023-09-01",
              user_id: user.id,
              sleep_pattern_id: nil,
              weight: nil,
              note: nil,
              deleted: 0
            )
            Daily.create(
              date: "2023-08-01",
              user_id: 1234,
              sleep_pattern_id: nil,
              weight: nil,
              note: nil,
              deleted: 0
            )
            2.times do
              Result.create(
                daily_id: daily.id,
                user_id: user.id,
                date: "2023-08-01",
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
                note: nil
              )
            end

            get "#{api_v1_results_path}?user_id=#{user.id}&year_month=2023-08", headers: authorized_headers
            json = JSON.parse(response.body)
        
            # リクエスト成功を表す200が返ってきたか確認する。
            expect(response.status).to eq(200)
        
            # 正しい数のデータが返されたか確認する。
            expect(json['data'].length).to eq(3)
          end
    
          it 'データがない場合' do
            # 404が返ってきたか確認する。
            expect(
              get "#{api_v1_results_path}?user_id=1234&year_month=2100-01", headers: authorized_headers
            ).to eq(404)
          end
        end

        context "クエリパラメータがない場合" do
          it do
            # 422が返ってきたか確認する。
            expect(
              get api_v1_results_path, headers: authorized_headers
            ).to eq(422)
          end
        end
      end

      context "認証が通っていない場合" do
        it do
          get api_v1_results_path
      
          # 認証エラーを表す401が返ってきたか確認する。
          expect(response.status).to eq(401)
        end
      end
    end
  end

  describe "GET /show" do
    context "特定のResultを取得する" do
      let(:result) { create(:result, content: 'test-content') }

      it '認証が通っている かつ データがある場合' do
        get "#{api_v1_results_path}/#{result.id}", headers: authorized_headers
        json = JSON.parse(response.body)
    
        # リクエスト成功を表す200が返ってきたか確認する。
        expect(response.status).to eq(200)
    
        # 要求した特定のResultのみ取得した事を確認する
        expect(json['data']['content']).to eq(result.content)
      end

      it '認証が通っている かつ データがない場合' do    
        # ActiveRecordのNotFoundエラーが発生することを確認する
        expect {
          get "#{api_v1_results_path}/test", headers: authorized_headers
        }.to raise_error(ActiveRecord::RecordNotFound)
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
      {
        daily_id: create(:daily).id,
        user_id: create(:user).id,
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
