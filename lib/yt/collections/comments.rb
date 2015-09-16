require 'yt/collections/resources'
module Yt
  module Collections
    class Comments < Resources

      private

      def list_params
        super.tap{|params| params[:params] = comments_params}
      end

      def comments_params
        params = resources_params
        params.merge!(parent_id: @parent.id) if @parent.present?
        apply_where_params! params
      end

      def insert_parts
        snippet = {keys: [:text_original], sanitize_brackets: true}
        {snippet: snippet}
      end

      def resources_params
        {max_results: 50, part: 'snippet'}
      end

      def build_insert_body(attributes = {})
        super(attributes).tap do |body|
          snippet = body[:snippet] || {}
          snippet[:parentId] = @parent.id if @parent.present?
          body[:snippet] = snippet
        end
      end

    end
  end
end