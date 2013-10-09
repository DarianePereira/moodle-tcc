require 'spec_helper'

describe Hub do
  let!(:hub) { Fabricate(:hub) }

  it { should respond_to(:category, :reflection, :grade, :commentary) }

  it 'should versioning' do
    old_version = hub.versions.size
    hub.update_attribute(:reflection, 'new content')
    hub.versions.size.should == (old_version + 1)
  end

  describe 'reflection' do
    it 'should allow empty reflection if hub is new or draft' do
      hub.reflection = ''

      hub.new?.should be_true
      hub.should be_valid

      hub.state = 'draft'
      hub.should be_valid
    end

    it 'should validate presence of reflection if hub is not new or draft' do
      hub.reflection = ''

      hub.state = 'sent_to_admin_for_revision'
      hub.should_not be_valid

      hub.state = 'sent_to_admin_for_evaluation'
      hub.should_not be_valid

      hub.state = 'admin_evaluation_ok'
      hub.should_not be_valid

      hub.state = 'terminated'
      hub.should_not be_valid
    end
  end

  describe 'grade_date' do
    it 'should be nil without grade' do
      hub.grade = nil
      hub.state = 'admin_evaluation_ok'
      hub.save
      hub.grade_date.should be_nil
    end

    it 'should be nil without admin_evaluation_ok' do
      hub.grade = 10
      hub.state = 'draft'
      hub.save
      hub.grade_date.should be_nil
    end

    it 'should be equal update_at with admin_evaluation_ok and grade' do
      hub.grade = 10
      hub.state = 'admin_evaluation_ok'
      hub.save
      hub.grade_date.should == hub.updated_at
    end

    it 'should not be equal update_at without admin_evaluation_ok' do
      hub.grade = 10
      hub.state = 'draft'
      hub.save
      hub.grade_date.should_not == hub.updated_at
    end
  end

  context 'email notification' do
    let(:tcc) { Fabricate.build(:tcc_with_definitions) }

    it 'should send email to orientador when state changed from draft to revision' do
      hub = Fabricate.build(:hub_tcc)
      hub.state = 'draft'
      hub.tcc = tcc

      hub.send_to_admin_for_revision

      ActionMailer::Base.deliveries.last.to.should == [tcc.email_orientador]
    end

    it 'should send email to orientador when state changed from draft to revision' do

      hub = Fabricate.build(:hub_tcc)
      hub.state = 'sent_to_admin_for_revision'
      hub.tcc = tcc

      hub.send_back_to_student

      ActionMailer::Base.deliveries.last.to.should == [tcc.email_estudante]
    end
  end
end
