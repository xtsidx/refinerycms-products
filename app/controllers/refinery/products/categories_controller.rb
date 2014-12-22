module Refinery
  module Products
    class CategoriesController < ShopController
      # include Pages::RenderOptions
      include Refinery::Products::ControllerHelper

      # before_action :find_category, :set_canonical
      before_action :find_category
      # before_action :error_404, :unless => :current_user_can_view_page?

      # Save whole Page after delivery
      # after_action :write_cache?

      # This action is usually accessed with the root path, normally '/'
      # def home
      #   render_with_templates?
      # end

      # This action can be accessed normally, or as nested pages.
      # Assuming a page named "mission" that is a child of "about",
      # you can access the pages with the following URLs:
      #
      #   GET /pages/about
      #   GET /about
      #
      #   GET /pages/mission
      #   GET /about/mission
      #
      def show
        # if should_skip_to_first_child?
        #   redirect_to refinery.url_for(first_live_child.url) and return
        # elsif category.link_url.present?
        #   redirect_to category.link_url and return
        # elsif should_redirect_to_friendly_url?
        #   redirect_to refinery.url_for(category.url), :status => 301 and return
        # end

        if should_redirect_to_friendly_url?
          redirect_to refinery.url_for(category.url), :status => 301 and return
        end

        # render_with_templates?

        @products = @category.products.live.includes(:categories).with_globalize.page(params[:page])
      end

    protected

      def requested_friendly_id
        if ::Refinery::Pages.scope_slug_by_parent
          # Pick out last path component, or id if present
          "#{params[:path]}/#{params[:id]}".split('/').last
        else
          # Remove leading and trailing slashes in path, but leave internal
          # ones for global slug scoping
          params[:path].to_s.gsub(%r{\A/+}, '').presence || params[:id]
        end
      end

      # def should_skip_to_first_child?
      #   category.skip_to_first_child && first_live_child
      # end

      def should_redirect_to_friendly_url?
        requested_friendly_id != category.friendly_id || ::Refinery::Pages.scope_slug_by_parent && params[:path].present? && params[:path].match(page.root.slug).nil?
      end

      # def current_user_can_view_page?
      #   page.live? || current_refinery_user_can_access?("refinery_pages")
      # end

      # def current_refinery_user_can_access?(plugin)
      #   refinery_user? && current_refinery_user.authorized_plugins.include?(plugin)
      # end

      def first_live_child
        category.children.order('lft ASC').live.first
      end

      # def find_page(fallback_to_404 = true)
      #   @page ||= case action_name
      #             when "home"
      #               Refinery::Page.where(:link_url => '/').first
      #             when "show"
      #               Refinery::Page.find_by_path_or_id(params[:path], params[:id])
      #             end
      #   @page || (error_404 if fallback_to_404)
      # end
      def find_category(fallback_to_404 = true)
        @category ||= case action_name
                  when "show"
                    Refinery::Products::Category.find_by_path_or_id(params[:path], params[:id])
                  end
        @category || (error_404 if fallback_to_404)
      end

      # alias_method :page, :find_page
      alias_method :category, :find_category

      # def set_canonical
      #   @canonical = refinery.url_for @category.canonical if @category.present?
      # end

      # def write_cache?
      #   if Refinery::Pages.cache_pages_full && !refinery_user?
      #     cache_page(response.body, File.join('', 'refinery', 'cache', 'pages', request.path).to_s)
      #   end
      # end
    end
  end
end

# module Refinery
#   module Products
#     class CategoriesController < ShopController
#       include Refinery::Products::ControllerHelper

#       before_filter :find_page

#       # def show
#       #   @category = Refinery::Products::Category.friendly.find(params[:id])
#       #   @products = @category.products.live.includes(:categories).with_globalize.page(params[:page])
#       # end

#       def show
#         if should_skip_to_first_child?
#           redirect_to refinery.url_for(first_live_child.url) and return
#         elsif page.link_url.present?
#           redirect_to category.link_url and return
#         elsif should_redirect_to_friendly_url?
#           redirect_to refinery.url_for(category.url), :status => 301 and return
#         end

#         render_with_templates?
#       end

#       protected

#         def requested_friendly_id
#         if ::Refinery::Products::Category.scope_slug_by_parent
#           # Pick out last path component, or id if present
#           "#{params[:path]}/#{params[:id]}".split('/').last
#         else
#           # Remove leading and trailing slashes in path, but leave internal
#           # ones for global slug scoping
#           params[:path].to_s.gsub(%r{\A/+}, '').presence || params[:id]
#         end
#       end

#         def should_skip_to_first_child?
#           category.skip_to_first_child && first_live_child
#         end

#         def should_redirect_to_friendly_url?
#           requested_friendly_id != category.friendly_id || ::Refinery::Products::Category.scope_slug_by_parent && params[:path].present? && params[:path].match(category.root.slug).nil?
#         end

#         def first_live_child
#           category.children.order('lft ASC').live.first
#         end

#         def find_category(fallback_to_404 = true)
#           @category ||= case action_name
#                     when "home"
#                       Refinery::Page.find_by(:link_url => "#{Refinery::Products.shop_path}#{Refinery::Products.products_categories_path}")
#                     when "show"
#                       Refinery::Page.find_by_path_or_id(params[:path], params[:id])
#                     end
#           @category || (error_404 if fallback_to_404)
#         end

#         alias_method :category, :find_category

#         def find_page
#           @page = Refinery::Page.find_by(:link_url => "#{Refinery::Products.shop_path}#{Refinery::Products.products_categories_path}")
#         end
#     end
#   end
# end
