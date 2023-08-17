require 'rails_helper'

RSpec.describe 'Resultモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    context 'daily_idカラム' do
      it 'nullがNGであること' do
        result = build(:result, daily_id: nil)
        expect(result).to be_invalid
      end
    end

    context 'dateカラム' do
      it '空欄がNGであること' do
        result = build(:result, date: '')
        expect(result).to be_invalid
      end

      it 'nullがNGであること' do
        result = build(:result, date: nil)
        expect(result).to be_invalid
      end

      it 'yyyy/mm/dd以外はNGであること' do
        result = build(:result, date: '1a')
        expect(result).to be_invalid
      end
    end

    context 'temperatureカラム' do
      it 'nullはOKであること' do
        result = build(:result, temperature: nil)
        expect(result).to be_valid
      end

      it '数値以外はNGであること' do
        result = build(:result, temperature: 'a')
        expect(result).to be_invalid
      end
    end

    context 'distanceカラム' do
      it 'nullはOKであること' do
        result = build(:result, distance: nil)
        expect(result).to be_valid
      end

      it '数値以外はNGであること' do
        result = build(:result, distance: 'a')
        expect(result).to be_invalid
      end
    end

    context 'time_hカラム' do
      it 'nullはOKであること' do
        result = build(:result, time_h: nil)
        expect(result).to be_valid
      end

      it '数値以外はNGであること' do
        result = build(:result, time_h: 'a')
        expect(result).to be_invalid
      end

      it '整数以外の数値はNGであること' do
        result = build(:result, time_h: 1.5)
        expect(result).to be_invalid
      end
    end

    context 'time_mカラム' do
      it 'nullはOKであること' do
        result = build(:result, time_m: nil)
        expect(result).to be_valid
      end

      it '数値以外はNGであること' do
        result = build(:result, time_m: 'a')
        expect(result).to be_invalid
      end

      it '整数以外の数値はNGであること' do
        result = build(:result, time_m: 1.5)
        expect(result).to be_invalid
      end

      it '60以上の数値はNGであること' do
        result = build(:result, time_m: 60)
        expect(result).to be_invalid
      end
    end

    context 'time_sカラム' do
      it 'nullはOKであること' do
        result = build(:result, time_s: nil)
        expect(result).to be_valid
      end

      it '数値以外はNGであること' do
        result = build(:result, time_s: 'a')
        expect(result).to be_invalid
      end

      it '整数以外の数値はNGであること' do
        result = build(:result, time_s: 1.5)
        expect(result).to be_invalid
      end

      it '60以上の数値はNGであること' do
        result = build(:result, time_s: 60)
        expect(result).to be_invalid
      end
    end

    context 'pace_mカラム' do
      it 'nullはOKであること' do
        result = build(:result, pace_m: nil)
        expect(result).to be_valid
      end

      it '数値以外はNGであること' do
        result = build(:result, pace_m: 'a')
        expect(result).to be_invalid
      end

      it '整数以外の数値はNGであること' do
        result = build(:result, pace_m: 1.5)
        expect(result).to be_invalid
      end

      it '60以上の数値はNGであること' do
        result = build(:result, pace_m: 60)
        expect(result).to be_invalid
      end
    end

    context 'pace_sカラム' do
      it 'nullはOKであること' do
        result = build(:result, pace_s: nil)
        expect(result).to be_valid
      end

      it '数値以外はNGであること' do
        result = build(:result, pace_s: 'a')
        expect(result).to be_invalid
      end

      it '整数以外の数値はNGであること' do
        result = build(:result, pace_s: 1.5)
        expect(result).to be_invalid
      end

      it '60以上の数値はNGであること' do
        result = build(:result, pace_s: 60)
        expect(result).to be_invalid
      end
    end

    context 'placeカラム' do
      it 'nullはOKであること' do
        result = build(:result, place: nil)
        expect(result).to be_valid
      end

      it '255文字を超えたらNGであること' do
        result = build(:result,
          place: '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456'
        )
        expect(result).to be_invalid
      end
    end

    context 'shoesカラム' do
      it 'nullはOKであること' do
        result = build(:result, shoes: nil)
        expect(result).to be_valid
      end

      it '255文字を超えたらNGであること' do
        result = build(:result,
          shoes: '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456'
        )
        expect(result).to be_invalid
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
