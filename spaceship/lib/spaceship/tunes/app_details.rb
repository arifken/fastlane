module Spaceship
  module Tunes
    class AppDetails < TunesBase
      attr_accessor :application

      ####
      # Localized values
      ####

      # @return (Array) Raw access the all available languages. You shouldn't use it probbaly
      attr_accessor :languages

      # @return (Hash) A hash representing the app name in all languages
      attr_reader :name

      # @return (Hash) A hash representing the privacy URL in all languages
      attr_reader :privacy_url

      # @return (Hash) Some bla bla about privacy
      attr_reader :apple_tv_privacy_policy

      # Categories (e.g. MZGenre.Business)
      attr_accessor :primary_category

      attr_accessor :primary_first_sub_category

      attr_accessor :primary_second_sub_category

      attr_accessor :secondary_category

      attr_accessor :secondary_first_sub_category

      attr_accessor :secondary_second_sub_category

      attr_mapping(
        'localizedMetadata.value' => :languages,
        'primaryCategory.value' => :primary_category,
        'primaryFirstSubCategory.value' => :primary_first_sub_category,
        'primarySecondSubCategory.value' => :primary_second_sub_category,
        'secondaryCategory.value' => :secondary_category,
        'secondaryFirstSubCategory.value' => :secondary_first_sub_category,
        'secondarySecondSubCategory.value' => :secondary_second_sub_category
      )

      class << self
        # Create a new object based on a hash.
        # This is used to create a new object based on the server response.
        def factory(attrs)
          obj = self.new(attrs)
          obj.unfold_languages

          return obj
        end
      end

      # Prefill name, privacy url
      def unfold_languages
        {
          name: :name,
          privacyPolicyUrl: :privacy_url,
          privacyPolicy: :apple_tv_privacy_policy
        }.each do |json, attribute|
          instance_variable_set("@#{attribute}".to_sym, LanguageItem.new(json, languages))
        end
      end

      # Push all changes that were made back to iTunes Connect
      def save!
        client.update_app_details!(application.apple_id, raw_data)
      rescue Spaceship::TunesClient::ITunesConnectError => ex
        if ex.to_s == "operation_failed"
          # That's alright, we get this error message if nothing has changed
        else
          raise ex
        end
      end

      # Custom Setters
      #
      def primary_category=(value)
        value = "MZGenre.#{value}" unless value.include? "MZGenre"
        super(value)
      end

      def primary_first_sub_category=(value)
        value = "MZGenre.#{value}" unless value.include? "MZGenre"
        super(value)
      end

      def primary_second_sub_category=(value)
        value = "MZGenre.#{value}" unless value.include? "MZGenre"
        super(value)
      end

      def secondary_category=(value)
        value = "MZGenre.#{value}" unless value.include? "MZGenre"
        super(value)
      end

      def secondary_first_sub_category=(value)
        value = "MZGenre.#{value}" unless value.include? "MZGenre"
        super(value)
      end

      def secondary_second_sub_category=(value)
        value = "MZGenre.#{value}" unless value.include? "MZGenre"
        super(value)
      end

      #####################################################
      # @!group General
      #####################################################
      def setup
      end
    end
  end
end
