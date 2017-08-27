require 'rails_helper'

RSpec.describe Moderate::ApplicationController, type: :controller do
  describe 'approve/ios_safe entity' do
    let!(:entity) { create %w{dream comment photo}.sample }
    let(:entity_from_db) { entity.class.to_s.constantize.find(entity.id) }
    let(:moderator) { create :dreamer, :moderator }
    before do
      sign_in moderator
    end

    context 'when approve' do
      before do
        xhr :get, :approve, entity_type: entity.class.to_s, entity_id: entity.id
      end

      it('is approved') { expect(entity_from_db).to be_approved }
      it('is not ios_safed') { expect(entity_from_db).not_to be_ios_safe }
      it('log created') do
        expect(
          ModeratorLog.where(logable: entity,
                             moderator_id: moderator.id,
                             action: 'approve')
        )
      end
    end

    context 'when ios_approve' do
      before do
        xhr :get, :approve_ios, entity_type: entity.class.to_s,
                                entity_id: entity.id
      end

      it('is approved') { expect(entity_from_db).to be_approved }
      it('is ios_safed') { expect(entity_from_db).to be_ios_safe }
      it('log created') do
        expect(
          ModeratorLog.where(logable: entity,
                             moderator_id: moderator.id,
                             action: 'ios_approve')
        )
      end
    end

    context 'when delete' do
      before do
        xhr :delete, :delete, entity_type: entity.class.to_s,
                              entity_id: entity.id
      end

      it('is deleted') { expect(entity_from_db).to be_deleted }
      it('is approved') { expect(entity_from_db).to be_approved }
      it('log created') do
        expect(
          ModeratorLog.where(logable: entity,
                             moderator_id: moderator.id,
                             action: 'ios_approve')
        )
      end
    end

    context 'when recovery' do
      before do
        xhr :put, :recovery, entity_type: entity.class.to_s,
                             entity_id: entity.id
      end

      it('is recovered') { expect(entity_from_db).not_to be_deleted }
      it('is approved') { expect(entity_from_db).to be_approved }
      it('log created') do
        expect(
          ModeratorLog.where(logable: entity,
                             moderator_id: moderator.id,
                             action: 'ios_approve')
        )
      end
    end
  end
end
