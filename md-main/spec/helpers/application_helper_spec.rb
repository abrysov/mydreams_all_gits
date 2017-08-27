require 'rails_helper'

describe ApplicationHelper do
  describe '#custom_pluralize' do
    specify do
      I18n.locale = :en
      helper.custom_pluralize(0, 'years').should eq 'years'
      helper.custom_pluralize(1, 'years').should eq 'year'
      helper.custom_pluralize(2, 'years').should eq 'years'
      I18n.locale = :ru
      helper.custom_pluralize(0, 'years').should eq 'лет'
      helper.custom_pluralize(1, 'years').should eq 'год'
      helper.custom_pluralize(2, 'years').should eq 'года'
    end
  end

  describe '#pretty_date' do
    specify do
      I18n.locale = :en
      helper.pretty_date(Date.new(2014, 11, 10)).should eq '10 november 2014'
      I18n.locale = :ru
      helper.pretty_date(Date.new(2014, 11, 10)).should eq '10 ноября 2014'
    end
  end

end
