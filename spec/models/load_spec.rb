require 'rails_helper'

RSpec.describe 'Loadモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    context 'nameカラム' do
      it '空欄がNGであること' do
        load = build(:load, name: '')
        expect(load).to be_invalid
      end

      it 'nullがNGであること' do
        load = build(:load, name: nil)
        expect(load).to be_invalid
      end

      it '255文字を超えたらNGであること' do
        load = build(:load,
          name: '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456'
        )
        expect(load).to be_invalid
      end
    end

    context 'sortカラム' do
      it '空欄がNGであること' do
        load = build(:load, sort: '')
        expect(load).to be_invalid
      end

      it 'nullがNGであること' do
        load = build(:load, sort: nil)
        expect(load).to be_invalid
      end

      it '数値以外はNGであること' do
        load = build(:load, sort: 'a')
        expect(load).to be_invalid
      end
    end
  end
end
