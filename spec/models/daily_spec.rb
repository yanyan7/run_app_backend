require 'rails_helper'

RSpec.describe 'Dailyモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    context 'dateカラム' do
      it '空欄がNGであること' do
        daily = build(:daily, date: '')
        expect(daily).to be_invalid
      end

      it 'nullがNGであること' do
        daily = build(:daily, date: nil)
        expect(daily).to be_invalid
      end

      it 'yyyy/mm/dd以外はNGであること' do
        daily = build(:daily, date: '1a')
        expect(daily).to be_invalid
      end
    end

    context 'user_idカラム' do
      it 'nullがNGであること' do
        daily = build(:daily, user_id: nil)
        expect(daily).to be_invalid
      end
    end

    context 'sleep_pattern_idカラム' do
      it 'nullはOKであること' do
        daily = build(:daily, sleep_pattern_id: nil)
        expect(daily).to be_valid
      end

      it '数値以外はNGであること' do
        daily = build(:daily, sleep_pattern_id: 'a')
        expect(daily).to be_invalid
      end

      it '整数以外の数値はNGであること' do
        daily = build(:daily, sleep_pattern_id: 1.5)
        expect(daily).to be_invalid
      end
    end

    context 'weightカラム' do
      it 'nullはOKであること' do
        daily = build(:daily, weight: nil)
        expect(daily).to be_valid
      end

      it '数値以外はNGであること' do
        daily = build(:daily, weight: 'a')
        expect(daily).to be_invalid
      end
    end

    context 'deletedカラム' do
      it '空欄がNGであること' do
        daily = build(:daily, deleted: '')
        expect(daily).to be_invalid
      end

      it 'nullがNGであること' do
        daily = build(:daily, deleted: nil)
        expect(daily).to be_invalid
      end

      it '数値以外はNGであること' do
        daily = build(:daily, deleted: 'a')
        expect(daily).to be_invalid
      end
    end
  end
end
