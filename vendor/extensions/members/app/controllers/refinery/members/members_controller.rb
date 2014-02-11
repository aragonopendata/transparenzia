module Refinery
  module Members
    class MembersController < ::ApplicationController

      before_filter :find_all_members
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @member in the line below:
        present(@page)
      end

      def show
        @member = Member.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @member in the line below:
        present(@page)
      end

    protected

      def find_all_members
        @members = Member.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/members").first
      end

    end
  end
end
