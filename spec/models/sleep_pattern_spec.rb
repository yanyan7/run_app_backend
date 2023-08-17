require 'rails_helper'

RSpec.describe 'SleepPatternモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    context 'nameカラム' do
      it '空欄がNGであること' do
        sleepPattern = build(:sleep_pattern, name: '')
        expect(sleepPattern).to be_invalid
      end

      it 'nullがNGであること' do
        sleepPattern = build(:sleep_pattern, name: nil)
        expect(sleepPattern).to be_invalid
      end

      it '255文字を超えたらNGであること' do
        sleepPattern = build(:sleep_pattern,
          name: '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456'
        )
        expect(sleepPattern).to be_invalid
      end
    end

    context 'sortカラム' do
      it '空欄がNGであること' do
        sleepPattern = build(:sleep_pattern, sort: '')
        expect(sleepPattern).to be_invalid
      end

      it 'nullがNGであること' do
        sleepPattern = build(:sleep_pattern, sort: nil)
        expect(sleepPattern).to be_invalid
      end

      it '数値以外はNGであること' do
        sleepPattern = build(:sleep_pattern, sort: 'a')
        expect(sleepPattern).to be_invalid
      end
    end
  end
end
