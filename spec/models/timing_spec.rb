require 'rails_helper'

RSpec.describe 'Timingモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    context 'nameカラム' do
      it '空欄がNGであること' do
        timing = build(:timing, name: '')
        expect(timing).to be_invalid
      end

      it 'nullがNGであること' do
        timing = build(:timing, name: nil)
        expect(timing).to be_invalid
      end

      it '255文字を超えたらNGであること' do
        timing = build(:timing,
          name: '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456'
        )
        expect(timing).to be_invalid
      end
    end

    context 'sortカラム' do
      it '空欄がNGであること' do
        timing = build(:timing, sort: '')
        expect(timing).to be_invalid
      end

      it 'nullがNGであること' do
        timing = build(:timing, sort: nil)
        expect(timing).to be_invalid
      end

      it '数値以外はNGであること' do
        timing = build(:timing, sort: 'a')
        expect(timing).to be_invalid
      end
    end
  end
end
