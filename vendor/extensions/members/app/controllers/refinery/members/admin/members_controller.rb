module Refinery
  module Members
    module Admin
      class MembersController < ::Refinery::AdminController

        crudify :'refinery/members/member',
                :title_attribute => 'name',
                :xhr_paging => true

      end
    end
  end
end
