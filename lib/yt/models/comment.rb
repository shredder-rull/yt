require 'yt/models/resource'

module Yt
  module Models
    class Comment < Resource

      ### SNIPPET ###
      delegate :text_display, to: :snippet
      delegate :text_original, to: :snippet
      delegate :parent_id, to: :snippet
      delegate :author_display_name, to: :snippet
      delegate :author_profile_image_url, to: :snippet
      delegate :author_channel_url, to: :snippet
      delegate :author_channel_id, to: :snippet
      delegate :author_googleplus_profile_url, to: :snippet
      delegate :can_rate, to: :snippet
      delegate :viewer_rating, to: :snippet
      delegate :like_count, to: :snippet
      delegate :moderation_status, to: :snippet
      delegate :published_at, to: :snippet
      delegate :updated_at, to: :snippet

      def delete(options = {})
        do_delete {@id = nil}
        !exists?
      end

      def update(attributes = {})
        super
      end

      private

      def exists?
        !@id.nil?
      end

      def update_parts
        snippet = {keys: [:text_original], sanitize_brackets: true}
        {snippet: snippet}
      end

    end
  end
end