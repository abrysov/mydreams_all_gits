module SocialNetworks
  module Providers
    class Base
      def initialize(provider)
        @provider = provider
      end

      def first_name
        @provider.meta[:info][:first_name] || 'User'
      end

      def last_name
        @provider.meta[:info][:last_name]
      end

      def email
        @provider.meta[:info][:email]
      end

      def photo
        @provider.meta[:info][:image]
      end

      def gender
        @provider.meta[:extra][:raw_info][:sex].to_s == '2' ? 'male' : 'female' rescue 'female'
      end

      def city
        @provider.meta[:info][:location].split(',').last.strip
      end

      def country
        @provider.meta[:info][:location].split(',').first.strip
      end

      def birthday
        @provider.meta[:extra][:raw_info][:bdate] rescue nil
      end
    end
  end
end
