require 'yt/models/resource'
require 'yt/models/comment'
require 'yt/collections/comments'

module Yt
  module Models
    # Provides methods to interact with YouTube playlists.
    # @see https://developers.google.com/youtube/v3/docs/playlists
    class CommentThread < Resource

      ### SNIPPET ###
      delegate :channel_id, to: :snippet

      delegate :video_id, to: :snippet

      delegate :can_replay, to: :snippet

      delegate :total_replay_count, to: :snippet

      delegate :is_public, to: :snippet

      attr_reader :top_level_comment

      has_many :comments

      def initialize(options = {})
        super options
        if snippet.top_level_comment
          @top_level_comment = Comment.new(snippet.top_level_comment.with_indifferent_access.merge(:auth => @auth))
        end
        if options[:comments]
          @comments = Yt::Collections::Comments.new(parent: self, auth: @auth, items: options[:comments])
        end
      end

      def delete(options = {})
        do_delete {@id = nil}
        !exists?
      end

      def update(attributes = {})
        super
      end

      def reply(text)
        comments.insert(:text_original => text)
      end

      private

      def exists?
        !@id.nil?
      end

      def update_parts
        snippet = {keys: [:channel_id, :video_id], required: true, sanitize_brackets: true}
        {snippet: snippet}
      end

      def build_update_body(attributes = {})
        text = attributes[:text] || attributes[:text_original]
        super.tap do |body|
          snippet = body[:snippet] || {}
          snippet[:topLevelComment] = {:snippet => { :textOriginal =>  text } } if text.present?
          body[:snippet] = snippet
        end
      end

    end
  end
end