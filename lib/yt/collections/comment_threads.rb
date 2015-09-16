require 'yt/collections/resources'

module Yt
  module Collections
    class CommentThreads < Resources

      private

      def list_params
        super.tap{|params| params[:params] = comment_threads_params}
      end

      def comment_threads_params
        params = resources_params
        if @parent
          params.merge!(channel_id: @parent.id) if @parent.is_a? Yt::Channel
          params.merge!(video_id: @parent.id) if @parent.is_a? Yt::Video
        end
        apply_where_params! params
      end

      def insert_parts
        snippet = {keys: [:channel_id, :video_id], sanitize_brackets: true}
        {snippet: snippet}
      end

      def resources_params
        {max_results: 50, part: 'snippet,replies'}
      end

      def attributes_for_new_item(data)
        {id: data['id'], snippet: data['snippet'], comments: data['replies'].try(:[], 'comments'), auth: @auth}
      end

      def build_insert_body(attributes = {})
        text = attributes[:text] || attributes[:text_original]

        super.tap do |body|
          snippet = body[:snippet] || {}
          snippet[:channelId] = @parent.id if @parent.is_a? Yt::Channel
          snippet[:videoId] = @parent.id if @parent.is_a? Yt::Video
          snippet[:topLevelComment] = {:snippet => { :textOriginal => text } }
          body[:snippet] = snippet
        end
      end

    end
  end
end